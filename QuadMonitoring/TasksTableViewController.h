//
//  TasksTableViewController.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Drone;

@interface TasksTableViewController : UITableViewController

@property (nonatomic, weak) Drone *drone;

@end
