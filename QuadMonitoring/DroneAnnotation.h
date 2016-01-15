//
//  DroneAnnotation.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 12/28/15.
//  Copyright © 2015 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DroneAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithName:(NSString *)name info:(NSString *)info coordinate:(CLLocationCoordinate2D)coordinate;
- (void)updatePosition:(CLLocationCoordinate2D)coordinate;

@end
