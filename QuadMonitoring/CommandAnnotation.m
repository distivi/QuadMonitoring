//
//  CommandAnnotation.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/21/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "CommandAnnotation.h"
#import "Command.h"

@implementation CommandAnnotation

- (instancetype)initWithCommand:(Command *)command
{
    NSString *name = [NSString stringWithFormat:@"Command #%zd",command.commandID];
    if (self = [super initWithName:name info:command.commandDescription coordinate:CLLocationCoordinate2DMake(command.latitude, command.longitude)]) {
        self.command = command;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        if (self.command.commandID == [[(CommandAnnotation *)object command] commandID]) {
            return YES;
        }
    } else {
        NSLog(@"Got it!!!");
    }
    return NO;
}

- (UIImage *)icon
{
    return [UIImage imageNamed:@"destination_marker"];;
}

@end
