//
//  ParseProtocol.h
//  FakeVoat
//
//  Created by Stas on 08.07.15.
//  Copyright (c) 2015 distvi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ParsingResultBlock)(id object, NSError* error);

@protocol ParseProtocol <NSObject>

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result;

@end
