//
//  MonitoringObjectParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "MonitoringObjectParser.h"
#import <MapKit/MapKit.h>

@implementation MonitoringObjectParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    double lat = [[json safeObjectForKey:@"lat"] doubleValue];
    double lon = [[json safeObjectForKey:@"lon"] doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    result(location,nil);
}

@end
