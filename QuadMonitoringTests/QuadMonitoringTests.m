//
//  QuadMonitoringTests.m
//  QuadMonitoringTests
//
//  Created by Stanislav Dymedyuk on 12/17/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Engine.h"

@interface QuadMonitoringTests : XCTestCase



@end

@implementation QuadMonitoringTests

- (void)setUp {
    [super setUp];
    
    NSString *accessToken = [[[Engine sharedEngine] settingsManager] accessToken];
    NSString *host = [[[Engine sharedEngine] settingsManager] dataCenterHost];
    
    [[[Engine sharedEngine] serverManager] setHostForDataCenter:host];
    [[[Engine sharedEngine] serverManager] setAccessToken:accessToken];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        NSString *login = @"dymedyuk@gmail.com";
        NSString *password = @"35QlLo";
        
        [[[Engine sharedEngine] serverManager] login:login andPassword:password withCallback:^(BOOL success, id result) {
            if (success) {
                [[[Engine sharedEngine] settingsManager] setAccessToken:result];
                [expectation fulfill];
            }
        }];
    }];
}

#pragma mark - server GET tests

- (void)testGetCommandForDrone
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getCommandForDrone:1 withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetDroneForDrone
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getDroneForDrone:1 withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetRouteForDrone
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getRouteForDrone:1 withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetSensorForDrone
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getSensorForDrone:1 withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetValuesForSensor
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getValuesForSensor:1 withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetAvailableDrones
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getAvailableDrones:YES withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetDronesWithStatusActive
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getDronesWithStatusActive:YES withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}

- (void)testGetDronesForType
{
    [self runAsyncTestFromMethod:_cmd withTestBlock:^(XCTestExpectation *expectation) {
        [[[Engine sharedEngine] serverManager] getDronesForType:DroneTypeAircraft withCallback:^(BOOL success, id result) {
            if (success) {
                NSLog(@"result %@",result);
                [expectation fulfill];
            }
        }];
    }];
}


#pragma mark - Help tips

- (void)runAsyncTestFromMethod:(SEL)methodSEL withTestBlock:(void(^)(XCTestExpectation *expectation))testBlock
{
    XCTestExpectation *exp = [self expectationWithDescription:NSStringFromSelector(methodSEL)];
    
    testBlock(exp);
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}



@end
