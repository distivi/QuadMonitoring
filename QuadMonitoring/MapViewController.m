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

// https://github.com/100grams/Moving-MKAnnotationView

@interface MapViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *testCoords;
@property (nonatomic) NSInteger currentPositionIndex;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DroneAnnotation *testDroneAnnotation;
@property (nonatomic, weak) MKAnnotationView *testDroneView;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISwitch *followMeSwitch;

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
    
    [self moveToTestPoint];
    [self setupTestDrone];
}

#pragma mark - Setup methods

- (void)setupTestDrone
{
    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(46.971447, 32.014508);
    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(46.972307, 32.014188);
    CLLocationCoordinate2D coord3 = CLLocationCoordinate2DMake(46.972471, 32.010448);
    CLLocationCoordinate2D coord4 = CLLocationCoordinate2DMake(46.971170, 32.010905);
    
    self.testDroneAnnotation = [[DroneAnnotation alloc] initWithName:@"Bot Drone" info:@"Test flight" coordinate:coord1];
    [self.mapView addAnnotation:self.testDroneAnnotation];

    self.testCoords = @[[NSValue valueWithMKCoordinate:coord1],
                        [NSValue valueWithMKCoordinate:coord2],
                        [NSValue valueWithMKCoordinate:coord3],
                        [NSValue valueWithMKCoordinate:coord4]];
    self.currentPositionIndex = 0;
    
    [self updateTestDronePosition];
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

- (void)updateTestDronePosition
{
    
    if(++self.currentPositionIndex == self.testCoords.count)
        self.currentPositionIndex = 0;
    
    NSValue *coordValue = self.testCoords[self.currentPositionIndex];
    CLLocationCoordinate2D coord = [coordValue MKCoordinateValue];
    [self.testDroneAnnotation updatePosition:coord];
    CGPoint toPos = [self.mapView convertCoordinate:coord toPointToView:self.mapView];
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.testDroneView.center = toPos;
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateTestDronePosition];
        }
    }];
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
    if ([annotation isKindOfClass:[DroneAnnotation class]]) {
        
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
    
    return nil;
}

@end
