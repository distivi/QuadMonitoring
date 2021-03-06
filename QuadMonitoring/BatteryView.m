//
//  BatteryView.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "BatteryView.h"
#import "StyleKit.h"

@implementation BatteryView


- (void)setBatteryLevel:(NSInteger)batteryLevel
{
    _batteryLevel = batteryLevel;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [StyleKit drawBatteryWithBatteryLevel:_batteryLevel];
}


@end
