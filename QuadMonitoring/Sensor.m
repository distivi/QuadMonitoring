//
//  Sensor.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "Sensor.h"
#import "SensorValue.h"
#import "Drone.h"

@implementation Sensor

- (instancetype)init
{
    if (self = [super init]) {
        self.values = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self.sensorId == [(Sensor *)object sensorId]) {
        return YES;
    }
    return NO;
}


- (void)addNewValues:(NSArray *)values
{
    NSMutableArray *newAddedValues = [NSMutableArray arrayWithCapacity:values.count];
    
    for (SensorValue *newValue in values) {
        if (![self.values containsObject:newValue]) {
            [newAddedValues addObject:newValue];
            NSLog(@"New Value %.2f #%zd added to Sensor %zd (drone %@)",newValue.value, newValue.valueId, self.sensorId, self.drone.name);
        }
    }
    
    [self.values addObjectsFromArray:newAddedValues];
}



@end
