//
//  DroneTableViewCell.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/22/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "DroneTableViewCell.h"
#import "Drone.h"
#import "UIImage+Drone.h"

@implementation DroneTableViewCell

- (void)setDrone:(Drone *)drone
{
    _drone = drone;
    
    self.droneIcon.image = [UIImage imageForDrone:self.drone];
    self.droneTitle.text = [NSString stringWithFormat:@"Drone(#%zd): %@",self.drone.droneId,self.drone.name];
    
//    self.batteryView = self.drone.batteryLevel;
}

@end
