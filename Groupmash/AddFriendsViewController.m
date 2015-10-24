//
//  AddFriendsViewController.m
//  Yapster
//
//  Created by Evan Latner on 12/16/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "GMDCircleLoader.h"


@interface AddFriendsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation AddFriendsViewController

@synthesize segmentedControl;
@synthesize users;
@synthesize searchBar;
@synthesize deniedFriends;
@synthesize allContacts;
@synthesize userFromContactList;
@synthesize searchedContacts;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    //Local Notifications
    [TSMessage dismissActiveNotification];

    self.navigationItem.hidesBackButton = YES;
    self.currentUser = [PFUser currentUser];
    self.searchBar.delegate = self;
    users = [[NSMutableArray alloc] init];
    self.tableView.separatorColor = [UIColor colorWithRed:225/255.0f green:237/255.0f blue:236/255.0f alpha:1.0f];
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"searchBarNew.png"]];
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    //self.tableView.tableFooterView = [UIView new];
    //[self queryForTable];
    
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [ProgressHUD dismiss];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    //[self.tableView setContentOffset:CGPointMake(0, 44)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        [self.tableView setContentOffset:CGPointMake(0, 44)];
        [self queryForTable];
        [self.tableView reloadData];
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        NSString *phoneNumber = [[PFUser currentUser] objectForKey:@"phone"];
        
        if (phoneNumber == nil) {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        NSString *phoneNumber = [[PFUser currentUser] objectForKey:@"phone"];
        
        if (phoneNumber == nil) {
            
            
            [UIAlertView showWithTitle:@"Add Phone #"
                               message:@"Before we can show your friends from your address book, you must first add your phone number."
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@[@"Add Phone # Now"]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  
                                  if (buttonIndex == [alertView cancelButtonIndex]) {
                                      //Cancel Button pressed
                                      //[segmentedControl setSelectedSegmentIndex:1];
                                      
                                  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add Phone # Now"]) {
                                      
                                      
//                                      EditMobileNumberViewController *epvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
//                                      
//                                      [self.navigationController pushViewController:epvc animated:YES];
                                  }
                                  
                              }];
        }

        else {
        
        [self getContacts];
        [self queryForContacts];
        [self.tableView reloadData];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self searchBarCancelled];
}


//*********************************************
// Dismiss Active Keyboard

- (void) dismissKeyboard {
    // add self
    [self.searchBar resignFirstResponder];
}
//*********************************************





//*********************************************
// Segmented Control Index Has Changed

- (IBAction)indexChanged:(id)sender {
    
    if (segmentedControl.selectedSegmentIndex==0) {
        
        self.tableView.tableFooterView = UITableViewStylePlain;
        [self.tableView setContentOffset:CGPointMake(0, 44)];
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [TSMessage dismissActiveNotification];
        self.tableView.scrollEnabled = YES;
        self.searchBar.placeholder = @"Search";
        [self queryForTable];
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
        
    }
    else if (segmentedControl.selectedSegmentIndex==1) {
        
        self.tableView.tableFooterView = UITableViewStylePlain;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [TSMessage dismissActiveNotification];
        self.searchBar.hidden = NO;
        self.searchBar.placeholder = @"Search Users";
        [self.tableView reloadData];
        [searchBar becomeFirstResponder];
    }
    
    else if (segmentedControl.selectedSegmentIndex==2) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.searchBar.placeholder = @"Search Contacts";
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        NSString *phoneNumber = [[PFUser currentUser] objectForKey:@"phone"];
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [TSMessage dismissActiveNotification];
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
        if (phoneNumber == nil) {
            
            
            [UIAlertView showWithTitle:@"Add Phone #"
                               message:@"Before ChitChat can find your friends from your address book, you must first add your phone number."
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@[@"Add Phone # Now"]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  
                                  if (buttonIndex == [alertView cancelButtonIndex]) {
                                      //Cancel Button pressed
                                      
                                  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add Phone # Now"]) {
                                     
//                                      EditMobileNumberViewController *epvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
//                                      
//                                      [self.navigationController pushViewController:epvc animated:YES];
                                  }
            
                }];
        }
        
        else {

        self.tableView.scrollEnabled = YES;
        self.searchBar.placeholder = @"Search Contacts";
        [searchBar resignFirstResponder];
        [self getContacts];
        [self queryForContacts];
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
            
        }
    }

}
//*********************************************







//*********************************************
// Set Up Table View

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (segmentedControl.selectedSegmentIndex == 0) {
    
    return 1;
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        
        if (self.users) {
            return 1;
            
        }
        else {
            return 0;
        }
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        
        return 2;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    [[UIView appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setBackgroundColor:[UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f]];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:12]];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor colorWithRed:5/255.0f green:211/255.0f blue:255/255.0f alpha:1.0f]];
    
     if (segmentedControl.selectedSegmentIndex == 0) {
         return @"Friend Requests";
     }
     if (segmentedControl.selectedSegmentIndex == 1) {
         
         return nil;
     }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        
        if (section == 0) {
            return @"Add Friends From Contacts";
        }
        if (section == 1) {
            
            return nil;
        }
        
    }
    
        return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        if (self.friendRequests.count == 0) {
            return 0;
        }
        else {
            
        return self.friendRequests.count;
        }
    }

    if (segmentedControl.selectedSegmentIndex == 1) {
    if (self.users.count >= 1) {
        return 1;
    }
    
    else {
        return 0;
        }
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        if (section == 0) {
            
        return self.userFromContactList.count;
        }
        
        
        if (section == 1) {
            
            
            
            if (self.userFromContactList.count == 0) {
                return 0;
            }
            
            NSString *phoneNumber = [[PFUser currentUser] objectForKey:@"phone"];
            
            if (phoneNumber == nil) {
                return 0;
            }
        
            else {
            return 1;
            }
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"InviteCell";
    
    AddFriendTableCell *cell = (AddFriendTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ContactTableCell *cell2 = (ContactTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        if (self.friendRequests) {
            
            
            if (self.friendRequests.count == 0) {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            else {
                
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
            cell.addFriendButton.tag = indexPath.row;
            [cell.addFriendButton addTarget:self action:@selector(friendRequest:) forControlEvents:UIControlEventTouchUpInside];
            cell.addFriendButton.selected = NO;
            
            PFObject *object = self.friendRequests[indexPath.row];
            PFObject *user = object[@"from"];
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                if (!error) {
                cell.usernameLabel.text = user[@"username"];
                cell.displayNameLabel.text = user[@"displayName"];
                    
                    NSArray *alreadyHomies = [[PFUser currentUser] objectForKey:@"friendsList"];
                    if ([alreadyHomies containsObject:user.objectId]) {
                        
                        //Set Button image selected
                        cell.addFriendButton.enabled = NO;
                        UIImage *someImage = [UIImage imageNamed:@"checked.png"];
                        [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                        [cell.addFriendButton setImage:someImage forState:UIControlStateDisabled];
                    }
                

                
                }
            }];
            }
        }
        
        
        return cell;
    }
    

    if (segmentedControl.selectedSegmentIndex == 1) {
        
        if (self.users) {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.addFriendButton.tag = indexPath.row;
            [cell.addFriendButton addTarget:self action:@selector(friendRequest:) forControlEvents:UIControlEventTouchUpInside];
       
            //Add username to cell
            PFUser *user = users[indexPath.row];
            cell.usernameLabel.text = user[@"username"];
            cell.displayNameLabel.text = user[@"displayName"];
            
            if ([user.username isEqualToString:[PFUser currentUser].username]) {
                NSLog(@"me");
                cell.addFriendButton.selected = YES;
                UIImage *someImage = [UIImage imageNamed:@"checked.png"];
                [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                [cell.addFriendButton setImage:someImage forState:UIControlStateSelected];
                
            }
            
          else if ([self alreadyFriends:user]) {
                //NSLog(@"HELLO Already friends");
                cell.addFriendButton.selected = YES;
                UIImage *someImage = [UIImage imageNamed:@"checked.png"];
                [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                [cell.addFriendButton setImage:someImage forState:UIControlStateSelected];
                
                
                }
            
            else {
                //NSLog(@"Not Friends");
                cell.addFriendButton.selected = NO;
                UIImage *someImage = [UIImage imageNamed:@"addFriend"];
                [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                [cell.addFriendButton setImage:someImage forState:UIControlStateSelected];
                
                }
        
            
            }
        }
    
        if (segmentedControl.selectedSegmentIndex == 2) {
            
            if (indexPath.section == 0) {
                
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            //ENABLE ADD FRIEND BUTTON
            cell.addFriendButton.tag = indexPath.row;
            [cell.addFriendButton addTarget:self action:@selector(friendRequest:) forControlEvents:UIControlEventTouchUpInside];
            
            //Add username to cell
            PFUser *user = [self.userFromContactList objectAtIndex:indexPath.row];
            cell.usernameLabel.text = user[@"username"];
            cell.displayNameLabel.text = user[@"displayName"];
            
            //CHECK IF ALREADY FRIENDS
            if ([self alreadyFriends:user]) {
                //NSLog(@"HELLO Already friends");
                cell.addFriendButton.selected = YES;
                UIImage *someImage = [UIImage imageNamed:@"checked.png"];
                [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                [cell.addFriendButton setImage:someImage forState:UIControlStateSelected];
                
            }
            
            else {
                //NSLog(@"Not Friends");
                cell.addFriendButton.selected = NO;
                UIImage *someImage = [UIImage imageNamed:@"addFriend"];
                [cell.addFriendButton setImage:someImage forState:UIControlStateHighlighted];
                [cell.addFriendButton setImage:someImage forState:UIControlStateSelected];
                
                }
            }
            
            if (indexPath.section == 1) {
                
                
                
                CALayer *btnLayer = [cell2.inviteContactsButton layer];
                [btnLayer setMasksToBounds:YES];
                [btnLayer setCornerRadius:3.0f];
                
                [cell2.inviteContactsButton addTarget:self action:@selector(inviteContacts:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell2;
                
                
                
            }
            
        }
        return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 58.0f;
    }
    if (indexPath.section == 1)   {
        return 175.0f;
    }

    return 0;
}



//***********************************************************************
// Empty Table View Properties

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (segmentedControl.selectedSegmentIndex == 0) {

    
    NSString *text = @"No friend requests \U0001F62D";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.796 blue:0.796 alpha:1],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
     
        NSString *text = @"Can't find any contacts \U0001F62D";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16],
                                     NSForegroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.796 blue:0.796 alpha:1],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
    }
    
    
    return nil;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        if (self.friendRequests.count == 0) {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return YES;
        }
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        
        if (self.userFromContactList.count == 0) {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return YES;
        }
    }
    
    return NO;

}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    
     if (segmentedControl.selectedSegmentIndex == 2) {
         
         if (self.userFromContactList.count == 0) {
             
         
         
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.02 green:0.78 blue:1 alpha:1]};
    
    
    return [[NSAttributedString alloc] initWithString:@"Invite a few" attributes:attributes];
         
         }
     }
    
    return nil;
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
 
    [self inviteContacts:self];
    
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
 
    if (segmentedControl.selectedSegmentIndex == 0) {
        return CGPointMake(0, -roundf(self.tableView.frame.size.height/5));
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        return CGPointMake(0, -roundf(self.tableView.frame.size.height/5));
    }
    return CGPointZero;
    
}

//***********************************************************************







//*********************************************
// Delete Table Cell/Friend Request

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return YES;
    }
    else {
        return NO;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
            return UITableViewCellEditingStyleDelete;
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (segmentedControl.selectedSegmentIndex == 0) {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
    
                if (self.friendRequests.count == 0) {
                    
                    NSLog(@"0 requests left");
                    [self queryForTable];
                    [self.tableView reloadData];
                    tableView.editing = NO;
                }
                else {
                
                [self.deniedFriends removeObjectAtIndex:indexPath.row];
                PFObject *requestStatus = self.friendRequests[indexPath.row];
                [requestStatus setObject:@"denied" forKey:@"status"];
                [requestStatus saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (!error) {
                        [self queryForTable];
                        [self.tableView reloadData];
                    }
                    else {
                        NSLog(@"something went wrong");
                        }
                    }];
                }
            }
        }
}
//*********************************************




//*******************************************************
// Check if already friends **DEPRECATED**

-(BOOL)isFriend:(PFUser *)user {
    
    for (PFUser *friend in self.homies) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return  NO;
}
//*******************************************************



//*******************************************************
//Check if already friends from array **NEW**

-(BOOL)alreadyFriends:(PFUser *)user {

    PFUser *currentUser = [PFUser currentUser];
    NSArray *alreadyFriends = [currentUser objectForKey:@"friendsList"];
    if ([alreadyFriends containsObject:user.objectId]) {
        
        return YES;
    }
    
    return NO;
    
}
//*********************************************



//*******************************************************
//Check if friend request has been sent **DEPRECATED**

-(BOOL)friendRequestSent:(PFUser *)user {
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *friendsRequested = [currentUser objectForKey:@"friendsRequestedList"];
    if ([friendsRequested containsObject:user.objectId]) {
        
        return YES;
    }
    
    return NO;
}
//*********************************************


//*******************************************************
// Accept and send friend requests

- (IBAction)friendRequest:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    
    //ACTION FOR FRIEND REQUEST INDEX
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        
        AddFriendTableCell *cell = (AddFriendTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:senderButton.tag inSection:0]];
        NSLog(@"jj %@", cell);
        
        [ProgressHUD showSuccess:@"Friend added"];
        
        senderButton.selected = YES;
        UIImage *someImage = [UIImage imageNamed:@"checked.png"];
        [senderButton setImage:someImage forState:UIControlStateHighlighted];
        [senderButton setImage:someImage forState:UIControlStateSelected];
        
        PFObject *friendRequest = [self.friendRequests objectAtIndex:senderButton.tag];
        PFUser *fromUser = [friendRequest objectForKey:@"from"];
        [PFCloud callFunctionInBackground:@"addFriendToFriendsRelation" withParameters:@{@"friendRequest" : friendRequest.objectId} block:^(id object, NSError *error) {
        
        if (!error) {
            NSLog(@"added %@ to friends", fromUser.username);
            PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
            [friendsRelation addObject:fromUser];
            [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    //Add objectId to array of friends added
                    [[PFUser currentUser] addUniqueObject:fromUser.objectId forKey:@"friendsList"];
                    [[PFUser currentUser] saveInBackground];
                    
                    [PFAnalytics trackEvent:@"FriendsAccepted"];
                    
                    
                    //SEND PUSH NOTIFICATION TO "FROM" USER
                    NSString *message = [NSString stringWithFormat:@"you and %@ are now friends!", [PFUser currentUser].username];
                    
                    [PFCloud callFunctionInBackground:@"sendFriendRequestNotification"
                                       withParameters:@{@"recipientId":
                                                            fromUser.objectId,
                                                        @"message": message}
                                                block:^(NSString *success, NSError *error) {
                                                    if (!error) {
                                                        
                                                        [PFAnalytics trackEvent:@"FriendRequests"];
                                                    }
                                                    else {
                                                        [ProgressHUD showError:@"Bummer, something went wrong"];
                                                    }
                                                }];
                    
                    
                    
                } else {
                    
                }
            }];
        }
    }];
    
    }

    //ACTION FOR SEARCH USERS INDEX
    if (segmentedControl.selectedSegmentIndex == 1) {
    
    if (senderButton.selected == NO) {
        //ADD FRIEND AT INDEX PATH
        
        //Add objectId to array of sent friend requests
        //changed to "friendsList" from "friendsRequestedList"
        [[PFUser currentUser] addUniqueObject:self.foundUser.objectId forKey:@"friendsList"];
        [[PFUser currentUser] saveInBackground];
        
        senderButton.selected = YES;
        UIImage *someImage = [UIImage imageNamed:@"checked.png"];
        [senderButton setImage:someImage forState:UIControlStateHighlighted];
        [senderButton setImage:someImage forState:UIControlStateSelected];
        
        
        PFObject *friendRequest = [PFObject objectWithClassName:@"FriendRequest"];
        [friendRequest setObject:[PFUser currentUser]  forKey:@"from"];
        [friendRequest setObject:self.foundUser forKey:@"to"];
        [friendRequest setObject:@"pending" forKey:@"status"];
        [friendRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                
                [ProgressHUD showSuccess:@"Friend Request sent"];
                
                //SEND PUSH NOTIFICATION TO "TO" USER
                 NSString *message = [NSString stringWithFormat:@"%@ wants to be friends", [PFUser currentUser].username];
                
                [PFCloud callFunctionInBackground:@"sendFriendRequestNotification"
                                   withParameters:@{@"recipientId":
                                                        self.foundUser.objectId,
                                                    @"message": message}
                                            block:^(NSString *success, NSError *error) {
                                                if (!error) {
                                                    
                                                    [PFAnalytics trackEvent:@"FriendRequests"];
                                                }
                                                else {
                                                    [ProgressHUD showError:@"Bummer, something went wrong"];
                                                }
                                            }];
                            } else {
                    
                    }
                }];
            }
        }
    
    //ACTION FOR CONTACT LIST FRIEND REQUEST
    if (segmentedControl.selectedSegmentIndex == 2) {
        
        AddFriendTableCell *cell = (AddFriendTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:senderButton.tag inSection:0]];
        NSLog(@"jj %@", cell);
        
        PFObject *contactRequest = [self.userFromContactList objectAtIndex:senderButton.tag];
        
        PFUser *user = [self.userFromContactList objectAtIndex:senderButton.tag];
        
        if (senderButton.selected == NO) {
            
            //Add objectId to array of sent friend requests **changed to "friendsList"
            
            [[PFUser currentUser] addUniqueObject:user.objectId forKey:@"friendsList"];
            [[PFUser currentUser] saveInBackground];
            
            //ADD FRIEND AT INDEX PATH
            senderButton.selected = YES;
            UIImage *someImage = [UIImage imageNamed:@"checked.png"];
            [senderButton setImage:someImage forState:UIControlStateHighlighted];
            [senderButton setImage:someImage forState:UIControlStateSelected];
            
            
            PFObject *friendRequest = [PFObject objectWithClassName:@"FriendRequest"];
            [friendRequest setObject:[PFUser currentUser]  forKey:@"from"];
            [friendRequest setObject:contactRequest forKey:@"to"];
            [friendRequest setObject:@"pending" forKey:@"status"];
            [friendRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [ProgressHUD showSuccess:@"Friend Request sent"];
                    
                    //Number of Friend Requests Sent From Contact List
                    [PFAnalytics trackEvent:@"ContactRequests"];
                    
                    
                    //PFUser *user = [self.userFromContactList objectAtIndex:senderButton.tag];
                    
                    
                    //SEND PUSH NOTIFICATION TO "TO" USER
                    NSString *message = [NSString stringWithFormat:@"%@ wants to be friends", [PFUser currentUser].username];
                    
                    [PFCloud callFunctionInBackground:@"sendFriendRequestNotification"
                                       withParameters:@{@"recipientId":
                                                            contactRequest.objectId,
                                                        @"message": message}
                                                block:^(NSString *success, NSError *error) {
                                                    if (!error) {
                                                    }
                                                    else {
                                                        [ProgressHUD showError:@"Bummer, something went wrong"];
                                                    }
                                                }];
                    
                } else {
                    
                }
            }];
        }
    }

}
//*********************************************







//*************************************
// Query for Friend Requests

- (PFQuery *)queryForTable {
    
    //[ProgressHUD show:nil];
    PFQuery *requestsToCurrentUser = [PFQuery queryWithClassName:@"FriendRequest"];
    [requestsToCurrentUser whereKey:@"to" equalTo:[PFUser currentUser]];
    [requestsToCurrentUser whereKey:@"from" notEqualTo:[PFUser currentUser]];
    [requestsToCurrentUser whereKey:@"status" equalTo:@"pending"];
    [requestsToCurrentUser orderByAscending:@"username"];
    [requestsToCurrentUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.friendRequests = objects;
            
            if (self.friendRequests.count == 0) {
                [ProgressHUD dismiss];
                
            }

           if (self.friendRequests.count >= 1) {
               
            self.friendRequests = objects;
            [ProgressHUD dismiss];
            [self.tableView reloadData];
            deniedFriends = [objects mutableCopy];
               
            }
        }
    }];
    return nil;
}
//*************************************




//*************************************
// Search Userbase functionality

- (void)searchUsers:(NSString *)search_lower {
        
    
    
    if (segmentedControl.selectedSegmentIndex == 1) {
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
        
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" hasPrefix:searchText];
    [query whereKey:@"username" equalTo:searchText];
    [query setLimit:1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if (error == nil) {
             
             [GMDCircleLoader hideFromView:self.view animated:YES];
             
             [users removeAllObjects];
             [users addObjectsFromArray:objects];
             [self.tableView reloadData];
             self.foundUser = objects.lastObject;
         }
         else [ProgressHUD showError:@"Network error"];
     }];
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"phone" containedIn:allContacts];
        [query whereKey:@"username" containsString:searchText];
        [query orderByAscending:@"username"];
        [query setLimit:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error == nil) {
                
                [userFromContactList removeAllObjects];
                [userFromContactList addObjectsFromArray:objects];
                [self.tableView reloadData];
                self.searchedContact = objects.lastObject;
                
            }
            else [ProgressHUD showError:@"Network error"];
        }];
    }
}
//*********************************************





//*********************************************
// Search Bar Properties



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
        
    if ([searchText length] > 0) {
        [self searchUsers:[searchText lowercaseString]];
    }
    else if (segmentedControl.selectedSegmentIndex == 2) {
        
        if ([searchText length] > 0) {
            [self searchUsers:[searchText lowercaseString]];
        }
        else {
            [self queryForContacts];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_ {
    [searchBar_ setShowsCancelButton:NO animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_ {
    [searchBar_ setShowsCancelButton:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarCancelled];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
    
    NSLog(@"SEARCHH");
    
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self searchUsers:searchText];
    //[searchBar_ resignFirstResponder];
}
- (void)searchBarCancelled {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
//*********************************************






//*************************************
//ACCESS USER CONTACT LIST

- (void) getContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        allContacts = [[NSMutableArray alloc] init];
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                
               // NSString *contactName = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(person, i);
                
                NSString *modifiedString = [[phoneNumber componentsSeparatedByCharactersInSet:
                                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                            componentsJoinedByString:@""];
                
            
                [allContacts addObject:modifiedString];
            }
        
        }
        
        [self queryForContacts];
    }
    else {
        
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Enable Access" message:@"ChitChat can't find your friends until you give us permission to access your contacts. You can enable access in Settings-> Privacy-> Contacts-> ChitChat" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
}
//*************************************






//*************************************
//QUERY FOR CONTACTS On Yapster Already

- (PFQuery *)queryForContacts {

    [ProgressHUD show:nil];
    PFQuery *query = [PFUser query];
    [query whereKey:@"phone" containedIn:allContacts]; //containedIn:_allContacts
    [query orderByAscending:@"username"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            [ProgressHUD dismiss];
            self.userFromContactList = objects;
            
            if (self.userFromContactList.count == 0) {
                
                
            }
            [self.tableView reloadData];
        }
        else {
        }
    }];
    return nil;
}
//*************************************





- (IBAction)inviteContacts:(id)sender {
    
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *textBody = @"Add me on ChitChat.\nMy username: DAUSERNAME";
            
            NSString* newString = [textBody stringByReplacingOccurrencesOfString:@"DAUSERNAME" withString:[PFUser currentUser].username];
            
            
            controller.body = newString;
            controller.messageComposeDelegate = self;
            [controller.navigationBar setTintColor:[UIColor whiteColor]];
            [self presentViewController:controller animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                
            }];
        });
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller   didFinishWithResult:(MessageComposeResult)result {
    
    if (result == MessageComposeResultCancelled) {
        
        NSLog(@"Message cancelled");
        
        [PFAnalytics trackEvent:@"SMSInviteCancelled"];
        
        
    } else if (result == MessageComposeResultSent) {
        
        NSLog(@"Message sent");
        
        [PFAnalytics trackEvent:@"SMSInviteSent"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

//*********************************************
// Pop back to User Profile

- (IBAction)popToProfile:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
//*********************************************



//*********************************************
// Handle Incoming Remote Push Notification
-(void)handleThePushNotification:(NSDictionary *)userInfo{
    
    //set some badge view here
}
//*********************************************

@end
