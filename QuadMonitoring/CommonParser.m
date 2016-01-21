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
@property (nonatomic) BOOL isList;

@end

@implementation CommonParser

+ (instancetype)parserWithModelParser:(BaseParser *)parser toParseList:(BOOL)isList
{
    CommonParser *commonParser = [CommonParser new];
    commonParser.parser = parser;
    commonParser.isList = isList;
    return commonParser;
}

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    BOOL success = [[json safeObjectForKey:@"success"] boolValue];
    NSString *errorMessage = [json safeObjectForKey:@"msg"];
    id data = [json safeObjectForKey:@"data"];
    
    if (success) {
        if (self.isList) {
            NSMutableArray *objects = [NSMutableArray array];
            
            for (NSDictionary *jsonObject in data) {
                [self.parser parseJSON:jsonObject withResult:^(id object, NSError *error) {
                    if (!error) {
                        [objects addObject:object];
                    }
                }];
                
                result(objects,nil);
            }            
        } else {
            [self.parser parseJSON:data withResult:result];
        }
    } else {
        NSError *error = errorMessage ? [NSError errorWithDomain:ErrorDomain code:ErrorTypeResponseWithError userInfo:@{ErrorMessage: errorMessage}] : nil;
        result(nil,error);
    }    
}

@end
