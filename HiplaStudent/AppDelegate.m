//
//  AppDelegate.m
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [self registerForRemoteNotifications:application];
    
    [Fabric with:@[[Crashlytics class]]];
    
    CrashlyticsKit.delegate = self;
    
    [Userdefaults registerDefaults:@{ @"NSApplicationCrashOnExceptions": @YES }];
    
    [Userdefaults setBool:NO forKey:@"restrictedZone"];
    
    [Userdefaults synchronize];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        // iOS 10 or later
#if defined(__IPHONE_10_0) && _IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        
        if (@available(iOS 10.0, *)) {
            
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            
        } else {
            
            // Fallback on earlier versions
            
        }
        
        if (@available(iOS 10.0, *)) {
            
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                
                
            }];
            
        } else {
            
            // Fallback on earlier versions
        }
        
#endif
    }
    
    
    // opened from a push notification when the app is closed
    NSDictionary* userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil)
    {
        NSLog(@"userInfo->%@", [userInfo objectForKey:@"aps"]);
    }
    
    NSDictionary* userInfo2 = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (userInfo2 != nil)
    {
        NSLog(@"userInfo2->%@", [userInfo2 objectForKey:@"aps"]);
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    //self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    if([isLoggedIn isEqualToString:@"YES"]){
        
//        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
//
//        if (dicCurrentRoutine !=nil)
//        {
//            [[Common sharedCommonFetch] setCommonDelegate:self];
//
//            [[Common sharedCommonFetch] checkRoutineStatus:[dicCurrentRoutine objectForKey:@"routine_history_id"]];
//        }
//        else
//        {
//            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
//
//            self.currentDate = [NSDate date];
//
//            [self.dateFormatter setDateFormat:@"hh:mm a"];
//
//            NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
//
//            [[Common sharedCommonFetch] setCommonDelegate:self];
//
//            [[Common sharedCommonFetch] getCurrentRoutine:outTime];
//
//            homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//
//            menu = [[MenuTableViewController alloc] init];
//            drawer = [[KYDrawerController alloc] init];
//
//            [menu setElDrawer:drawer];
//
//            nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
//
//            drawer.mainViewController = nav;
//
//            drawer.drawerViewController = menu;
//
//            drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
//            drawer.drawerWidth = 5*(SCREENWIDTH/8);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                self.window.rootViewController = drawer;
//                [self.window makeKeyAndVisible];
//
//            });
//
//        }
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.currentDate = [NSDate date];
        
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
        
        [[Common sharedCommonFetch] setCommonDelegate:self];
        
        [[Common sharedCommonFetch] getCurrentRoutine:outTime];
        
        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        _menu = [[MenuTableViewController alloc] init];
        _drawer = [[KYDrawerController alloc] init];
        
        [_menu setElDrawer:_drawer];
        
        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
        
        _drawer.mainViewController = _nav;
        
        _drawer.drawerViewController = _menu;
        
        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.window) {
                
                self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                
                self.window.rootViewController = _drawer;
                
            } else {
                
                self.window.rootViewController = _drawer;
                
            }
            
            [self.window makeKeyAndVisible];
            
//            self.window.rootViewController = _drawer;
//            [self.window makeKeyAndVisible];
            
        });
        
    }
    else
    {
        _loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        _nav = [[UINavigationController alloc]initWithRootViewController:_loginVc];
        
        self.window.rootViewController = _nav;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    if([isLoggedIn isEqualToString:@"YES"]){
        
        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
        
        if (dicCurrentRoutine !=nil)
        {
            [[Common sharedCommonFetch] setCommonDelegate:self];
            
            [[Common sharedCommonFetch] checkRoutineStatus:[dicCurrentRoutine objectForKey:@"routine_history_id"]];
            
        }
        else
        {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            self.currentDate = [NSDate date];
            
            [self.dateFormatter setDateFormat:@"hh:mm a"];
            
            NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
            
            [[Common sharedCommonFetch] setCommonDelegate:self];
            
            [[Common sharedCommonFetch] getCurrentRoutine:outTime];
        }
        
    }
}


#pragma mark - CommonDelegate

- (void)currentRoutineStatus:(NSDictionary *)dicRoutine
{
    NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    if (dicCurrentRoutine!=nil)
    {
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *strDate = [self.dateFormatter stringFromDate:self.currentDate];
        
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *strTime = [dicCurrentRoutine objectForKey:@"endTime"];
        
        NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
        
        NSComparisonResult compare = [self.currentDate compare:StartDateTime];
        
        if (compare==NSOrderedAscending) {
            
            [[Common sharedCommonFetch] setCommonDelegate:self];
            
            [[Common sharedCommonFetch] checkRoutineStatus:[dicRoutine objectForKey:@"routine_history_id"]];
        }
        else
        {
            if (dicRoutine==nil)
            {
                [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                
                [Userdefaults synchronize];
                
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
                
                [[Common sharedCommonFetch] RoutineWithDetails:self.currentDateStr];
                
                _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                
                _menu = [[MenuTableViewController alloc] init];
                _drawer = [[KYDrawerController alloc] init];
                
                [_menu setElDrawer:_drawer];
                
                _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                
                _drawer.mainViewController = _nav;
                
                _drawer.drawerViewController = _menu;
                
                _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (!self.window) {
                        
                        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                        
                        self.window.rootViewController = _drawer;
                        
                    } else {
                        
                        self.window.rootViewController = _drawer;
                        
                    }
                    
                    [self.window makeKeyAndVisible];
                    
                    
//                    self.window.rootViewController = _drawer;
//                    [self.window makeKeyAndVisible];
                    
                    
                });
            }
            else
            {
                [[Common sharedCommonFetch] setCommonDelegate:self];
                
                [[Common sharedCommonFetch] checkRoutineStatus:[dicRoutine objectForKey:@"routine_history_id"]];
            }
        }
        
    } else {
        
        if (dicRoutine==nil)
        {
            [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
            
            [Userdefaults synchronize];
            
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
            
            [[Common sharedCommonFetch] RoutineWithDetails:self.currentDateStr];
            
            _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
            _menu = [[MenuTableViewController alloc] init];
            _drawer = [[KYDrawerController alloc] init];
            
            [_menu setElDrawer:_drawer];
            
            _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
            
            _drawer.mainViewController = _nav;
            
            _drawer.drawerViewController = _menu;
            
            _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
            _drawer.drawerWidth = 5*(SCREENWIDTH/8);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.window) {
                    
                    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                    
                    self.window.rootViewController = _drawer;
                    
                } else {
                    
                    self.window.rootViewController = _drawer;
                    
                }
                
                [self.window makeKeyAndVisible];
                
//                self.window.rootViewController = _drawer;
//                [self.window makeKeyAndVisible];
                
                
            });
        }
        else
        {
            [[Common sharedCommonFetch] setCommonDelegate:self];
            
            [[Common sharedCommonFetch] checkRoutineStatus:[dicRoutine objectForKey:@"routine_history_id"]];
        }
    }
}


- (void)routineStatus:(NSDictionary *)dicRoutine {
    
    [[Common sharedCommonFetch] setCommonDelegate:nil];
    
    NSString *statusStr = [[dicRoutine objectForKey:@"routine_details"] objectForKey:@"status"];
    
    if (![[Utils sharedInstance] isNullString:statusStr])
    {
        if ([statusStr isEqualToString:@"not started"])
        {
            
            NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
            
            BOOL isClassRunning = [Userdefaults boolForKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
            
            if (isClassRunning==NO)
            {
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSString *strDate = [self.dateFormatter stringFromDate:self.currentDate];
                
                [self.dateFormatter setDateFormat:@"hh:mm a"];
                
                NSString *strTime = [dicCurrentRoutine objectForKey:@"endTime"];
                
                NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                
                NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                
                NSComparisonResult compare = [self.currentDate compare:StartDateTime];
                
                if (compare==NSOrderedAscending) {
                    
                    NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isStartTimerCalled"];
                    
                    if ([isStartTimerCalled isEqualToString:@"YES"])
                    {
                        [self gotoStartClass];
                    }
                    else
                    {
                        [self gotoProfile];
                    }
                    
                }
                else
                {
                    [self checkNextRoutine:dicCurrentRoutine];
                }
            }
            
        }
        else if ([statusStr isEqualToString:@"started"])
        {
            
            NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
            
            NSString *routinehistoryidStr = [dicCurrentRoutine objectForKey:@"routine_history_id"];
            
            [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
            
            [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
            
            [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
            
            [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
            
            
            NSString *isClassStarted = [Userdefaults objectForKey:@"isClassStarted"];
            
            if ([isClassStarted isEqualToString:@"YES"])
            {
                [Userdefaults setObject:@"YES" forKey:@"isClassStarted"];
                
                [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                
                
                
            }
            else if ([isClassStarted isEqualToString:@"NO"])
            {
                NSString *isMarkedAbsent = [Userdefaults objectForKey:@"isMarkedAbsent"];
                
                if ([isMarkedAbsent isEqualToString:@"NO"])
                {
                    [Userdefaults setObject:@"YES" forKey:@"isSelfieTimerCalled"];
                    
                    [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                }
                else if ([isMarkedAbsent length]==0)
                {
                    [Userdefaults setObject:@"YES" forKey:@"isSelfieTimerCalled"];
                    
                    [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                }
            }
            else if ([isClassStarted length]==0)
            {
                [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                
                [Userdefaults setObject:@"YES" forKey:@"isSelfieTimerCalled"];
            }
            
            
            [Userdefaults synchronize];
            
            
            _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
            _homeVc.userInfoDict = dicCurrentRoutine;
            
            _menu = [[MenuTableViewController alloc] init];
            _drawer = [[KYDrawerController alloc] init];
            
            [_menu setElDrawer:_drawer];
            
            _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
            
            _drawer.mainViewController = _nav;
            
            _drawer.drawerViewController = _menu;
            
            _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
            _drawer.drawerWidth = 5*(SCREENWIDTH/8);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.window) {
                    
                    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                    
                    self.window.rootViewController = _drawer;
                    
                } else {
                    
                    self.window.rootViewController = _drawer;
                    
                }
                
                [self.window makeKeyAndVisible];
                
               // self.window.rootViewController = _drawer;
                
            });
            
        }
        else if ([statusStr isEqualToString:@"ended"])
        {
            
            NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
            
            NSString *routinehistoryidStr = [dicCurrentRoutine objectForKey:@"routine_history_id"];
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
            
            [Userdefaults setBool:YES forKey:@"isRoutineEnd"];
            
            
            [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
            
            [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
            
            [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
            
            [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
            
            [Userdefaults removeObjectForKey:@"SneakOutFired"];
            
            [Userdefaults synchronize];
            
            
            [self checkNextRoutine:dicCurrentRoutine];
            
            
            [[Common sharedCommonFetch] setCommonDelegate:self];
            
            [[Common sharedCommonFetch] checkRoutineStatus:[dicCurrentRoutine objectForKey:@"routine_history_id"]];
            
        }
    }
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
    
    [[Common sharedCommonFetch] RoutineWithDetails:self.currentDateStr];
    
}


-(void)checkNextRoutine:(NSDictionary *)Dict
{
    NSString *strJson = [[Common sharedCommonFetch] readStringFromFile];
    
    if ([strJson length]>0)
    {
        NSDictionary *dict = [[Common sharedCommonFetch] JSONFromFile];
        
        if ([[dict allKeys] containsObject:@"routine"])
        {
            NSMutableArray *RoutineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
            
            if ([RoutineArr count]>0) {
                
                for (int i=0; i<[RoutineArr count]; i++)
                {
                    NSDictionary *dictRoutine = [RoutineArr objectAtIndex:i];
                    
                    NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[Dict objectForKey:@"routine_history_id"] integerValue]];
                    
                    NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[dictRoutine objectForKey:@"routine_history_id"] integerValue]];
                    
                    if ([routineId isEqualToString:routine_history_id]) {
                        
                        if ((i+1) < [RoutineArr count])
                        {
                            NSDictionary *dictRoutine2 = [RoutineArr objectAtIndex:i+1];
                            
                            self.dateFormatter=[[NSDateFormatter alloc] init];
                            
                            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            
                            NSString *strDate = [self.dateFormatter stringFromDate:[NSDate date]];
                            
                            [self.dateFormatter setDateFormat:@"hh:mm a"];
                            
                            NSString *strTime = [dictRoutine2 objectForKey:@"startTime"];
                            
                            NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                            
                            NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                            
                            NSComparisonResult compare = [StartDateTime compare:[NSDate date]];
                            
                            if (compare==NSOrderedDescending)
                            {
                                [Userdefaults setObject:dictRoutine2 forKey:@"userInfoDictLocal"];
                                
                                [Userdefaults setObject:@"YES" forKey:@"isStartTimerCalled"];
                                
                                [Userdefaults synchronize];
                                
                                [self gotoStartClass];
                                
                            }
                            else if (compare==NSOrderedSame)
                            {
                                [Userdefaults setObject:dictRoutine2 forKey:@"userInfoDictLocal"];
                                
                                [Userdefaults setObject:@"YES" forKey:@"isStartTimerCalled"];
                                
                                [Userdefaults synchronize];
                                
                                [self gotoStartClass];
                                
                            }
                            else
                            {
                                [Userdefaults removeObjectForKey:@"userInfoDictLocal"];
                                
                                [Userdefaults synchronize];
                                
                                [self gotoProfile];
                            }
                            
                        }
                        else
                        {
                            [Userdefaults removeObjectForKey:@"userInfo"];
                            
                            [Userdefaults removeObjectForKey:@"userInfoDictLocal"];
                            
                            [Userdefaults synchronize];
                            
                            [self gotoProfile];
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
}

-(void)gotoProfile
{
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    [_nav pushViewController:profileScreen animated:YES];
    
    _menu = [[MenuTableViewController alloc] init];
    _drawer = [[KYDrawerController alloc] init];
    [_menu setElDrawer:_drawer];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:profileScreen];
    
    _drawer.mainViewController = _nav;
    
    _drawer.drawerViewController = _menu;
    
    /* Customize */
    _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    _drawer.drawerWidth = 5*(SCREENWIDTH/8);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = _drawer;
    });
    
}

-(void)gotoStartClass
{
    StartClassViewController *startclassScreen = [[StartClassViewController alloc]initWithNibName:@"StartClassViewController" bundle:nil];
    
    startclassScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    startclassScreen.isStart = true;
    
    [_nav pushViewController:startclassScreen animated:YES];
    
    _menu = [[MenuTableViewController alloc] init];
    _drawer = [[KYDrawerController alloc] init];
    [_menu setElDrawer:_drawer];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:startclassScreen];
    
    _drawer.mainViewController = _nav;
    
    _drawer.drawerViewController = _menu;
    
    /* Customize */
    _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    _drawer.drawerWidth = 5*(SCREENWIDTH/8);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = _drawer;
    });
    
}

-(void)gotoSuccessView
{
    SuccessAttendenceViewController *successScreen = [[SuccessAttendenceViewController alloc]initWithNibName:@"SuccessAttendenceViewController" bundle:nil];
    
    successScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
    
    [_nav pushViewController:successScreen animated:YES];
    
    _menu = [[MenuTableViewController alloc] init];
    _drawer = [[KYDrawerController alloc] init];
    
    [_menu setElDrawer:_drawer];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:successScreen];
    
    _drawer.mainViewController = _nav;
    
    _drawer.drawerViewController = _menu;
    
    /* Customize */
    _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    _drawer.drawerWidth = 5*(SCREENWIDTH/8);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = _drawer;
    });
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
}


// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Object = %@", notification);
    
  /*  UIApplicationState appState = UIApplicationStateActive;
    
    if ([application respondsToSelector:@selector(applicationState)])
        appState = application.applicationState;
    
    if (appState == UIApplicationStateActive)
    {
        NSDictionary* userInfo = [notification userInfo];
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
            _homeVc.userInfoDict = userInfo;
            
            _nav = [[UINavigationController alloc]initWithRootViewController:_homeVc];
        }
        
        self.window.rootViewController = _nav;
        [self.window makeKeyAndVisible];
    }
   */
    
    NSLog(@"didReceiveLocalNotification");
}
    
    
-(void)localNotif
{
    if (@available(iOS 10.0, *)) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound;
        
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted) {
                                      
                                      NSLog(@"Something went wrong");
                                  }
                              }];
        
    } else {
        // Fallback on earlier versions
    }
    
}
    
- (void)registerForRemoteNotifications:(UIApplication *)application
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0")){
            
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
        center.delegate = self;
            
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    
                    if(!error){
                        
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                });
                
        }];
            
    }
    else {
            
        // Code for old versions
    }
}
    
    
  //Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    NSLog(@"notification body : %@",notification.request.content.body);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = notification.request.content.userInfo;
        
        NSString *strMsg = notification.request.content.body;
        
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
            
            if ([routineArr count]>0) {
                
                if ([[userInfo allKeys] containsObject:@"aps"]) {
                    
                    NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                    
                    if ([status containsString:@"Click here to give your attendance"]) {
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push";
                        
                        NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                        
                        if ([routineArr count]>0) {
                            
                            for (NSDictionary *routineDict in routineArr) {
                                
                                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                                
                                NSArray *statusArr = [status componentsSeparatedByString:@" "];
                                
                                NSString *routineId = [statusArr objectAtIndex:0];
                                
                                NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                if ([routineId isEqualToString:routine_history_id]) {
                                    
                                    NSString *routinehistoryidStr = [routineDict objectForKey:@"routine_history_id"];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        }
                        
                        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
                        
                        [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                        
                        [Userdefaults setObject:@"YES" forKey:@"isSelfieTimerCalled"];
                        
                        
                        // [Userdefaults setObject:userInfo forKey:@"userInfo"];
                        
                        
                        [Userdefaults synchronize];
                        
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    } else if ([status containsString:@"Class completed"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        //  homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push2";
                        
                        NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                        
                        if ([routineArr count]>0) {
                            
                            for (NSDictionary *routineDict in routineArr) {
                                
                                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                                
                                NSArray *statusArr = [status componentsSeparatedByString:@" "];
                                
                                NSString *routineId = [statusArr objectAtIndex:0];
                                
                                NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                if ([routineId isEqualToString:routine_history_id]) {
                                    
                                    NSString *routinehistoryidStr = [routineDict objectForKey:@"routine_history_id"];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:@"isRoutineEnd"];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        }
                        
                        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
                        
                        [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
                        
                        
                        // [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        // [Userdefaults removeObjectForKey:@"userInfoDictLocal"];
                        
                        
                        [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isMarkedAbsent"];
                        
                        [Userdefaults removeObjectForKey:@"SneakOutFired"];
                        
                        [Userdefaults synchronize];
                        
                        
                        //                        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        //
                        //                        self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
                        //
                        //                        [[Common sharedCommonFetch] checkRoutine:self.currentDateStr];
                        
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"you have successfully mark your attendance"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push3";
                        
                        [Userdefaults setObject:@"YES" forKey:@"isClassStarted"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"your routine has been updated"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push4";
                        
                        // [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setBool:YES forKey:@"routineUpdated"];
                        
                        [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"user has been updated"])
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push5";
                        
                        
                        // [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setBool:YES forKey:@"userUpdated"];
                        
                        [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"has marked you absent"])
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push6";
                        
                        [Userdefaults setObject:@"YES" forKey:@"isMarkedAbsent"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                    }
                    else
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push7";
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    
                } else {
                    
                    _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                    
                    _homeVc.userInfoDict = userInfo;
                    
                    _homeVc.msgBody = strMsg;
                    
                    _homeVc.isStart = @"true";
                    
                    _homeVc.strNotif = @"local";
                    
                    _menu = [[MenuTableViewController alloc] init];
                    _drawer = [[KYDrawerController alloc] init];
                    
                    [_menu setElDrawer:_drawer];
                    
                    _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                    
                    _drawer.mainViewController = _nav;
                    
                    _drawer.drawerViewController = _menu;
                    
                    _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                    _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.window.rootViewController = _drawer;
                        
                    });
                    
                }
                
            }
            else
            {
                _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                
                _menu = [[MenuTableViewController alloc] init];
                _drawer = [[KYDrawerController alloc] init];
                
                [_menu setElDrawer:_drawer];
                
                _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                
                _drawer.mainViewController = _nav;
                
                _drawer.drawerViewController = _menu;
                
                _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.window.rootViewController = _drawer;
                    
                });
            }
            
            self.window.rootViewController = _nav;
            [self.window makeKeyAndVisible];
            
        }
        
    }
    
    if (@available(iOS 10.0, *)) {
        
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        
    } else {
        
        // Fallback on earlier versions
        
    }
    
}
    
    
    //Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    /*NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    NSLog(@"notification body : %@",response.notification.request.content.body);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //user has been updated
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = response.notification.request.content.userInfo;
        
        NSString *strMsg = response.notification.request.content.body;
        
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
            
            if ([routineArr count]>0) {
                
                if ([[userInfo allKeys] containsObject:@"aps"]) {
                    
                    NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                    
                    if ([status containsString:@"Click here to give your attendance"]) {
                        
                        if (!_homeVc) {
                         
                            _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                            
                        }
                        _homeVc.userInfoDict = userInfo;
                        _homeVc.msgBody = strMsg;
                        _homeVc.isStart = @"true";
                        _homeVc.strNotif = @"push";
                        
                        NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                        
                        if ([routineArr count]>0) {
                            
                            for (NSDictionary *routineDict in routineArr) {
                                
                                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                                
                                NSArray *statusArr = [status componentsSeparatedByString:@" "];
                                
                                NSString *routineId = [statusArr objectAtIndex:0];
                                
                                NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                if ([routineId isEqualToString:routine_history_id]) {
                                    
                                    NSString *routinehistoryidStr = [routineDict objectForKey:@"routine_history_id"];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        }
                        
                        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
                        
                        [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                        
                        [Userdefaults setObject:@"YES" forKey:@"isSelfieTimerCalled"];
                        
                        
                        // [Userdefaults setObject:userInfo forKey:@"userInfo"];
                        
                        
                        [Userdefaults synchronize];
                        
                        if (!_menu) {
                        
                            _menu = [[MenuTableViewController alloc] init];
                            
                        } else {
                            
                        }
                        
                        if (!_drawer) {
                        
                            _drawer = [[KYDrawerController alloc] init];
                            
                        } else {
                            
                        }

                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (!self.window) {
                                
                                self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                                self.window.rootViewController = _drawer;
                                
                            } else {
                                
                                self.window.rootViewController = _drawer;
                                
                            }
                            [self.window makeKeyAndVisible];
                            
                            
                        });
                        
                    } else if ([status containsString:@"Class completed"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        //  homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push2";
                        
                        NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                        
                        if ([routineArr count]>0) {
                            
                            for (NSDictionary *routineDict in routineArr) {
                                
                                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                                
                                NSArray *statusArr = [status componentsSeparatedByString:@" "];
                                
                                NSString *routineId = [statusArr objectAtIndex:0];
                                
                                NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                if ([routineId isEqualToString:routine_history_id]) {
                                    
                                    NSString *routinehistoryidStr = [routineDict objectForKey:@"routine_history_id"];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartSuccess:%@",routinehistoryidStr]];
                                    
                                    [Userdefaults setBool:YES forKey:@"isRoutineEnd"];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        }
                        
                        NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
                        
                        [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
                        
                        
                        // [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        // [Userdefaults removeObjectForKey:@"userInfoDictLocal"];
                        
                        
                        [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isMarkedAbsent"];
                        
                        [Userdefaults removeObjectForKey:@"SneakOutFired"];
                        
                        [Userdefaults synchronize];
                        
                        
                        //                        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        //
                        //                        self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
                        //
                        //                        [[Common sharedCommonFetch] checkRoutine:self.currentDateStr];
                        
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"you have successfully mark your attendance"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push3";
                        
                        [Userdefaults setObject:@"YES" forKey:@"isClassStarted"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"your routine has been updated"]){
                        
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push4";
                        
                        // [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setBool:YES forKey:@"routineUpdated"];
                        
                        [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                        
                    }
                    else if ([status containsString:@"user has been updated"])
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push5";
                        
                        
                        // [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults setBool:YES forKey:@"userUpdated"];
                        
                        [Userdefaults removeObjectForKey:@"userInfo"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                    }
                    else if ([status containsString:@"has marked you absent"])
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push6";
                        
                        [Userdefaults setBool:YES forKey:@"isMarkedAbsent"];
                        
                        [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                        
                        [Userdefaults synchronize];
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.window.rootViewController = _drawer;
                            
                        });
                    }
                    else
                    {
                        _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        
                        _homeVc.userInfoDict = userInfo;
                        
                        _homeVc.msgBody = strMsg;
                        
                        _homeVc.isStart = @"true";
                        
                        _homeVc.strNotif = @"push7";
                        
                        _menu = [[MenuTableViewController alloc] init];
                        _drawer = [[KYDrawerController alloc] init];
                        
                        [_menu setElDrawer:_drawer];
                        
                        _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                        
                        _drawer.mainViewController = _nav;
                        
                        _drawer.drawerViewController = _menu;
                        
                        _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                        _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                    
                            self.window.rootViewController = _drawer;

                        });
                        
                    }
                    
                } else {
                    
                    _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                    
                    _homeVc.userInfoDict = userInfo;
                    
                    _homeVc.msgBody = strMsg;
                    
                    _homeVc.isStart = @"true";
                    
                    _homeVc.strNotif = @"local";
                    
                    _menu = [[MenuTableViewController alloc] init];
                    _drawer = [[KYDrawerController alloc] init];
                    
                    [_menu setElDrawer:_drawer];
                    
                    _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                    
                    _drawer.mainViewController = _nav;
                    
                    _drawer.drawerViewController = _menu;
                    
                    _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                    _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.window.rootViewController = _drawer;
                        
                    });
                    
                }
                
            }
            else
            {
                _homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                
                _menu = [[MenuTableViewController alloc] init];
                _drawer = [[KYDrawerController alloc] init];
                
                [_menu setElDrawer:_drawer];
                
                _nav = [[UINavigationController alloc] initWithRootViewController:_homeVc];
                
                _drawer.mainViewController = _nav;
                
                _drawer.drawerViewController = _menu;
                
                _drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                _drawer.drawerWidth = 5*(SCREENWIDTH/8);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.window.rootViewController = _drawer;
                    
                });
            }
            
            self.window.rootViewController = _nav;
            [self.window makeKeyAndVisible];
            
        }
        
    }
    
    if (@available(iOS 10.0, *)) {
        
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        
    } else {
        
        // Fallback on earlier versions
        
    }*/
}
    
    
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}
    
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // NSLog(@"deviceToken: %@", deviceToken);
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSLog(@"token: %@", token);
    
    // [self sendEmailwithBody:token];
    
    [Utils setDeviceToken:token];
}
    
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}
    
    
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
        
    application.applicationIconBadgeNumber = 0;
        
    if (application.applicationState == UIApplicationStateActive)
    {
            
    }
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HiplaStudent"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
