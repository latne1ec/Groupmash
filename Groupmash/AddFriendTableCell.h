//
//  AddFriendTableCell.h
//  Yapster
//
//  Created by Evan Latner on 12/19/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;

@property (weak, nonatomic) IBOutlet UIButton *denyFriendButton;


@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
