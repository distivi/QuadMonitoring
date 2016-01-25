//
//  DroneTableViewCell.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/22/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BatteryView;
@class Drone;

@interface DroneTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *droneIcon;
@property (nonatomic, weak) IBOutlet UILabel *droneTitle;
@property (nonatomic, weak) IBOutlet UISwitch *isAvailableDroneSwitcher;
@property (nonatomic, weak) IBOutlet BatteryView *batteryView;

@property (nonatomic, weak) Drone *drone;


@end
