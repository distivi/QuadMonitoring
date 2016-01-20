//
//  RouteParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "RouteParser.h"
#import "Route.h"
#import "NSDate+JSON.h"

@implementation RouteParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    Route *route = [Route new];
    
    route.routeId = [[json safeObjectForKey:@"id"] integerValue];
    route.battery = [[json safeObjectForKey:@"battery"] integerValue];
    route.height = [[json safeObjectForKey:@"height"] doubleValue];
    route.latitude = [[json safeObjectForKey:@"latitude"] doubleValue];
    route.longitude = [[json safeObjectForKey:@"longitude"] doubleValue];
    route.dateAdded = [NSDate dateFronJSON:[json safeObjectForKey:@"added"]];
        
    result(route,nil);
}

@end
