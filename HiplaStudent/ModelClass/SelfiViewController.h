//
//  SelfiViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 23/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"
#import "ManualAttendenceViewController.h"
#import "UIImage+FixOrientation.h"
#import "UIImage+Crop.h"
#import "ImageHelper.h"
#import "PersonFace.h"
#import "GroupPerson.h"
#import "PersonGroup.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>
#import "CommonUtil.h"

static NSString *const ProjectOxfordFaceSubscriptionKey = @"b4edf8e8d7474f1a90f11e3a57a8d57e";

static NSString *const ProjectOxfordFaceEndpoint = @"https://southeastasia.api.cognitive.microsoft.com/face/v1.0/";

typedef enum {
    VerificationTypeFaceAndFace = 0,
    VerificationTypeFaceAndPerson = 1
}VerificationType;

@interface SelfiViewController : ViewController<KYDrawerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,sharedZoneDetectionDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTakeImage;
@property (weak, nonatomic) IBOutlet UIView *viewSubmit;
@property (weak, nonatomic) IBOutlet UIView *viewSelfie;
@property (weak, nonatomic) IBOutlet UIButton *btnTakeImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property(nonatomic, assign) VerificationType verificationType;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) MapPin *pressedPin;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;

@property (nonatomic, strong) NSMutableArray *detectionFaces;

@property (weak, nonatomic) IBOutlet UIImageView *selfiImageVw;
@property (weak, nonatomic) NSDictionary *userInfoDict;

- (IBAction)btnTakeImage:(id)sender;
- (IBAction)btnSubmit:(id)sender;

@end
