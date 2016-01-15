//
//  StringListParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "StringListParser.h"


@implementation StringListParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    NSArray *objects = (NSArray *)json;
    result(objects,nil);
}

@end
