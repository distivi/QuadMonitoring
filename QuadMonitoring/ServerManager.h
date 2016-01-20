//
//  ServerManager.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void (^NetworkStatus)(BOOL available);

@interface ServerManager : NSObject

@property (nonatomic, strong) NSString *hostForDataCenter;
@property (nonatomic, strong) NSString *hostForMonitoringTransmitter;

@property (nonatomic, strong) NSString *accessToken;

- (void)login:(NSString *)email andPassword:(NSString *)password withCallback:(CompletitionBlock)completition;

#pragma mark - GET

- (void)getCommandForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition;
- (void)getDroneForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition;
- (void)getRouteForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition;
- (void)getSensorForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition;
- (void)getValuesForSensor:(NSInteger)sensorID withCallback:(CompletitionBlock)completition;
- (void)getAvailableDrones:(BOOL)isAvailable withCallback:(CompletitionBlock)completition;
- (void)getDronesWithStatusActive:(BOOL)isActive withCallback:(CompletitionBlock)completition;
- (void)getDronesForType:(DroneType)droneType withCallback:(CompletitionBlock)completition;

//Network Reachibility Status
+ (void)checkNetworkReachabilityStatus:(NetworkStatus)networkBlock;

@end
