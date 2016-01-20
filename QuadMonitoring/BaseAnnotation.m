//
//  BaseAnnotation.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "BaseAnnotation.h"

@implementation BaseAnnotation

- (instancetype)initWithName:(NSString *)name info:(NSString *)info coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.name = name;
        self.info = info;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _info;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (UIImage *)icon
{
    return nil;
}


@end
