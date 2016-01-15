//
//  CommonParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "CommonParser.h"

@interface CommonParser()

@property (nonatomic, strong) BaseParser *parser;

@end

@implementation CommonParser

+ (instancetype)parserWithModelParser:(BaseParser *)parser
{
    CommonParser *commonParser = [CommonParser new];
    commonParser.parser = parser;
    return commonParser;
}

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    BOOL success = [[json safeObjectForKey:@"success"] boolValue];
    NSString *errorMessage = [json safeObjectForKey:@"error"];
    id data = [json safeObjectForKey:@"data"];
    
    if (success) {
        [self.parser parseJSON:data withResult:result];
    } else {
        NSError *error = errorMessage ? [NSError errorWithDomain:ErrorDomain code:ErrorTypeResponseWithError userInfo:@{ErrorMessage: errorMessage}] : nil;
        result(nil,error);
    }    
}

@end
