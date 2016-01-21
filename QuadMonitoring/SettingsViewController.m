//
//  SettingsViewController.m
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/21/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#import "SettingsViewController.h"
#import "Engine.h"

@interface SettingsViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *hostTextField;
@property (nonatomic, weak) IBOutlet UITextField *loginTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupDefaultValues];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupDefaultValues
{
    SettingsManager *settings = [[Engine sharedEngine] settingsManager];
    
    self.hostTextField.text = settings.dataCenterHost;
    self.loginTextField.text = settings.email;
    self.passwordTextField.text = settings.password;
}

#pragma mark - IBActions

- (IBAction)save:(id)sender
{
    [self hideKeyboard];
    
    NSString *host = self.hostTextField.text;
    NSString *login = self.loginTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[[Engine sharedEngine] dataManager] loginUser:login withPassword:password toServer:host withCallback:^(BOOL success, id result) {
        
        NSString *title = success ? @"Success" : @"Failure";
        NSString *message;
        if (success) {
            message = @"You successfully logged to Data Center";
        } else {
            message = @"Sorry, something went wrong.";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];    
}

#pragma mark - UITextField

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - Help methods

- (void)hideKeyboard
{
    NSArray *tfArr = @[self.hostTextField,self.loginTextField,self.passwordTextField];
    for (UITextField *tf in tfArr) {
        if ([tf isFirstResponder]) {
            [tf resignFirstResponder];
            break;
        }
    }
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
