//
//  TasksTableViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "TasksTableViewController.h"
#import "Drone.h"
#import "Command.h"
#import "NSDate+Utils.h"
#import "Engine.h"

@implementation TasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupRefresher];
}


- (void)setupRefresher
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    [[[Engine sharedEngine] dataManager] getCommandsForDrone:self.drone withCallback:^(BOOL success, id result) {
        [self.refreshControl endRefreshing];
        if (success) {
            [self.drone addNewCommands:result];
            [self.tableView reloadData];
        } else {
            NSLog(@"getCommand error: %@",result);
        }
    }];
}

- (void)setDrone:(Drone *)drone
{
    _drone = drone;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.drone.commands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    Command *currentCommand = [self.drone.commands objectAtIndex:indexPath.row];
    if (currentCommand) {
        cell.textLabel.text = currentCommand.commandDescription;
        cell.detailTextLabel.text = [currentCommand.dateAdded dateString];
    }
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



@end

