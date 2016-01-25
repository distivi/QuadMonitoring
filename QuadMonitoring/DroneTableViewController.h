//
//  DroneTableViewController.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class DroneTableViewController;

@protocol DroneTableViewControllerDelegate <NSObject>

- (void)dronesController:(DroneTableViewController *)controller wantRefreshDronesList:(CompletitionBlock)callBack;

@end

@interface DroneTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *drones;
@property (nonatomic, weak) id<DroneTableViewControllerDelegate> dronesDelegate;

@end
