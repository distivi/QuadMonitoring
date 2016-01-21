//
//  MonitoringObject.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "MonitoringObject.h"
#import "Engine.h"
#import "BaseAnnotation.h"
#import "DroneAnnotation.h"
#import "CarAnnotation.h"
#import "CommandAnnotation.h"

#import "Drone.h"
#import "Sensor.h"
#import "Command.h"


@interface MonitoringObject()

@property (nonatomic, strong) NSTimer *monitoringTimer;

@end

@implementation MonitoringObject

- (instancetype)initWithDrone:(Drone *)drone
{
    if (self = [super init]) {
        self.drone = drone;
        [self setupAnnotation];
        _commandsAnnorations = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self.drone.droneId == [[(MonitoringObject *)object drone] droneId]) {
        return YES;
    }
    return NO;
}

- (void)setupAnnotation
{
    NSString *name = [NSString stringWithFormat:@"Drone #%zd",self.drone.droneId];
    
    BaseAnnotation *annotation = nil;
    switch (self.drone.type) {
        case DroneTypeAircraft:
            annotation = [[DroneAnnotation alloc] initWithName:name info:self.drone.name coordinate:CLLocationCoordinate2DMake(10, 10)];
            break;
        case DroneTypeMachine:
            annotation = [[CarAnnotation alloc] initWithName:name info:self.drone.name coordinate:CLLocationCoordinate2DMake(0, 0)];
            break;
    }
    _annotation = annotation;
}

- (void)setupCommandAnnotation
{
    for (Command *command in self.drone.commands) {
        
        CommandAnnotation *annotation = [[CommandAnnotation alloc] initWithCommand:command];
        if (![self.commandsAnnorations containsObject:annotation]) {
            [self.commandsAnnorations addObject:annotation];
            
            if ([self.delegate respondsToSelector:@selector(monitoringObject:didAddNewCommandAnnotation:)]) {
                [self.delegate monitoringObject:self didAddNewCommandAnnotation:annotation];
            }
        }
    }
}

- (void)dealloc
{
    [self stopMonitoring];
}

- (void)startMonitoring
{
    if (!self.monitoringTimer) {
        self.monitoringTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(getInfoFromServer:) userInfo:nil repeats:YES];
        [self getInfoFromServer:nil];
    }
}

- (void)stopMonitoring
{
    if (self.monitoringTimer) {
        [self.monitoringTimer invalidate];
        self.monitoringTimer = nil;
    }
}


#pragma mark - Private methods

- (void)getInfoFromServer:(NSTimer *)sender
{
//    if (self.drone.sensors.count == 0) {
//        [self getSensors];
//    } else {
//        for (Sensor *sensor in self.drone.sensors) {
//            [self getValuesForSensor:sensor];
//        }
//    }
    [self getCommands];
    [self getRoutes];
    
}

- (void)getCommands
{
    [[[Engine sharedEngine] dataManager] getCommandsForDrone:self.drone withCallback:^(BOOL success, id result) {
        if (success) {
            [self.drone addNewCommands:result];
            [self setupCommandAnnotation];
        } else {
            NSLog(@"getCommand error: %@",result);
        }
    }];
}

- (void)getRoutes
{
    [[[Engine sharedEngine] dataManager] getRoutesForDrone:self.drone withCallback:^(BOOL success, id result) {
        if (success) {
            [self.drone addNewRoutes:result];
            
            NSArray *routePath = [self.drone getRoutePath];
            if ([self.delegate respondsToSelector:@selector(monitoringObject:updatedRoutePath:)]) {
                [self.delegate monitoringObject:self updatedRoutePath:routePath];
            }
            
            CLLocation *location = [routePath lastObject];
            if (location) {
                [self.annotation setTheCoordinate:[location coordinate]];
            }

        } else {
            NSLog(@"getRoutes error: %@",result);
        }
    }];
}

- (void)getSensors
{
    [[[Engine sharedEngine] dataManager] getSensorForDrone:self.drone withCallback:^(BOOL success, id result) {
        if (success) {            
            [self.drone addNewSensor:result];
        }
    }];
}

- (void)getValuesForSensor:(Sensor *)sensor
{
    [[[Engine sharedEngine] dataManager] getValuesForSensor:sensor withCallback:^(BOOL success, id result) {
        if (success) {
            [sensor addNewValues:result];
        }
    }];
}

@end
