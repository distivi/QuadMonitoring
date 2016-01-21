//
//  ServerManager.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+Safe.h"

#define TEST

@implementation ServerManager


- (void)login:(NSString *)email andPassword:(NSString *)password withCallback:(CompletitionBlock)completition
{
    [self getAccessTokenWithEmail:email andPassword:password completition:completition];
}

#pragma mark GET

- (void)getCommandForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition
{
    NSString *droneName = dronID != 0 ? [@(dronID) stringValue] : @"";
    NSString *apiCall = [NSString stringWithFormat:@"/get/command/%@",droneName];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getDroneForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition
{
    NSString *droneName = dronID != 0 ? [@(dronID) stringValue] : @"";
    NSString *apiCall = [NSString stringWithFormat:@"/get/drone/%@",droneName];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getRouteForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition
{
    NSString *droneName = dronID != 0 ? [@(dronID) stringValue] : @"";
    NSString *apiCall = [NSString stringWithFormat:@"/get/route/%@",droneName];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getSensorForDrone:(NSInteger)dronID withCallback:(CompletitionBlock)completition
{
    NSString *droneName = dronID != 0 ? [@(dronID) stringValue] : @"";
    NSString *apiCall = [NSString stringWithFormat:@"/get/sensor/%@",droneName];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getValuesForSensor:(NSInteger)sensorID withCallback:(CompletitionBlock)completition
{
    NSString *sensorName = sensorID != 0 ? [@(sensorID) stringValue] : @"";
    NSString *apiCall = [NSString stringWithFormat:@"/get/values/%@",sensorName];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getAvailableDrones:(BOOL)isAvailable withCallback:(CompletitionBlock)completition
{
    NSString *apiCall = [NSString stringWithFormat:@"/getAvailable/drones/%zd",isAvailable ? 1 : 0];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getDronesWithStatusActive:(BOOL)isActive withCallback:(CompletitionBlock)completition
{
    NSString *value = isActive ? @"active" : @"inactive";
    NSString *apiCall = [NSString stringWithFormat:@"/getStatus/drones/%@",value];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}

- (void)getDronesForType:(DroneType)droneType withCallback:(CompletitionBlock)completition
{
    NSString *value = droneType == DroneTypeMachine ? @"machine" : @"aircraft";
    NSString *apiCall = [NSString stringWithFormat:@"/getType/drones/%@",value];
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
}


#pragma mark - Private methods

- (void)getAccessTokenWithEmail:(NSString *)email andPassword:(NSString *)password completition:(CompletitionBlock)completition
{
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    
    [self commonPOSTRequestWithApiCall:@"/get/token" params:params callBack:^(BOOL success, id result) {
        if (success) {
            NSString *token = [result safeObjectForKey:@"token"];
            if (token) {
                _accessToken = [@"Bearer " stringByAppendingString:token];

                completition(YES,_accessToken);
                return;
            }
        }
        completition(NO,nil);
    }];
}

- (void)commonGETRequestWithApiCall:(NSString *)apiCall callBack:(CompletitionBlock)completition
{
    AFHTTPSessionManager *manager = [self defaultManager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager GET:request parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (completition) {
            completition(YES,responseObject);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completition) {
            completition(NO,error);
        }
    }];
}

- (void)commonPOSTRequestWithApiCall:(NSString *)apiCall
                              params:(NSDictionary *)params
                            callBack:(CompletitionBlock)completition
{
    AFHTTPSessionManager *manager = [self defaultManager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager POST:request parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (completition) {
            completition(YES,responseObject);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completition) {
            completition(NO,error);
        }
    }];
}

- (void)commonPUTRequestWithApiCall:(NSString *)apiCall
                             params:(NSDictionary *)params
                           callBack:(CompletitionBlock)completition
{
    AFHTTPSessionManager *manager = [self defaultManager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager PUT:request parameters:params success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (completition) {
            completition(YES,responseObject);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completition) {
            completition(NO,error);
        }
    }];
}

- (void)commonDELETERequestWithApiCall:(NSString *)apiCall
                              callBack:(CompletitionBlock)completition
{
    AFHTTPSessionManager *manager = [self defaultManager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager DELETE:request parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (completition) {
            completition(YES,responseObject);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completition) {
            completition(NO,error);
        }
    }];
}

- (NSString *)apiURLForCall:(NSString *)apiCall
{
    NSString *urlString = [NSString stringWithFormat:@"%@/v1%@",self.hostForDataCenter,apiCall];
    return urlString;
}

- (AFHTTPSessionManager *)defaultManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (self.accessToken) {
        [manager.requestSerializer setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    }
    return manager;
}

#pragma mark - Network Connectivity

+ (void)checkNetworkReachabilityStatus:(NetworkStatus)networkBlock{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //available
                networkBlock(true);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //not available
                networkBlock(false);
                break;
            default:
                break;
        }
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}



@end
