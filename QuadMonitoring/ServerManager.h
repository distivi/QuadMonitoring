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

- (void)getAvailableMonitoringObjectsWithCallBack:(CompletitionBlock)completition;
- (void)getLastInfoForMonitoringObject:(NSString *)objectID callBack:(CompletitionBlock)completition;

//Network Reachibility Status
+ (void)checkNetworkReachabilityStatus:(NetworkStatus)networkBlock;

@end
