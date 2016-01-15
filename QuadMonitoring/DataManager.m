//
//  DataManager.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "DataManager.h"
#import "Engine.h"
#import "BaseParser.h"
#import "CommonParser.h"
#import "StringListParser.h"
#import "MonitoringObjectParser.h"

@implementation DataManager

- (void)getAvailableMonitoringObjectsWithCallBack:(CompletitionBlock)callback
{
    StringListParser *parser = [StringListParser new];
    CompletitionBlock completition = [self commonParserWithFeedBack:callback parser:parser];
    
    [[[Engine sharedEngine] serverManager] getAvailableMonitoringObjectsWithCallBack:completition];
}

- (void)getLastInfoForMonitoringObject:(NSString *)objectID callBack:(CompletitionBlock)callback
{
    MonitoringObjectParser *parser = [MonitoringObjectParser new];
    CompletitionBlock completition = [self commonParserWithFeedBack:callback parser:parser];
    
    [[[Engine sharedEngine] serverManager] getLastInfoForMonitoringObject:objectID callBack:completition];
}

#pragma mark - Private methods

- (CompletitionBlock)commonParserWithFeedBack:(CompletitionBlock)callback
                                       parser:(BaseParser *)parser
{
    CommonParser *commonParser = [CommonParser parserWithModelParser:parser];
    
    CompletitionBlock completitionBlock = ^(BOOL success, id result) {
        if (success) {            
            [commonParser parseJSON:result withResult:^(id object, NSError *error) {
                if (callback) {
                    BOOL success = (error == nil);
                    callback(success,success ? object : error);
                }
            }];
            
        } else {
            callback(NO,result);
        }
    };
    return completitionBlock;
}

@end
