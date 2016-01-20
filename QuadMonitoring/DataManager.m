//
//  DataManager.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "DataManager.h"
#import "Engine.h"
#import "BaseParser.h"
#import "CommonParser.h"
#import "DroneParser.h"
#import "SensorParser.h"
#import "SensorValueParser.h"
#import "CommandParser.h"
#import "RouteParser.h"

#import "Drone.h"
#import "Route.h"
#import "Sensor.h"
#import "SensorValue.h"
#import "Command.h"

#define SERVER [[Engine sharedEngine] serverManager]


@implementation DataManager

- (void)getDronesWithCallback:(CompletitionBlock)completition
{
    CompletitionBlock callback = [self commonParserWithFeedBack:completition
                                                         parser:[DroneParser new]
                                                   mustParsList:YES];
    [SERVER getDroneForDrone:0 withCallback:callback];
}

- (void)getCommandsForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition
{
    CompletitionBlock callback = [self commonParserWithFeedBack:completition
                                                         parser:[CommandParser new]
                                                   mustParsList:YES];
    [SERVER getCommandForDrone:dron.droneId withCallback:callback];
}

- (void)getRoutesForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition
{
    CompletitionBlock callback = [self commonParserWithFeedBack:completition
                                                         parser:[RouteParser new]
                                                   mustParsList:YES];
    [SERVER getRouteForDrone:dron.droneId withCallback:callback];
}

- (void)getSensorForDrone:(Drone *)dron withCallback:(CompletitionBlock)completition
{
    CompletitionBlock callback = [self commonParserWithFeedBack:completition
                                                         parser:[SensorParser new]
                                                   mustParsList:YES];
    [SERVER getSensorForDrone:dron.droneId withCallback:callback];
}

- (void)getValuesForSensor:(Sensor *)sensor withCallback:(CompletitionBlock)completition
{
    CompletitionBlock callback = [self commonParserWithFeedBack:completition
                                                         parser:[SensorValueParser new]
                                                   mustParsList:YES];
    [SERVER getValuesForSensor:sensor.sensorId withCallback:callback];
}


#pragma mark - Private methods

- (CompletitionBlock)commonParserWithFeedBack:(CompletitionBlock)callback
                                       parser:(BaseParser *)parser
                                 mustParsList:(BOOL)mustParseList
{
    CommonParser *commonParser = [CommonParser parserWithModelParser:parser toParseList:mustParseList];
    
    CompletitionBlock completitionBlock = ^(BOOL success, id result) {
        if (success) {            
            [commonParser parseJSON:result withResult:^(id object, NSError *error) {
                if (callback) {
                    BOOL success = (error == nil);
                    callback(success,success ? object : error);
                }
            }];
            
        } else {
            callback(NO,result);
        }
    };
    return completitionBlock;
}

@end
