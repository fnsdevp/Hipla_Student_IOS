//
//  ManualAttendenceViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 24/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"
#import "SWNinePatchImageFactory.h"
#import "SuccessAttendenceViewController.h"

@interface ManualAttendenceViewController : ViewController<KYDrawerControllerDelegate,sharedZoneDetectionDelegate>

@property (weak, nonatomic) NSDictionary *userInfoDict;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) IBOutlet UIImageView *redBox;
@property (nonatomic, strong) MapPin *pressedPin;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *btnManual;

@end
