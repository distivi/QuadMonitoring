//
//  SensorValueParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "SensorValueParser.h"
#import "SensorValue.h"
#import "NSDate+JSON.h"

@implementation SensorValueParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    SensorValue *value = [SensorValue new];
    
    value.valueId = [[json safeObjectForKey:@"id"] integerValue];
    value.dateAdded = [NSDate dateFronJSON:[json safeObjectForKey:@"added"]];
    value.latitude = [[json safeObjectForKey:@"latitude"] doubleValue];
    value.longitude = [[json safeObjectForKey:@"longitude"] doubleValue];
    value.value = [[json safeObjectForKey:@"value"] doubleValue];
    
    result(value,nil);
}


@end
