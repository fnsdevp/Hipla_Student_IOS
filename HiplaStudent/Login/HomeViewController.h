//
//  HomeViewController.h
//  HiplaStudent
//
//  Created by FNSPL on 07/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ViewController.h"
#import "ProfileViewController.h"
#import "StartClassViewController.h"
#import "AttendanceViewController.h"
#import "SuccessAttendenceViewController.h"

@class ViewController;

@interface HomeViewController : ViewController<KYDrawerControllerDelegate,CommonDelegate>

@property (strong, nonatomic) NSDictionary *userInfoDict;
@property (strong, nonatomic) NSString *msgBody;
@property (strong, nonatomic) NSString *strNotif;
@property (strong, nonatomic) NSString *isStart;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
