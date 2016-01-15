//
//  NSDictionary+Safe.m
//  FakeVoat
//
//  Created by Stas on 08.07.15.
//  Copyright (c) 2015 distvi. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (id)safeObjectForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return value;
}

@end
