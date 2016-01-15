//
//  Engine.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerManager.h"
#import "DataManager.h"

@interface Engine : NSObject

@property (nonatomic, strong) ServerManager *serverManager;
@property (nonatomic, strong) DataManager *dataManager;

+ (instancetype)sharedEngine;

@end
