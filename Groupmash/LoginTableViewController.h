//
//  LoginTableViewController.h
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



@interface LoginTableViewController : UITableViewController <UITextFieldDelegate, TSMessageViewProtocol>

@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (strong, nonatomic) IBOutlet UIView *fpView;


@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITableViewCell *forgotPasswordCell;

- (IBAction)login:(id)sender;


@end
