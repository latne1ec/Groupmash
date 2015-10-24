//
//  PasswordResetViewController.m
//  Yapster
//
//  Created by Evan Latner on 1/6/15.
//  Copyright (c) 2015 Level Labs. All rights reserved.
//

#import "PasswordResetViewController.h"

@interface PasswordResetViewController ()

@end

@implementation PasswordResetViewController

@synthesize emailCell, emailField, labelCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.emailField.delegate = self;

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [emailField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [emailField resignFirstResponder];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return emailCell;
    if (indexPath.row == 1) return labelCell;
    
    return nil;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    
    if([emailField isFirstResponder]){
        
        [self doneButton:self];
    }
    
    return YES;
}


- (IBAction)doneButton:(id)sender {
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [PFUser requestPasswordResetForEmailInBackground:email];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Link" message:@"A password reset link has been sent to your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
