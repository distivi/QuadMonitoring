//
//  DrawUtils.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/28/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import "DrawUtils.h"

@implementation DrawUtils

+ (UIImage *)droneImage
{
    CGRect frame = CGRectMake(0, 0, 40, 40);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40.0,40.0), NO, 2.0);
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 0.5];
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.367];
    
    //// Oval 3 Drawing
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + CGRectGetHeight(frame) - 15, 14.5, 14.5)];
    [color setFill];
    [oval3Path fill];
    [color2 setStroke];
    oval3Path.lineWidth = 1;
    [oval3Path stroke];
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 1, 15, 15)];
    [color setFill];
    [ovalPath fill];
    [color2 setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 15, CGRectGetMinY(frame) + 1.5, 14.5, 14.5)];
    [color setFill];
    [oval2Path fill];
    [color2 setStroke];
    oval2Path.lineWidth = 1;
    [oval2Path stroke];
    
    
    //// Oval 4 Drawing
    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 15, CGRectGetMinY(frame) + CGRectGetHeight(frame) - 15, 14.5, 14.5)];
    [color setFill];
    [oval4Path fill];
    [color2 setStroke];
    oval4Path.lineWidth = 1;
    [oval4Path stroke];
    
    
    //// Oval 5 Drawing
    UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 15.5, CGRectGetMinY(frame) + CGRectGetHeight(frame) - 27.5, 10, 15)];
    [UIColor.blackColor setFill];
    [oval5Path fill];
    [UIColor.blackColor setStroke];
    oval5Path.lineWidth = 1;
    [oval5Path stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.5, CGRectGetMinY(frame) + 6.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 32.5, CGRectGetMinY(frame) + 32.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 32.5, CGRectGetMinY(frame) + 32.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 32.5, CGRectGetMinY(frame) + 32.5)];
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [UIColor.blackColor setFill];
    [bezierPath fill];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 33, CGRectGetMinY(frame) + 6)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMinY(frame) + 33) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 8, CGRectGetMinY(frame) + 32) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMinY(frame) + 33)];
    [UIColor.blackColor setFill];
    [bezier2Path fill];
    [UIColor.blackColor setStroke];
    bezier2Path.lineWidth = 2;
    [bezier2Path stroke];
    
    UIImage *dronImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return dronImage;    
}

@end
