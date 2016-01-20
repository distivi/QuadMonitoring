//
//  SensorParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "SensorParser.h"
#import "Sensor.h"

@implementation SensorParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    Sensor *sensor = [Sensor new];
    
    sensor.sensorId = [[json safeObjectForKey:@"id"] integerValue];
    sensor.name = [json safeObjectForKey:@"name"];
    
    result(sensor,nil);
}

@end
