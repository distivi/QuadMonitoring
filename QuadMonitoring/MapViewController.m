//
//  MapViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/27/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

#import "DrawUtils.h"
#import "MonitoringObject.h"
#import "Engine.h"

#import "BaseAnnotation.h"
#import "DroneAnnotation.h"
#import "CarAnnotation.h"
#import "CommandAnnotation.h"

// https://github.com/100grams/Moving-MKAnnotationView

@interface MapViewController ()<CLLocationManagerDelegate,MonitoringObjectDelegate>

@property (nonatomic, strong) NSArray *testCoords;
@property (nonatomic) NSInteger currentPositionIndex;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISwitch *followMeSwitch;
@property (nonatomic, weak) IBOutlet UILabel *dronesCountLabel;

@property (nonatomic, strong) NSMutableArray *monitoringObjects;
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineRenderer *polilineRender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLocationManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupMonitoringObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.monitoringObjects makeObjectsPerformSelector:@selector(stopMonitoring)];
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
    
    [[[Engine sharedEngine] dataManager] getDronesWithCallback:^(BOOL success, id result) {
        if (success) {
            BOOL isFirst = YES;
            for (Drone *dron in result) {
                MonitoringObject *mo = [[MonitoringObject alloc] initWithDrone:dron];
                if (![self.monitoringObjects containsObject:mo]) {
                    [self.monitoringObjects addObject:mo];
                    mo.delegate = self;
                    
                    if (isFirst) {
                        [mo startMonitoring];
                        isFirst = NO;
                    }
                    
                    
                    [self.mapView addAnnotation:mo.annotation];
                }
            }
            
            self.dronesCountLabel.text = [NSString stringWithFormat:@"Drones: %zd",self.monitoringObjects.count];
        }
    }];    
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

#pragma mark - Map Drawing

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
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
        lineView.strokeColor = [UIColor redColor];
        
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
    [self drawLineWithLocationArray:routePath];
}

@end
