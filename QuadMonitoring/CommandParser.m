//
//  CommandParser.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/20/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "CommandParser.h"
#import "Command.h"
#import "NSDate+JSON.h"

@implementation CommandParser

- (void)parseJSON:(id)json withResult:(ParsingResultBlock)result
{
    Command *command = [Command new];
    
    command.commandID = [[json safeObjectForKey:@"id"] integerValue];
    command.commandDescription = [json safeObjectForKey:@"description"];

    command.height = [[json safeObjectForKey:@"height"] doubleValue];
    command.latitude = [[json safeObjectForKey:@"latitude"] doubleValue];
    command.longitude = [[json safeObjectForKey:@"longitude"] doubleValue];
    command.dateAdded = [NSDate dateFronJSON:[json safeObjectForKey:@"added"]];
    
    result(command,nil);
}

@end
