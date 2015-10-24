//
//  LoginTableViewController.m
//  Yapster
//
//  Created by Evan Latner on 12/15/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import "LoginTableViewController.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

@synthesize usernameCell, passwordCell, forgotPasswordCell;
@synthesize usernameField, passwordField;
@synthesize fpView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    [TSMessage setDefaultViewController:self];
    [TSMessage setDelegate:self];
    

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [usernameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return usernameCell;
    if (indexPath.row == 1) return passwordCell;
    //if (indexPath.row == 2) return forgotPasswordCell;
    
    
    return nil;
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    
    if([usernameField isFirstResponder]){
        
        [passwordField becomeFirstResponder];
    }
    else if ([passwordField isFirstResponder]){
        
        [passwordField resignFirstResponder];
        [self login:self];
    }
    
    return YES;
}


- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0) {
        
        [ProgressHUD showError:@"Enter your Username"];

    }
    
   else if ([password length] == 0) {
        
       [ProgressHUD showError:@"Enter your Password"];
       
    }
    else {
        [ProgressHUD show:nil];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
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
                [ProgressHUD dismiss];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];

               //Present Camera
                MainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
                [self.navigationController pushViewController:mvc animated:NO];
                
               //[self.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    //Remove characters from username field
    NSCharacterSet *notAllowedUsernameChars = [NSCharacterSet characterSetWithCharactersInString:@" \\`~!@#$%^&*()-+=,<.>/?;:'[{]}|"];
    
    if (textField == self.usernameField) {
        textField.text = [textField.text lowercaseString];
        textField.text = [[textField.text componentsSeparatedByCharactersInSet:notAllowedUsernameChars] componentsJoinedByString:@""];
        return YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Set length of username to 16 characters
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 16) ? NO : YES;
}

@end
