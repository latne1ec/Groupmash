//
//  FriendsTableViewController.m
//  Groupmash
//
//  Created by Evan Latner on 9/29/15.
//  Copyright © 2015 Groupmash. All rights reserved.
//

#import "FriendsTableViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Loaded");
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}



- (IBAction)closeController:(id)sender {
    
    self.view.alpha = 0.0;
}
@end
