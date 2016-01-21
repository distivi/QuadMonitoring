//
//  CommandAnnotation.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/21/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "BaseAnnotation.h"

@class Command;

@interface CommandAnnotation : BaseAnnotation

@property (nonatomic, weak) Command *command;

- (instancetype)initWithCommand:(Command *)command;

@end
