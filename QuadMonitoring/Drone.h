//
//  Drone.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Route;
@class Sensor;
@class Command;
@class CLLocation;

@interface Drone : NSObject

@property (nonatomic) NSInteger  droneId;
@property (nonatomic) BOOL available;
@property (nonatomic) BOOL status;
@property (nonatomic) DroneType type;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) NSMutableSet *sensors;

- (void)addNewCommands:(NSArray *)commands;
- (void)addNewRoutes:(NSArray *)routes;
- (void)addNewSensor:(Sensor *)sensor;

- (NSArray *)getRoutePath;
- (NSString *)statusString;


@end
