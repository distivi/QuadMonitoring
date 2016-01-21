//
//  SensorValue.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "SensorValue.h"

@implementation SensorValue

- (BOOL)isEqual:(id)object
{
    if (self.valueId == [(SensorValue *)object valueId]) {
        return YES;
    }
    return NO;
}

@end
