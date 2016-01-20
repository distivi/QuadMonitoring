//
//  Engine.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "Engine.h"

@implementation Engine

+ (instancetype)sharedEngine
{
    static Engine *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [Engine new];
    });
    return singleton;
}


- (ServerManager *)serverManager
{
    if (!_serverManager) {
        _serverManager = [ServerManager new];
    }
    return _serverManager;
}

- (DataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [DataManager new];
    }
    return _dataManager;
}

- (SettingsManager *)settingsManager
{
    if (!_settingsManager) {
        _settingsManager = [SettingsManager new];
    }
    return _settingsManager;
}

@end
