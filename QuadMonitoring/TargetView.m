//
//  TargetView.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "TargetView.h"
#import "StyleKit.h"

@implementation TargetView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [StyleKit drawTargetCanvasWithFrame:rect];
}


@end
