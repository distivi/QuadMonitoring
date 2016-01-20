//
//  SensorValue.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sensor;

@interface SensorValue : NSObject

@property (nonatomic) NSInteger valueId;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double value;

@property (nonatomic, strong) NSDate *dateAdded;
@property (nonatomic, weak) Sensor *sensor;

@end
