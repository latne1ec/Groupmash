//
//  SignupTableViewController.m
//  Yapster
//
//  Created by Evan Latner on 12/15/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import "SignupTableViewController.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface SignupTableViewController ()

@end

@implementation SignupTableViewController

@synthesize emailCell, usernameCell, passwordCell, termsCell;
@synthesize emailField, usernameField, passwordField;

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC


- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];


    [TSMessage setDefaultViewController:self];
    [TSMessage setDelegate:self];
    
    self.emailField.delegate = self;
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [emailField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [emailField resignFirstResponder];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
}


//*********************************************
// Set Up Table View

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return emailCell;
    if (indexPath.row == 1) return usernameCell;
    if (indexPath.row == 2) return passwordCell;
    if (indexPath.row == 3) return termsCell;
    
    return nil;
}
//*********************************************






//*********************************************
// Keyboard Button Actions

-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    
    if([emailField isFirstResponder]){
        [usernameField becomeFirstResponder];
    }
    else if ([usernameField isFirstResponder]){
        [passwordField becomeFirstResponder];
    }
    else if ([passwordField isFirstResponder]){
        [passwordField resignFirstResponder];
        [self signup:self];
    }
    return YES;
}
//*********************************************




//*********************************************
// Signup the Current User

- (IBAction)signup:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email length] == 0) {
        [ProgressHUD showError:@"Enter a valid Email Address"];
    }
    if ([username length] == 0) {
        [ProgressHUD showError:@"Create a Username"];
    }
    if ([password length] == 0) {
        [ProgressHUD showError:@"Create a Password"];
    }
    
    else {
        
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        [ProgressHUD show:nil];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [ProgressHUD dismiss];
                
                if (error.userInfo.count >= 3) {
                    [TSMessage showNotificationWithTitle:nil
                                                subtitle:@"something went wrong, try again"
                                                    type:TSMessageNotificationTypeError];

                }
                else {
                [TSMessage showNotificationWithTitle:nil
                                            subtitle:[error.userInfo objectForKey:@"error"]
                                                type:TSMessageNotificationTypeError];
                }
            }
            else {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];

                [ProgressHUD dismiss];
                MainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
                [self.navigationController pushViewController:mvc animated:NO];
            }
        }];
    }
}
//*********************************************






//*********************************************
// Remove Unwanted Characters from textfield

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    //Remove characters from email & username field
    NSCharacterSet *notAllowedEmailChars = [NSCharacterSet characterSetWithCharactersInString:@" \\`~!#$%^&*()-+=,<>/?;:'[{]}|_"];
    NSCharacterSet *notAllowedUsernameChars = [NSCharacterSet characterSetWithCharactersInString:@" \\`~!@#$%^&*()-+=,<.>/?;:'[{]}|"];
    
    if (textField == self.emailField) {
        textField.text = [textField.text lowercaseString];
        textField.text = [[textField.text componentsSeparatedByCharactersInSet:notAllowedEmailChars] componentsJoinedByString:@""];
        return YES;
    }
    if (textField == self.usernameField) {
        
        textField.text = [textField.text lowercaseString];
        textField.text = [[textField.text componentsSeparatedByCharactersInSet:notAllowedUsernameChars] componentsJoinedByString:@""];
        return YES;
    }
    return YES;
}
//*********************************************






//*********************************************
// Email and Username Length 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.emailField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 30) ? NO : YES;
    }
    
    //Username can only be 16 characters long
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 16) ? NO : YES;
    
}
//*********************************************





//*********************************************
// Terms Of Use & Privacy Policy Link

- (IBAction)termsOfUser:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://getyapster.com/terms.html"]];
}
//*********************************************
@end
