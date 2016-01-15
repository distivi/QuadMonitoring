//
//  NSDictionary+Safe.h
//  FakeVoat
//
//  Created by Stas on 08.07.15.
//  Copyright (c) 2015 distvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (id)safeObjectForKey:(NSString *)key;

@end
