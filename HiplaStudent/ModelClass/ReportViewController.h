//
//  ReportViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 16/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleBarChart.h"
#import "ViewController.h"
#import "ZoneDetection.h"
#import "ReportCollectionViewCell.h"

@interface ReportViewController : ViewController<UICollectionViewDelegate,UICollectionViewDataSource,SimpleBarChartDataSource, SimpleBarChartDelegate,sharedZoneDetectionDelegate>
{
    NSString *locationName;
    //    Database *db;
    //NSDate *nextday;
    NSString *month;
    NSString *date;
    NSString *day;
    
    int btnTag;
    
    BOOL isSelectedDate;
    BOOL isSelectedTime;
    
    BOOL isCurrentWeek;
    
    int seletedTag;
    
    SimpleBarChart *_chart;
    
    NSInteger _currentBarColor;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDates;

@property (nonatomic, strong) UIColor *tempColor;

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *percentagelbl;

@property (nonatomic, assign) BOOL isStartDisCalculating;
@property (nonatomic, assign) double totalDis;
@property (nonatomic, assign) NSInteger countDis;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;
@property (weak, nonatomic) UIScrollView *sv;
@property (nonatomic, strong) UIImageView *current;
@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, strong) NSMutableArray *subjectList;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) NSDictionary *userInfoDict;
@property (nonatomic, strong) NSTimer* zoneTimer;

@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *_barColors;
@property (nonatomic, strong) NSArray *Values;
@property (nonatomic, strong) NSArray *Months;
@property (nonatomic, strong) NSArray *arrTiming;
@property (nonatomic, strong) NSMutableArray *MonthsValues;

@end
