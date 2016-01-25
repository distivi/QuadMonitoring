//
//  DroneDetailsViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "DroneDetailsViewController.h"
#import "BatteryView.h"
#import "UIImage+Drone.h"
#import "Constants.h"
#import "Drone.h"
#import "TasksTableViewController.h"

#define kSegueTasks     @"taskSegue"

@interface DroneDetailsViewController()

@property (nonatomic, weak) IBOutlet UIImageView *droneIconView;
@property (nonatomic, weak) IBOutlet UIImageView *videoStreamView;

@property (nonatomic, weak) IBOutlet UILabel *droneTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *availableLabel;
@property (nonatomic, weak) IBOutlet BatteryView *batteryView;


@end

@implementation DroneDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.droneTitleLabel.layer.borderWidth = 1.0;
    self.droneTitleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self updateUI];
}

- (void)setDrone:(Drone *)drone
{
    _drone = drone;
    
    [self updateUI];
}

- (void)updateUI
{
    self.droneIconView.image = [UIImage imageForDrone:self.drone];
    self.droneTitleLabel.text = FORMAT(@" Drone(#%zd): %@",self.drone.droneId,self.drone.name);
    
    self.statusLabel.text = FORMAT(@"Status: %@",[self.drone statusString]);
    self.availableLabel.text = FORMAT(@"Available: %@",self.drone.available ? @"YES" : @"NO");
}

#pragma mark - IBActions

- (IBAction)showSensors:(id)sender
{
    
}

- (IBAction)getVideoStream:(id)sender
{
    
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTasks]) {
        TasksTableViewController *nextVC = segue.destinationViewController;
        nextVC.drone = self.drone;
    }
}

@end
