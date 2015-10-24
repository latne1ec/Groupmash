//
//  WelcomeViewController.m
//  Groupmash
//
//  Created by Evan Latner on 9/27/15.
//  Copyright © 2015 Groupmash. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([PFUser currentUser]) {
        MainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
        [self.navigationController pushViewController:mvc animated:NO];
    }

}

@end
