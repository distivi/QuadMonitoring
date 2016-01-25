//
//  Drone.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "Drone.h"
#import "Sensor.h"
#import "Command.h"
#import "Route.h"

@implementation Drone

- (instancetype)init
{
    if (self = [super init]) {
        self.routes = [NSMutableArray array];
        self.sensors = [NSMutableSet set];
        self.commands =[NSMutableArray array];
    }
    return self;
}

- (void)addNewCommands:(NSArray *)commands
{
    NSMutableArray *newAddedCommands = [NSMutableArray arrayWithCapacity:commands.count];
    
    for (Command *newCommand in commands) {
        if (![self.commands containsObject:newCommand]) {
            [newAddedCommands addObject:newCommand];
            NSLog(@"New Command %@ #%zd added to Drone %zd (%@)",newCommand.commandDescription,newCommand.commandID,self.droneId, self.name);
        }
    }
    
    [self.commands addObjectsFromArray:newAddedCommands];
}

- (void)addNewRoutes:(NSArray *)routes
{
    NSMutableArray *newAddedRoutes= [NSMutableArray arrayWithCapacity:routes.count];
    
    for (Route *newRoute in routes) {
        if (![self.routes containsObject:newRoute]) {
            [newAddedRoutes addObject:newRoute];
        }
    }
    
    [self.routes addObjectsFromArray:newAddedRoutes];
    
    [self.routes sortUsingComparator:^NSComparisonResult(Route *obj1, Route *obj2) {
        return [obj1.dateAdded compare:obj2.dateAdded];
    }];
    
}

- (void)addNewSensor:(Sensor *)sensor
{
    if (![self.sensors containsObject:sensor]) {
        [self.sensors addObject:sensor];
        
        NSLog(@"New sensor %@ #%zd added to drone %@",sensor.name, sensor.sensorId, self.name);
    }
}

- (NSArray *)getRoutePath
{
    NSMutableArray *path = [NSMutableArray array];
    for (Route *route in self.routes) {
        [path addObject:[route location]];
    }
    return path;
}

- (NSString *)statusString
{
    return self.status ? @"active" : @"inactive";
}


@end
