//
//  PasswordResetViewController.h
//  Yapster
//
//  Created by Evan Latner on 1/6/15.
//  Copyright (c) 2015 Level Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PasswordResetViewController : UITableViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *labelCell;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)doneButton:(id)sender;

@end
