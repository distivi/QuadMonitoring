//
//  NSDate+Utils.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSString *)dateString
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    
    [dateformat setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    
    NSString *dateString = [dateformat stringFromDate:self];
    
    return dateString;
}

@end
