//
//  DroneAnnotation.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/28/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import "DroneAnnotation.h"

@interface DroneAnnotation()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation DroneAnnotation

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

- (void)updatePosition:(CLLocationCoordinate2D)coordinate
{
    self.theCoordinate = coordinate;
}

@end
