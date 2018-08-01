//
//  ProfileViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 13/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZoneDetection.h"

@class ViewController;

@interface ProfileViewController : ViewController<KYDrawerControllerDelegate,sharedZoneDetectionDelegate>
{
    BOOL routineUpdated;
    BOOL userUpdated;
}
@property (weak, nonatomic) IBOutlet UIView *viewStudent;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblStream;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailID;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lbladdress;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;

@property (nonatomic, strong) NSFileManager *filemgr;
@property (nonatomic, strong) NSString *NewDir;
@property (nonatomic, strong) NSArray *dirPaths;
@property (nonatomic, strong) NSString *docsDir;

@property (nonatomic, strong) NSArray *zoneArray;
@property (nonatomic, strong) NSMutableArray *userRoutineInfo;
@property (nonatomic, strong) NSMutableArray *routineArr;
@property (nonatomic, strong) NSString *currentDateStr;

@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;

@property (strong, nonatomic) NSDictionary *userInfoDict;

@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
