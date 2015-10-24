//
//  ContactTableCell.h
//  Yapster
//
//  Created by Evan Latner on 1/19/15.
//  Copyright (c) 2015 Level Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactName;

@property (weak, nonatomic) IBOutlet UIButton *inviteContactsButton;



@end
