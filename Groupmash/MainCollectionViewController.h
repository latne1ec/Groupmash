//
//  MainCollectionViewController.h
//  Groupmash
//
//  Created by Evan Latner on 9/27/15.
//  Copyright © 2015 Groupmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionCell.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "NoPushSegue.h"
#import "AddFriendsViewController.h"
#import "FriendsTableViewController.h"

@class MainCollectionViewController;

@protocol MainCollectionViewControllerDelegate <NSObject>

-(void)uploadPhoto;


@end

@interface MainCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>


@property(nonatomic,weak) IBOutlet id<MainCollectionViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *test;
@property (nonatomic, strong) UIImage *dasImage;

@property (nonatomic, strong) FooterView *footer;


- (IBAction)popToAddFriends:(id)sender;


@end
