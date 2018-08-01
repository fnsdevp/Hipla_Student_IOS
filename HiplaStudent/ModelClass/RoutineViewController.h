//
//  RoutineViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 13/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Common.h"
#import "NSDictionary+NullReplacement.h"
#import "NavigationViewController.h"

@interface RoutineViewController : ViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,RoutineCollectionViewCellDelegate,sharedZoneDetectionDelegate>{
    
    NSString *locationName;
   // Database *db;
    NSDate *nextday;
    NSString *month;
    NSString *date;
    NSString *day;
    
    NSString *selectedDate;
    
    NSDate *initialDate;
    
    int btnTag;
    
    BOOL isSelectedDate;
    BOOL isSelectedTime;
    
    BOOL isCurrentWeek;
    
    int seletedTag;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDates;
@property (weak, nonatomic) IBOutlet UITableView *tblVwRoutines;

@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSArray *arrTiming;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) NSDictionary *userInfoDict;
@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *currentDateStr;

@end
