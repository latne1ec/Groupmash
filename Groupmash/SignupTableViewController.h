//
//  SignupTableViewController.h
//  Yapster
//
//  Created by Evan Latner on 12/15/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "TSMessageView.h"
#import "MainViewController.h"



@interface SignupTableViewController : UITableViewController <UITextFieldDelegate, TSMessageViewProtocol>

@property (strong, nonatomic) IBOutlet UITableViewCell *emailCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *termsCell;

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signup:(id)sender;

- (IBAction)termsOfUser:(id)sender;



@end
