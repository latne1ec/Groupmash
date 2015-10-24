//
//  MainCollectionViewController.m
//  Groupmash
//
//  Created by Evan Latner on 9/27/15.
//  Copyright © 2015 Groupmash. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainViewController.h"

@interface MainCollectionViewController ()

@property (nonatomic, strong) MainViewController *camera;

@property (nonatomic, strong) FriendsTableViewController *fvc;



@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.camera = [[MainViewController alloc] init];
    self.delegate = self.camera;
    
    CGFloat w;
    CGFloat h;
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    self.fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Friends"];
    self.fvc.view.frame = CGRectMake(0, 0, w, h);
    [self addChildViewController:self.fvc];
    [self.view addSubview:self.fvc.view];
    self.fvc.view.alpha = 0.0;
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //[self.navigationController.navigationBar setHidden:NO];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = nil;
    
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        HeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        return header;
    }
    
    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        self.footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        return self.footer;
    }

    
    return view;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIScreen mainScreen] bounds].size.height <= 568.0) {
        return CGSizeMake(155, 130);
    }

    if ([[UIScreen mainScreen] bounds].size.height > 568.0) {
        return CGSizeMake(182, 144);
    }
    return CGSizeMake(0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (cell.groupImageView.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedGroup:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        cell.groupImageView.userInteractionEnabled = YES;
        [cell.groupImageView addGestureRecognizer:tap];
    }
    
    
    return cell;
}

-(void)tappedGroup:(UITapGestureRecognizer *)gesture {
    
    
    if ([self.test isEqualToString:@"hasImage"]) {
        NSLog(@"Blast off to AWS");
        //[self.delegate uploadPhoto];
        
    }
    
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *tappedIndexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    //CustomCollectionCell *cell = (CustomCollectionCell *)[self.collectionView cellForItemAtIndexPath:tappedIndexPath];

    NSLog(@"Item: %d", (int)tappedIndexPath.item);
    
        
}


- (IBAction)popToAddFriends:(id)sender {
    
    
    [UIView animateWithDuration:0.05 animations:^{
        
        //self.fvc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.fvc.view.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
