//
//  Route.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "Route.h"
#import <MapKit/MapKit.h>

@implementation Route

- (CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
}

@end
