//
//  UIImage+Drone.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "UIImage+Drone.h"
#import "Drone.h"

@implementation UIImage (Drone)

+ (UIImage *)imageForDrone:(Drone *)drone
{
    NSString *imageName = nil;
    switch (drone.type) {
        case DroneTypeMachine:
            imageName = @"cell_car";
            break;
            case DroneTypeAircraft:
        imageName= @"cell_drone";
            break;
    }
    
    if (imageName) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}

@end
