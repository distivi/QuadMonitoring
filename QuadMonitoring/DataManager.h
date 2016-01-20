//
//  DataManager.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Drone;
@class Route;
@class Sensor;
@class SensorValue;
@class Command;

@interface DataManager : NSObject

- (void)getDronesWithCallback:(CompletitionBlock)completition;
- (void)getCommandsForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition;
- (void)getRoutesForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition;
- (void)getSensorForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition;
- (void)getValuesForSensor:(Sensor *)sensor withCallback:(CompletitionBlock)completition;


@end
