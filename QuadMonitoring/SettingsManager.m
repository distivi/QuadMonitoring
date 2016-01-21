//
//  SettingsManager.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "SettingsManager.h"

#define defaults                [NSUserDefaults standardUserDefaults]
#define kIsDefaultValueSetted   @"kIsDefaultValueSetted"
#define kDefaultDataCenterHost  @"https://api.data-center.in.ua"

#define kDataCenterHost         @"kDataCenterHost"
#define kAccessToken            @"kAccessToken"
#define kEmail                  @"kEmail"
#define kPassword               @"kPassword"


@implementation SettingsManager

- (instancetype)init
{
    if (self = [super init]) {
        if (![defaults objectForKey:kIsDefaultValueSetted]) {
            [self setDataCenterHost:kDefaultDataCenterHost];
            [defaults setObject:@(YES) forKey:kIsDefaultValueSetted];
        } else {
            _dataCenterHost = [defaults objectForKey:kDataCenterHost];
            _accessToken = [defaults objectForKey:kAccessToken];
            _email = [defaults objectForKey:kEmail];
            _password = [defaults objectForKey:kPassword];            
        }
    }
    return self;
}

- (void)setDataCenterHost:(NSString *)dataCenterHost
{
    _dataCenterHost = dataCenterHost;
    [self saveValue:_dataCenterHost forKey:kDataCenterHost];
}

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    [self saveValue:_accessToken forKey:kAccessToken];
}

- (void)setEmail:(NSString *)email
{
    _email = email;
    [self saveValue:_email forKey:kEmail];
}

- (void)setPassword:(NSString *)password
{
    _password =password;
    [self saveValue:_password forKey:kPassword];
}


#pragma mark - Private methods

- (void)saveValue:(id)value forKey:(NSString *)key
{
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}


@end
