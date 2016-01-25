//
//  AddTaskViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/25/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Constants.h"

@interface AddTaskViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *detailInfoTextField;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITextField

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)addRoute:(id)sender
{
    if ([self.detailInfoTextField isFirstResponder]) {
        [self.detailInfoTextField resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationAddRouteForTask object:self.drone];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
