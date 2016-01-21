//
//  MonitoringObject.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Constants.h"

@class BaseAnnotation;
@class MonitoringObject;
@class Drone;
@class Command;
@class CommandAnnotation;

@protocol MonitoringObjectDelegate <NSObject>

- (void)monitoringObject:(MonitoringObject *)sender didChangePosition:(CLLocationCoordinate2D)coordinate;
- (void)monitoringObject:(MonitoringObject *)sender didAddNewCommandAnnotation:(CommandAnnotation *)commandAnnotation;
- (void)monitoringObject:(MonitoringObject *)sender updatedRoutePath:(NSArray *)routePath;

@end

@interface MonitoringObject : NSObject

@property (nonatomic, strong) Drone *drone;
@property (nonatomic, strong, readonly) BaseAnnotation *annotation;
@property (nonatomic, strong, readonly) NSMutableArray *commandsAnnorations;
@property (nonatomic, weak) id<MonitoringObjectDelegate> delegate;


- (instancetype)initWithDrone:(Drone *)drone;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
