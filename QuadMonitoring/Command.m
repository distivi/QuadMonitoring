//
//  Command.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "Command.h"

@implementation Command

- (BOOL)isEqual:(id)object
{
    if (self.commandID == [(Command *)object commandID]) {
        return YES;
    }
    return NO;
}

@end
