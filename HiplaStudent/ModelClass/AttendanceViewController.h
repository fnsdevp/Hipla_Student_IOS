//
//  AttendanceViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 23/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"
#import "SelfiViewController.h"

@interface AttendanceViewController : ViewController<KYDrawerControllerDelegate,sharedZoneDetectionDelegate>
{
   // NSTimer *startTimerAT;
    float minute, second;
    float minutesLeft;
    
    NSString *routinehistoryidStr;
    NSString *startTime;
}
@property (weak, nonatomic) IBOutlet UILabel *lblclassSection;
@property (weak, nonatomic) IBOutlet UILabel *lblTeacherName;
@property (weak, nonatomic) IBOutlet UILabel *lblLecture;
@property (weak, nonatomic) IBOutlet UILabel *lblSubjectName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewYes;
@property (weak, nonatomic) IBOutlet UIView *viewNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (assign, nonatomic) BOOL isStart;
@property (nonatomic, assign) float timeCal;

@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) MapPin *pressedPin;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) NSDictionary *userInfoDict;

- (IBAction)btnYes:(id)sender;
- (IBAction)btnNo:(id)sender;

@end
