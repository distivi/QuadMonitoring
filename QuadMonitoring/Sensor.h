//
//  Sensor.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Drone;
@class SensorValue;

@interface Sensor : NSObject

@property (nonatomic) NSInteger sensorId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) Drone *drone;

@property (nonatomic, strong) NSMutableArray *values;

- (void)addNewValues:(NSArray *)values;

@end
