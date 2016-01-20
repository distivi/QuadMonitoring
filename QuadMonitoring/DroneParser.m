//
//  DroneParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "DroneParser.h"
#import "Drone.h"

@implementation DroneParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    Drone *drone = [Drone new];
    
    drone.droneId = [[json safeObjectForKey:@"id"] integerValue];
    drone.available = [[json safeObjectForKey:@"available"] boolValue];
    drone.name = [json safeObjectForKey:@"name"];
    drone.status = [[json safeObjectForKey:@"status"] isEqualToString:@"active"];
    drone.type = [[json safeObjectForKey:@"type"] isEqualToString:@"aircraft"] ? DroneTypeAircraft : DroneTypeMachine;
    
    result(drone,nil);
}

@end
