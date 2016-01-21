//
//  SettingsManager.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic, strong) NSString *dataCenterHost;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;


@end
