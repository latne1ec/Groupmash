//
//  AddFriendsViewController.h
//  Yapster
//
//  Created by Evan Latner on 12/16/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "AddFriendTableCell.h"
#import "ContactTableCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TSMessageView.h"
//#import "SettingsNavController.h"
#import "UIAlertView+Blocks.h"
//#import "EditMobileNumberViewController.h"
#import "MessageUI/MessageUI.h"





@interface AddFriendsViewController : UITableViewController <UISearchBarDelegate, TSMessageViewProtocol, UIAlertViewDelegate,  MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)indexChanged:(id)sender;

@property (nonatomic, strong) NSArray *friendRequests;
@property (nonatomic, strong) NSMutableArray *deniedFriends;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) PFUser *foundUser;

@property (nonatomic, strong) PFUser *friendRequestedUser;

@property (nonatomic, strong) PFUser *searchedContact;


@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) NSArray *allUsers;

@property (nonatomic, strong) NSMutableArray *homies;

@property (nonatomic, strong) PFRelation *friendsRelation;

//Contacts
@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSMutableArray *userFromContactList;
@property (nonatomic, strong) NSMutableArray *searchedContacts;

@property (nonatomic, strong) NSMutableArray *userToInvite;





- (IBAction)friendRequest:(id)sender;



- (IBAction)popToProfile:(id)sender;

- (IBAction)inviteContacts:(id)sender;



- (BOOL)isFriend:(PFUser *)user;
-(BOOL)friendRequestSent:(PFUser *)user;
-(BOOL)alreadyFriends:(PFUser *)user;





@end
