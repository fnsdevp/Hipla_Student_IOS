//
//  AppDelegate.h
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Common.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "KYDrawerController.h"
#import "MenuTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CrashlyticsDelegate, CommonDelegate>
{
    NSString *isLoggedIn;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSFileManager *filemgr;
@property (nonatomic, strong) NSString *NewDir;
@property (nonatomic, strong) NSArray *dirPaths;
@property (nonatomic, strong) NSString *docsDir;

@property (nonatomic, strong) NSMutableArray *userRoutineInfo;
@property (nonatomic, strong) NSMutableArray *routineArr;
@property (nonatomic, strong) NSString *currentDateStr;
@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) LoginViewController *loginVc;
@property (nonatomic, strong) HomeViewController *homeVc;
@property (nonatomic, strong) KYDrawerController *drawer;
@property (nonatomic, strong) MenuTableViewController *menu;
@property (nonatomic, strong) UINavigationController *nav;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

