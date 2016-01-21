//
//  Route.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Drone;
@class CLLocation;

@interface Route : NSObject

@property (nonatomic, strong) NSDate *dateAdded; 
@property (nonatomic) NSInteger battery;
@property (nonatomic) Direction direction;
@property (nonatomic, weak) Drone *drone;
@property (nonatomic) double height;
@property (nonatomic) NSInteger routeId;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (CLLocation *)location;

@end
