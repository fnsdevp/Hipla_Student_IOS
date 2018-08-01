//
//  ViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPin.h"
#import "Navigine/NavigineSDK.h"
#import "Common.h"
#import "APIManager.h"
#import "SimpleBarChart.h"
#import "KYDrawerController.h"
#import "MenuTableViewController.h"
#import "RoutineCollectionViewCell.h"
#import "NavigationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<KYDrawerControllerDelegate,SimpleBarChartDataSource, SimpleBarChartDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,NavigineCoreDelegate>{
    
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
    APIManager *api;
    
    UIBezierPath   *uipath;
    CAShapeLayer   *routeLayer;
    NSDictionary *userInfo;
    NSString *userId;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

