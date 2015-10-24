//
//  MainViewController.h
//  Groupmash
//
//  Created by Evan Latner on 9/26/15.
//  Copyright © 2015 Groupmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"
#import "SCSwipeableFilterView.h"
#import "MainCollectionViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <Bolts/Bolts.h>


@interface MainViewController : UIViewController

<SCRecorderDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, MainCollectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;
@property (weak, nonatomic) IBOutlet UIView *downBar;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraModeButton;
@property (weak, nonatomic) IBOutlet UIButton *reverseCamera;
@property (weak, nonatomic) IBOutlet UIButton *flashModeButton;
@property (weak, nonatomic) IBOutlet UIButton *capturePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *ghostModeButton;
@property (nonatomic, strong) IBOutlet UIButton *selfieButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIProgressView *videoProgress;
@property (nonatomic, strong) IBOutlet UIButton *flash;
@property (nonatomic, strong) IBOutlet UIButton *menu;
//@property (nonatomic, strong) PFGeoPoint *userLocation;
@property(nonatomic,strong) UIView *imageSelectedView;
@property(nonatomic,strong) UIImageView *capturedImageView;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIView *photoOverlayView;
@property (nonatomic, strong) UITextField *caption;
@property (assign, nonatomic) AVCaptureDevicePosition device;


@property (nonatomic, strong) UIScrollView *scrollView;




@property (nonatomic, strong) UITapGestureRecognizer *camTap;


//AWS
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;

@property (nonatomic, strong) NSString *awsPicUrl;

@property (strong, nonatomic) IBOutlet SCSwipeableFilterView *filterSwitcherView;

///Upload to parse

//@property (nonatomic, strong) PFObject *event;
//@property (nonatomic, strong) PFGeoPoint *eventLocation;
@property (nonatomic, strong) UIButton *uploadPhotoButton;

@property (nonatomic, strong) UIButton *sendButton;





- (IBAction)snapPicButtonTapped:(id)sender;


- (IBAction)switchFlash:(id)sender;
- (IBAction)capturePhoto:(id)sender;
-(void)uploadPhoto;



@end
