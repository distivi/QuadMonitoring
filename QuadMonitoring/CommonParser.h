//
//  CommonParser.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "BaseParser.h"

@interface CommonParser : BaseParser

+ (instancetype)parserWithModelParser:(BaseParser *)parser toParseList:(BOOL)isList;

@end
