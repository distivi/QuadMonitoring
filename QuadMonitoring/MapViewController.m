//
//  MapViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/27/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

#import "MonitoringObject.h"
#import "Engine.h"

#import "BaseAnnotation.h"
#import "DroneAnnotation.h"
#import "CarAnnotation.h"
#import "CommandAnnotation.h"

#import "DroneTableViewController.h"

#import "TargetView.h"

// https://github.com/100grams/Moving-MKAnnotationView

#define kSegueDronesTable   @"dronesTable"

@interface MapViewController ()<CLLocationManagerDelegate,MonitoringObjectDelegate,DroneTableViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *heightArray;
}

@property (nonatomic, strong) NSArray *testCoords;
@property (nonatomic) NSInteger currentPositionIndex;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISwitch *followMeSwitch;
@property (nonatomic, weak) IBOutlet UIView *defaultHeaderView;
@property (nonatomic, weak) IBOutlet UILabel *dronesCountLabel;

@property (nonatomic, strong) NSMutableArray *monitoringObjects;
@property (nonatomic, strong) MKPolyline *routeForNewTask;
@property (nonatomic, strong) NSMutableArray *coordsArrayForNewTask;

@property (nonatomic, weak) IBOutlet UIView *backgroundForSideMenuView;


// this menu show up from left side
@property (nonatomic, weak) IBOutlet UIView *droneSideMenu;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *droneSideMenuLeftConstraint;

// add task mode views
@property (nonatomic, weak) IBOutlet UIView *addTaskHeaderView;
@property (nonatomic, weak) IBOutlet UIPickerView *heightPickerView;
@property (nonatomic, weak) IBOutlet TargetView *targetView;
@property (nonatomic, weak) IBOutlet UIButton *undoTaskButton;

// popup controllers
@property (nonatomic, weak) DroneTableViewController *dronesController;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLocationManager];
    [self setupSideMenus];
    
    [self updateUIForDefaultMode];
    
    heightArray = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.droneSideMenu updateConstraintsIfNeeded];
    
    [self setupMonitoringObjects];
    
    [self subscribeForNotifications:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.monitoringObjects makeObjectsPerformSelector:@selector(stopMonitoring)];
    [self subscribeForNotifications:NO];
    [super viewDidDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)clearData
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.monitoringObjects removeAllObjects];
    self.monitoringObjects = nil;
}

#pragma mark - Setup methods

- (void)setupMonitoringObjects
{
    self.monitoringObjects = [NSMutableArray array];
    
    [self updateDrones:nil];
}


- (void)setupLocationManager
{
    // Create a location manager
    self.locationManager = [[CLLocationManager alloc] init];
    // Set a delegate to receive location callbacks
    self.locationManager.delegate = self;
    // Start the location manager
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)setupSideMenus
{
    self.backgroundForSideMenuView.alpha = 0.0;
    
    self.droneSideMenu.layer.masksToBounds = NO;
    self.droneSideMenu.layer.shadowOffset = CGSizeMake(3, 0);
    self.droneSideMenu.layer.shadowRadius = 10;
    self.droneSideMenu.layer.shadowOpacity = 0.5;
    self.droneSideMenu.layer.cornerRadius = 2.0;
    
    self.droneSideMenu.hidden = YES;
    self.droneSideMenuLeftConstraint.constant = -CGRectGetWidth(self.droneSideMenu.bounds);
    [self.view layoutIfNeeded];
}

- (void)updateUIForDefaultMode
{
    self.addTaskHeaderView.hidden =
    self.targetView.hidden =
    self.heightPickerView.hidden = YES;
    
    self.defaultHeaderView.hidden = NO;
}

- (void)updateUIForAddTaskMode
{
    self.addTaskHeaderView.hidden =
    self.targetView.hidden =
    self.heightPickerView.hidden = NO;
    
    self.defaultHeaderView.hidden = YES;
    self.undoTaskButton.hidden = YES;
}

#pragma mark - Animations

- (void)showDroneMenu
{
    self.dronesController.drones = [self.monitoringObjects valueForKey:@"drone"];
    self.droneSideMenu.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundForSideMenuView.alpha = 1.0;
        self.droneSideMenuLeftConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideDroneMenu
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundForSideMenuView.alpha = 0.0;
        self.droneSideMenuLeftConstraint.constant = -CGRectGetWidth(self.droneSideMenu.bounds);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.droneSideMenu.hidden = YES;
        }
    }];
}

#pragma mark - Move

- (void)moveToTestPoint
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 46.972307;
    zoomLocation.longitude = 32.014188;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)moveToUserLocation
{
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 1;
    span.longitudeDelta = 1;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - IBActions

- (IBAction)followMeStatusChanged:(UISwitch *)sender
{
    [self.mapView setUserTrackingMode:sender.isOn ? MKUserTrackingModeFollow : MKUserTrackingModeNone];
}

- (IBAction)droneMenuButtonTaped:(UIButton *)sender {
    [self showDroneMenu];
}

- (IBAction)backgroundForSideMenuTaped:(UITapGestureRecognizer *)sender {
    if (!self.droneSideMenu.hidden) {
        CGPoint location = [sender locationInView:self.view];
        if (!CGRectContainsPoint(self.droneSideMenu.frame, location)) {
            [self hideDroneMenu];
        }
    }
}

#pragma mark - Map Drawing

- (void)addPolylineForNewTask
{
    self.routeForNewTask = [self createPolylineWithLocationArray:self.coordsArrayForNewTask];
    [self.mapView addOverlay:self.routeForNewTask];
}


- (void)drawLineForLocationArray:(NSArray *)locationArray
{
    MKPolyline *routeLine  = [self createPolylineWithLocationArray:locationArray];
    [self.mapView addOverlay:routeLine];
}
     

- (MKPolyline *)createPolylineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    free(coordinateArray);
    coordinateArray = NULL;
    
    return routeLine;
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLLocation *lastLocation = [locations lastObject];
//    
//    
//    
//    if (self.followMeSwitch.isOn) {
//        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(lastLocation.coordinate, 1000, 1000);
//        [self.mapView setRegion:viewRegion animated:YES];
//    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifierDrone = @"Drone";
    static NSString *identifierCar = @"Car";
    static NSString *identifierCommand = @"Command";
    
    NSString *currentID = nil;
    
    if ([annotation isKindOfClass:[DroneAnnotation class]]) {
        currentID = identifierDrone;
    } else if ([annotation isKindOfClass:[CarAnnotation class]]) {
        currentID = identifierCar;
    } else if ([annotation isKindOfClass:[CommandAnnotation class]]) {
        currentID = identifierCommand;
    }
    
    if ([annotation isKindOfClass:[BaseAnnotation class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:currentID];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:currentID];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIImage *image = [(BaseAnnotation *)annotation icon];
            annotationView.image = image;
            annotationView.layer.anchorPoint = CGPointMake(0.5, 1);
        } else {
            annotationView.image = [(BaseAnnotation *)annotation icon];
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:MKPolyline.class]) {

        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        if (overlay == self.routeForNewTask) {
            lineView.strokeColor = [UIColor greenColor];
//            lineView.lineDashPattern = @[@5, @3];
            lineView.alpha = 0.6;
        } else {
            lineView.strokeColor = [UIColor redColor];
        }
        
        return lineView;
    }
    
    return nil;
}

#pragma mark - MonitoringObjectDelegate

- (void)monitoringObject:(MonitoringObject *)sender didChangePosition:(CLLocationCoordinate2D)coordinate
{
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        // there should be view animation
//        
//        MKAnnotationView *annotationView = [self.mapView viewForAnnotation:sender.annotation];
//        if (CLLocationCoordinate2DIsValid(coordinate)) {
//            CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
//            NSLog(@"point: %@",NSStringFromCGPoint(point));
//            annotationView.center = point;
//        }
//        
//    } completion:nil];
}

- (void)monitoringObject:(MonitoringObject *)sender didAddNewCommandAnnotation:(CommandAnnotation *)commandAnnotation
{
    if (CLLocationCoordinate2DIsValid(commandAnnotation.coordinate)) {
        NSLog(@"Command coordinate Valid");
    } else {
        NSLog(@"Command coordinate INVALID");
    }
    [self.mapView addAnnotation:commandAnnotation];
}

- (void)monitoringObject:(MonitoringObject *)sender updatedRoutePath:(NSArray *)routePath
{
    [self drawLineForLocationArray:routePath];
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueDronesTable]) {
        UINavigationController *navigation = segue.destinationViewController;
        self.dronesController = [[navigation viewControllers] firstObject];
        self.dronesController.dronesDelegate = self;
    }
}

#pragma mark - DronesTableViewControllerDelegate

- (void)dronesController:(DroneTableViewController *)controller wantRefreshDronesList:(CompletitionBlock)callBack
{
    [self updateDrones:^(BOOL success, id result) {
        if (callBack) {
            if (success) {
                NSArray *drones = [self.monitoringObjects valueForKey:@"drone"];
                callBack(YES,drones);
            } else {
                callBack(NO, nil);
            }
        }
    }];
}

- (void)updateDrones:(CompletitionBlock)completition
{
    [[[Engine sharedEngine] dataManager] getDronesWithCallback:^(BOOL success, id result) {
        if (success) {
            BOOL isFirst = YES;
            for (Drone *dron in result) {
                MonitoringObject *mo = [[MonitoringObject alloc] initWithDrone:dron];
                if (![self.monitoringObjects containsObject:mo]) {
                    [self.monitoringObjects addObject:mo];
                    mo.delegate = self;
                    
                    if (isFirst) {
//                        [mo startMonitoring];
                        isFirst = NO;
                    }
                    
                    
                    [self.mapView addAnnotation:mo.annotation];
                }
            }
            
            self.dronesCountLabel.text = [NSString stringWithFormat:@"Drones: %zd",self.monitoringObjects.count];
        }
        
        if (completition) {
            completition(success,nil);
        }
    }];
}

#pragma mark - Notifications

- (void)subscribeForNotifications:(BOOL)isSubscribe
{
    if (isSubscribe) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mustAddRouteForNewTaks:) name:KNotificationAddRouteForTask object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)mustAddRouteForNewTaks:(NSNotification *)notification
{
    [self hideDroneMenu];
    [self updateUIForAddTaskMode];
    
    self.coordsArrayForNewTask = [NSMutableArray array];
}

#pragma mark - Add Route mode methods

- (IBAction)undoLastTaskPosition:(id)sender
{
    if (self.coordsArrayForNewTask.count > 0) {
        [self.coordsArrayForNewTask removeLastObject];
        
        if (self.routeForNewTask) {
            [self.mapView removeOverlay:self.routeForNewTask];
        }
        
        if (self.coordsArrayForNewTask.count > 0) {
            [self addPolylineForNewTask];
        } else {
            self.undoTaskButton.hidden = YES;
        }
    }
}

- (IBAction)addPositionToTaskRoute:(id)sender
{
    CGPoint mapCenter = CGPointMake(CGRectGetMidX(self.mapView.bounds), CGRectGetMidY(self.mapView.bounds));
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self.coordsArrayForNewTask addObject:location];
    
    if (self.routeForNewTask) {
        [self.mapView removeOverlay:self.routeForNewTask];
    }
    
    [self addPolylineForNewTask];
    
    if (self.coordsArrayForNewTask.count > 0) {
        self.undoTaskButton.hidden = NO;
    }
}

- (IBAction)cancelNewTaskEditing:(id)sender
{
    [self updateUIForDefaultMode];
    [self showDroneMenu];
    [self removeTestOverlay];
}

- (void)removeTestOverlay
{
    [self.coordsArrayForNewTask removeAllObjects];
    self.coordsArrayForNewTask = nil;
    
    if (self.routeForNewTask) {
        [self.mapView removeOverlay:self.routeForNewTask];
        self.routeForNewTask = nil;
    };
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [heightArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return FORMAT(@"%@ m",heightArray[row]);
}



@end
