//
//  NSDate+JSON.m
//  FakeVoat
//
//  Created by Stanislav Dymedyuk on 7/13/15.
//  Copyright (c) 2015 distvi. All rights reserved.
//

#import "NSDate+JSON.h"

@implementation NSDate (JSON)

+ (NSDate *)dateFronJSON:(NSString *)jsonString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSString *dateFormat1 = @"yyyy-MM-dd HH:mm:ss"; // 2016-01-17 18:07:48
    NSString *dateFormat2 = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"; // 2015-07-11T06:33:26.023Z
    NSString *dateFormat3 = @"EEE, dd MMM yyyy HH:mm:ss ZZZ"; // Fri, 17 Jul 2015 15:47:28 GMT
    NSString *dateFormat4 = @"yyyy-MM-dd'T'HH:mm:ss"; // 2015-07-30T08:15:49
    
    NSArray *formats = @[dateFormat1,dateFormat2,dateFormat3,dateFormat4];
    
    for (NSString *df in formats) {
        [dateFormat setDateFormat:df];
        NSDate *date = [dateFormat dateFromString:jsonString];
        
        if (date) {
            return date;
        }
    }
    
    
    if (jsonString) {
        NSLog(@"\n\n\n\n\nMissing date format for JSON : %@",jsonString);
    }
    
    return nil;
}

@end
