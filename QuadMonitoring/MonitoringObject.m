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

@interface MonitoringObject()

@property (nonatomic, strong) NSTimer *monitoringTimer;

@end

@implementation MonitoringObject

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        self.identifier = identifier;
        self.movingPoints = [NSMutableArray array];
        self.annotation = [[BaseAnnotation alloc] initWithName:identifier info:@"None" coordinate:CLLocationCoordinate2DMake(0, 0)];
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
        self.monitoringTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getInfoFromServer:) userInfo:nil repeats:YES];
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
    [[[Engine sharedEngine] dataManager] getLastInfoForMonitoringObject:self.identifier callBack:^(BOOL success, id result) {
        if (success) {
            NSLog(@"result %@",result);
            if ([result isKindOfClass:[CLLocation class]]) {
                CLLocation *location = result;
                [self.movingPoints addObject:location];
                [self.annotation setTheCoordinate:[location coordinate]];
                
                if ([self.delegate respondsToSelector:@selector(monitoringObject:didChangePosition:)]) {
                    [self.delegate monitoringObject:self didChangePosition:[location coordinate]];
                }
            }
        } else if (result) {
            NSError *error = result;
            NSLog(@"ERROR: %@",[error localizedDescription]);
        }
    }];
}

@end
