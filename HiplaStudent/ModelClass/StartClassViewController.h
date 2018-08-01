//
//  StartClassViewController.h
//  HiplaStudent
//
//  Created by FNSPL on 10/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"
#import "AttendanceViewController.h"
#import "NavigationViewController.h"

@interface StartClassViewController : ViewController<KYDrawerControllerDelegate,sharedZoneDetectionDelegate>
{
    // NSTimer *startTimer;
    float minute, second;
    float minutesLeft;
    NSString *startTime;
    BOOL inClass;

}
@property (weak, nonatomic) IBOutlet UILabel *lblclassSection;
@property (weak, nonatomic) IBOutlet UILabel *lblTeacherName;
@property (weak, nonatomic) IBOutlet UILabel *lblPeriod;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) NSString *strNotif;
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

@property (nonatomic, strong) NSString *roomName;
@property (weak, nonatomic) NSDictionary *userInfoDict;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
