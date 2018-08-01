////
////  NavigationViewController.h
////  HiplaStudent
////
////  Created by FNSPL on 16/01/18.
////  Copyright © 2018 fnspl3. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "ViewController.h"
//#import "ZoneDetection.h"
//#import "SVProgressHUD.h"
//#import "MapPin.h"
//#import "KxMenu.h"
//#import "APIManager.h"
//#import "KYDrawerController.h"
//#import "MenuTableViewController.h"
//#import <CoreLocation/CoreLocation.h>
//#import <CoreBluetooth/CoreBluetooth.h>
//
//@class MenuTableViewController;
//
//#define kColorFromHex(color)[UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0]
//
//@interface NavigationViewController : UIViewController<UIScrollViewDelegate,NavigineCoreDelegate,sharedZoneDetectionDelegate>
//{
//    int indexId;
//    NSMutableArray *arrNames;
//    NSMutableArray *arrPointx;
//    NSMutableArray *arrPointy;
//    
//    KYDrawerController *drawer;
//    UINavigationController *localNavigationController;
//    MenuTableViewController *menu;
//    APIManager *api;
//    
//    UIBezierPath   *uipath;
//    CAShapeLayer   *routeLayer;
//    NSDictionary *userInfo;
//    NSString *userId;
//}
//@property (nonatomic, strong) NavigineCore *navigineCore;
//@property (nonatomic, strong) NSString *currentZoneName;
//@property (nonatomic, strong) NSArray *zoneArray;
//@property (nonatomic, strong) UIImageView *current;
//@property (nonatomic, strong) MapPin *pressedPin;
//@property (nonatomic, assign) BOOL isRouting;
//@property (nonatomic, strong) NSString *className;
//
//@property (weak, nonatomic) IBOutlet UIScrollView *sv;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//
//@end
