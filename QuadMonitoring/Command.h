//
//  Command.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Drone;

@interface Command : NSObject

@property (nonatomic) NSInteger commandID;

@property (nonatomic) double height;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, strong) NSDate *dateAdded;
@property (nonatomic, strong) NSString *commandDescription;
@property (nonatomic, weak) Drone *drone;

@end
