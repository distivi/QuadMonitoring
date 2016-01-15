//
//  ServerManager.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking/AFNetworking.h>

#define TEST

@implementation ServerManager

- (void)getAvailableMonitoringObjectsWithCallBack:(CompletitionBlock)completition
{
#ifdef TEST
    NSDictionary *json = @{@"success": @(YES),@"data": @[@"id1",@"id2",@"id3",@"id4"]};
    completition(YES, json);
#else
    NSString *apiCall = @"monitoringObjects";
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
#endif
}

- (void)getLastInfoForMonitoringObject:(NSString *)objectID callBack:(CompletitionBlock)completition
{
#ifdef TEST
    double lat = 46.972307 + 0.0001 * (double)(arc4random() % 100 - 50);
    double lon = 32.014188 + 0.0001 * (double)(arc4random() % 100 - 50);
    NSDictionary *json = @{@"success": @(YES),@"data": @{@"lat": @(lat),@"lon": @(lon)}};
    completition(YES, json);
#else
    NSString *apiCall = FORMAT(@"info/dron/%@",objectID);
    [self commonGETRequestWithApiCall:apiCall callBack:completition];
#endif
}

#pragma mark - Private methods

- (void)commonGETRequestWithApiCall:(NSString *)apiCall callBack:(CompletitionBlock)completition
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager GET:request parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager POST:request parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager PUT:request parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *request = [self apiURLForCall:apiCall];
    
    [manager DELETE:request parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
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
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.hostForDataCenter,apiCall];
    return urlString;
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
