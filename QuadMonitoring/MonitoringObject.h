//
//  MonitoringObject.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class BaseAnnotation;
@class MonitoringObject;

@protocol MonitoringObjectDelegate <NSObject>

- (void)monitoringObject:(MonitoringObject *)sender didChangePosition:(CLLocationCoordinate2D)coordinate;

@end

@interface MonitoringObject : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) BaseAnnotation *annotation;
@property (nonatomic, weak) id<MonitoringObjectDelegate> delegate;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
