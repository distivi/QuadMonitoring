//
//  MonitoringObject.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "MonitoringObject.h"
#import "Engine.h"
#import "BaseAnnotation.h"
#import "DroneAnnotation.h"
#import "CarAnnotation.h"

@interface MonitoringObject()

@property (nonatomic, strong) NSTimer *monitoringTimer;

@end

@implementation MonitoringObject

- (instancetype)initWithIdentifier:(NSString *)identifier annotationsType:(DroneType)annotationsType
{
    if (self = [super init]) {
        self.identifier = identifier;
        self.movingPoints = [NSMutableArray array];
        self.annotationsType = annotationsType;
        self.annotation = [self annotationForType:annotationsType withId:identifier];
        self.annotation.monitoringObject = self;
    }
    return self;
}

- (void)dealloc
{
    [self stopMonitoring];
}

- (void)startMonitoring
{
    if (!self.monitoringTimer) {
        self.monitoringTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getInfoFromServer:) userInfo:nil repeats:YES];
    }
}

- (void)stopMonitoring
{
    if (self.monitoringTimer) {
        [self.monitoringTimer invalidate];
        self.monitoringTimer = nil;
    }
}


#pragma mark - Private methods

- (void)getInfoFromServer:(NSTimer *)sender
{
    
}

- (BaseAnnotation *)annotationForType:(DroneType)annotationType withId:(NSString *)identifier
{
    switch (annotationType) {
        case DroneTypeMachine:
            return [[CarAnnotation alloc] initWithName:identifier info:@"Car" coordinate:CLLocationCoordinate2DMake(0, 0)];
            
        case DroneTypeAircraft:
            return [[DroneAnnotation alloc] initWithName:identifier info:@"Drone" coordinate:CLLocationCoordinate2DMake(0, 0)];
    }
    return nil;
}

@end
