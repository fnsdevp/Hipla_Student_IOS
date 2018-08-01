//
//  SuccessAttendenceViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 24/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"
#import "SWNinePatchImageFactory.h"

@interface SuccessAttendenceViewController : ViewController<KYDrawerControllerDelegate,sharedZoneDetectionDelegate>
{
   // NSTimer *startTimer;
    float minute, second;
    int minutesLeft;
    NSTimeInterval interval;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBranch;
@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) IBOutlet UIImageView *greenBox;
@property (nonatomic, strong) MapPin *pressedPin;
@property (assign, nonatomic) BOOL isStart;
@property (nonatomic, assign) float timeCal;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) NSDictionary *userInfoDict;
@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
