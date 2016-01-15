//
//  DataManager.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DataManager : NSObject

- (void)getAvailableMonitoringObjectsWithCallBack:(CompletitionBlock)completition;
- (void)getLastInfoForMonitoringObject:(NSString *)objectID callBack:(CompletitionBlock)completition;

@end
