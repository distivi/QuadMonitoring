//
//  BaseAnnotation.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MonitoringObject;

@interface BaseAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@property (nonatomic, weak) MonitoringObject *monitoringObject;

- (instancetype)initWithName:(NSString *)name info:(NSString *)info coordinate:(CLLocationCoordinate2D)coordinate;

@end
