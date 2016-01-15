//
//  MapViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/27/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "DroneAnnotation.h"
#import "DrawUtils.h"
#import "MonitoringObject.h"
#import "Engine.h"
#import "BaseAnnotation.h"

// https://github.com/100grams/Moving-MKAnnotationView

@interface MapViewController ()<CLLocationManagerDelegate,MonitoringObjectDelegate>

@property (nonatomic, strong) NSArray *testCoords;
@property (nonatomic) NSInteger currentPositionIndex;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DroneAnnotation *testDroneAnnotation;
@property (nonatomic, weak) MKAnnotationView *testDroneView;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISwitch *followMeSwitch;

@property (nonatomic, strong) NSMutableArray *monitoringObjects;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLocationManager];
    [self setupMonitoringObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.monitoringObjects makeObjectsPerformSelector:@selector(stopMonitoring)];
    [super viewDidDisappear:animated];
}

#pragma mark - Setup methods

- (void)setupMonitoringObjects
{
    self.monitoringObjects = [NSMutableArray array];
    
    [[[Engine sharedEngine] dataManager] getAvailableMonitoringObjectsWithCallBack:^(BOOL success, id result) {
        if (success) {
            NSArray *objectsIds = result;
            for (NSString *identifier in objectsIds) {
                MonitoringObject *mo = [[MonitoringObject alloc] initWithIdentifier:identifier];
                mo.delegate = self;
                [self.monitoringObjects addObject:mo];
                [self.mapView addAnnotation:mo.annotation];
                
                [mo startMonitoring];
            }
        } else {
            NSLog(@"error: %@",result);
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
    if (sender.isOn) {
        [self moveToUserLocation];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    if (self.followMeSwitch.isOn) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(lastLocation.coordinate, 1000, 1000);
        [self.mapView setRegion:viewRegion animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Drone";
    
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIImage *image = [DrawUtils droneImage];
        annotationView.image = image;
        
        self.testDroneView = annotationView;
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
    
}

#pragma mark - MonitoringObjectDelegate

- (void)monitoringObject:(MonitoringObject *)sender didChangePosition:(CLLocationCoordinate2D)coordinate
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        // there should be view animation
        
        MKAnnotationView *annotationView = [self.mapView viewForAnnotation:sender.annotation];
        if (CLLocationCoordinate2DIsValid(coordinate)) {
            CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
            NSLog(@"point: %@",NSStringFromCGPoint(point));
            annotationView.center = point;
        }
        
    } completion:nil];
}

@end
