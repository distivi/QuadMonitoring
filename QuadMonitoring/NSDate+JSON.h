//
//  NSDate+JSON.h
//  FakeVoat
//
//  Created by Stanislav Dymedyuk on 7/13/15.
//  Copyright (c) 2015 distvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JSON)

+ (NSDate *)dateFronJSON:(NSString *)jsonString;

@end
