//
//  HomeViewController.m
//  HiplaStudent
//
//  Created by FNSPL on 07/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end


@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    NSLog(@"%@",self.isStart);
    
    if ([self.isStart isEqualToString:@"true"]) {
        
        if ([self.strNotif isEqualToString:@"local"]) {
            
            NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
            
            if (dicCurrentRoutine==nil) {
                
                [Userdefaults setObject:self.userInfoDict forKey:@"userInfoDictLocal"];
                [Userdefaults setObject:@"YES" forKey:@"isStartTimerCalled"];
                [Userdefaults synchronize];
                
                [self gotoStartClass];
                
            } else {
                
                BOOL isClassRunning = [Userdefaults boolForKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
                
                if (isClassRunning==NO)
                {
                    [Userdefaults setObject:self.userInfoDict forKey:@"userInfoDictLocal"];
                    [Userdefaults setObject:@"YES" forKey:@"isStartTimerCalled"];
                    [Userdefaults synchronize];
                    
                    [self gotoStartClass];
                }
                else if (isClassRunning==YES)
                {
                    [[Common sharedCommonFetch] setCommonDelegate:self];
                    
                    [[Common sharedCommonFetch] checkRoutineStatus:[dicCurrentRoutine objectForKey:@"routine_history_id"]];
                }
                else
                {
                    NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isClassStarted"];
                    
                    if ([isStartTimerCalled isEqualToString:@"YES"])
                    {
                        [self gotoSuccessView];
                    }
                    else
                    {
                        [self gotoProfile];
                    }
                }
            }
            
        } else if ([self.strNotif isEqualToString:@"push"]){
            
            [self gotoAttendenceClass];
            
        }
        else if ([self.strNotif isEqualToString:@"push2"]){
            
            NSDictionary* dicCurrentRoutine = [Userdefaults objectForKey:@"userInfoDictLocal"];
            
            BOOL isClassRunning = [Userdefaults boolForKey:[NSString stringWithFormat:@"isClassRunning:%@",[dicCurrentRoutine objectForKey:@"routine_history_id"]]];
            
            if (isClassRunning==NO)
            {
                [self checkNextRoutine:dicCurrentRoutine];
            }
            
        }
        else if ([self.strNotif isEqualToString:@"push3"]){
            
            [self gotoSuccessView];
            
        }
        else if ([self.strNotif isEqualToString:@"push4"]){
            
            NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isStartTimerCalled"];
            
            if ([isStartTimerCalled isEqualToString:@"YES"])
            {
                [self gotoStartClass];
            }
            else
            {
                NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isSelfieTimerCalled"];
                
                if ([isStartTimerCalled isEqualToString:@"YES"])
                {
                    [self gotoAttendenceClass];
                }
                else
                {
                    NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isClassStarted"];
                    
                    if ([isStartTimerCalled isEqualToString:@"YES"])
                    {
                        [self gotoSuccessView];
                    }
                    else
                    {
                        [self gotoProfile];
                    }
                }
            }
        }
        else if ([self.strNotif isEqualToString:@"push5"]){
            
            [self gotoProfile];
        }
        else if ([self.strNotif isEqualToString:@"push6"]){
            
            [self gotoProfile];
        }
        else
        {
            [self gotoProfile];
        }
        
    } else {
    
        NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isStartTimerCalled"];
        
        if ([isStartTimerCalled isEqualToString:@"YES"])
        {
            [self gotoStartClass];
        }
        else
        {
            NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isSelfieTimerCalled"];
            
            if ([isStartTimerCalled isEqualToString:@"YES"])
            {
                [self gotoAttendenceClass];
            }
            else
            {
                NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isClassStarted"];
                
                if ([isStartTimerCalled isEqualToString:@"YES"])
                {
                    [self gotoSuccessView];
                }
                else
                {
                    [self gotoProfile];
                }
            }
        }
    }
    
}


#pragma mark - CommonDelegate
- (void)routineStatus:(NSDictionary *)dicRoutine {
    
    [[Common sharedCommonFetch] setCommonDelegate:nil];
    
    NSString *statusStr = [[dicRoutine objectForKey:@"routine_details"] objectForKey:@"status"];
    
    if (![[Utils sharedInstance] isNullString:statusStr])
    {
        if ([statusStr isEqualToString:@"ended"])
        {
            [Userdefaults setObject:self.userInfoDict forKey:@"userInfoDictLocal"];
            [Userdefaults setObject:@"YES" forKey:@"isStartTimerCalled"];
            [Userdefaults synchronize];
            
            [self gotoStartClass];
        }
        else if ([statusStr isEqualToString:@"not started"])
        {
            [self gotoStartClass];
        }
        else if ([statusStr isEqualToString:@"started"])
        {
            NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isSelfieTimerCalled"];
            
            if ([isStartTimerCalled isEqualToString:@"YES"])
            {
                [self gotoAttendenceClass];
            }
            else
            {
                NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isClassStarted"];
                
                if ([isStartTimerCalled isEqualToString:@"YES"])
                {
                    [self gotoSuccessView];
                }
                else
                {
                    [self gotoProfile];
                }
            }
        }
        
    } else {
        
        [self gotoProfile];
    }
}


-(void)gotoProfile
{
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    [self.navigationController pushViewController:profileScreen animated:YES];

    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];
    
    [menu setElDrawer:drawer];

    localNavigationController = [[UINavigationController alloc] initWithRootViewController:profileScreen];

    drawer.mainViewController = localNavigationController;

    drawer.drawerViewController = menu;

    /* Customize */
    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    drawer.drawerWidth = 5*(SCREENWIDTH/8);

    dispatch_async(dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
}


-(void)gotoStartClass
{
    StartClassViewController *startclassScreen = [[StartClassViewController alloc]initWithNibName:@"StartClassViewController" bundle:nil];
    
    NSLog(@"%@",_userInfoDict);
    
    startclassScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    startclassScreen.isStart = true;
    
    [self.navigationController pushViewController:startclassScreen animated:YES];
    
    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];
    [menu setElDrawer:drawer];

    localNavigationController = [[UINavigationController alloc] initWithRootViewController:startclassScreen];

    drawer.mainViewController = localNavigationController;

    drawer.drawerViewController = menu;

    /* Customize */
    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    drawer.drawerWidth = 5*(SCREENWIDTH/8);

    dispatch_async(dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
}


-(void)gotoAttendenceClass
{
    NSString *strPart = [[self.userInfoDict objectForKey:@"aps"] objectForKey:@"alert"];
    
    if ([strPart containsString:@"start_attendance"]) {
        
        AttendanceViewController *attendenceScreen = [[AttendanceViewController alloc]initWithNibName:@"AttendanceViewController" bundle:nil];
        
        NSLog(@"%@",_userInfoDict);
        
        attendenceScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
        
        [self.navigationController pushViewController:attendenceScreen animated:YES];
        
        menu = [[MenuTableViewController alloc] init];
        drawer = [[KYDrawerController alloc] init];
        [menu setElDrawer:drawer];
        
        localNavigationController = [[UINavigationController alloc] initWithRootViewController:attendenceScreen];
        
        drawer.mainViewController = localNavigationController;
        
        drawer.drawerViewController = menu;
        
        /* Customize */
        drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
        drawer.drawerWidth = 5*(SCREENWIDTH/8);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
        });
    }
    else if ([strPart length]==0)
    {
        NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isSelfieTimerCalled"];
        
        if ([isStartTimerCalled isEqualToString:@"YES"])
        {
            AttendanceViewController *attendenceScreen = [[AttendanceViewController alloc]initWithNibName:@"AttendanceViewController" bundle:nil];
            
            NSLog(@"%@",_userInfoDict);
            
            attendenceScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
            
            [self.navigationController pushViewController:attendenceScreen animated:YES];
            
            menu = [[MenuTableViewController alloc] init];
            drawer = [[KYDrawerController alloc] init];
            [menu setElDrawer:drawer];
            
            localNavigationController = [[UINavigationController alloc] initWithRootViewController:attendenceScreen];
            
            drawer.mainViewController = localNavigationController;
            
            drawer.drawerViewController = menu;
            
            /* Customize */
            drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
            drawer.drawerWidth = 5*(SCREENWIDTH/8);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
            });
        }
    }
    else
    {
        AttendanceViewController *attendenceScreen = [[AttendanceViewController alloc]initWithNibName:@"AttendanceViewController" bundle:nil];
        
        NSLog(@"%@",_userInfoDict);
        
        attendenceScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
        
        [self.navigationController pushViewController:attendenceScreen animated:YES];
        
        menu = [[MenuTableViewController alloc] init];
        drawer = [[KYDrawerController alloc] init];
        [menu setElDrawer:drawer];
        
        localNavigationController = [[UINavigationController alloc] initWithRootViewController:attendenceScreen];
        
        drawer.mainViewController = localNavigationController;
        
        drawer.drawerViewController = menu;
        
        /* Customize */
        drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
        drawer.drawerWidth = 5*(SCREENWIDTH/8);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
        });
    }
    
}


-(void)gotoSuccessView
{
    SuccessAttendenceViewController *successScreen = [[SuccessAttendenceViewController alloc]initWithNibName:@"SuccessAttendenceViewController" bundle:nil];
    
    successScreen.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
    
    [self.navigationController pushViewController:successScreen animated:YES];

    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];
    
    [menu setElDrawer:drawer];

    localNavigationController = [[UINavigationController alloc] initWithRootViewController:successScreen];

    drawer.mainViewController = localNavigationController;

    drawer.drawerViewController = menu;

    /* Customize */
    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    drawer.drawerWidth = 5*(SCREENWIDTH/8);

    dispatch_async(dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
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
                        
                        NSString *routineHistoryId = [NSString stringWithFormat:@"%d",(int)[[[RoutineArr lastObject] objectForKey:@"routine_history_id"] integerValue]];
                        
                        if (![routineId isEqualToString:routineHistoryId])
                        {
                          
//                        if ((i+2) < [RoutineArr count])
//                        {
                            NSDictionary *dictRoutine2 = [RoutineArr objectAtIndex:i+1];
                            
                            self.dateFormatter=[[NSDateFormatter alloc] init];
                            
                            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

                            NSString *strDate = [self.dateFormatter stringFromDate:[NSDate date]];
                            
                            [self.dateFormatter setDateFormat:@"hh:mm a"];
                            
                            NSString *strTime = [dictRoutine2 objectForKey:@"startTime"];
                            
                            NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                            
//                            [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                            
//                            NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                            NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                            
                            //NSComparisonResult compare = [[NSDate date] compare:StartDateTime];
                            
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


-(void)getCurrentRoutine:(NSString *)timeStr
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&usertype=student&time=%@",userId,timeStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"routine_details_by_time.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                NSDictionary *dict2 = [[dict objectForKey:@"user_routine"] objectAtIndex:0];
                
                NSArray *arrRoutine = [dict2 objectForKey:@"routine"];
                
                NSDictionary *UserInfoDict = [arrRoutine objectAtIndex:0];
                
                if (UserInfoDict!=nil) {
                    
                    NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isStartTimerCalled"];
                    
                    if ([isStartTimerCalled isEqualToString:@"YES"])
                    {
                        [self gotoStartClass];
                    }
                    else
                    {
                        NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isSelfieTimerCalled"];
                        
                        if ([isStartTimerCalled isEqualToString:@"YES"])
                        {
                            [self gotoAttendenceClass];
                        }
                        else
                        {
                            NSString *isStartTimerCalled = [Userdefaults objectForKey:@"isClassStarted"];
                            
                            if ([isStartTimerCalled isEqualToString:@"YES"])
                            {
                                [self gotoSuccessView];
                            }
                            else
                            {
                                [self gotoProfile];
                            }
                        }
                    }
                    
                }
                else
                {
                    [self gotoProfile];
                }
                
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
                [SVProgressHUD dismiss];
                
            }
            
        } else {
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Error: %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with your internet, please try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
            });
            
        }
        
    }];
    
}


-(void)cancelNotification
{
    NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
    
    NSDictionary *userInfoDictLocal = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    if ([routineArr count]>0) {
        
        for (NSDictionary *routineDict in routineArr) {
            
            NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[userInfoDictLocal objectForKey:@"routine_history_id"] integerValue]];
            
            NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
            
            if (![routineId isEqualToString:routine_history_id]) {
                
                [self removeNotificationwithdetail:routineDict];
                
            }
            
        }
        
    }
    
}


-(void)removeNotificationwithdetail:(NSDictionary *)dict
{
    UILocalNotification *notificationToCancel=nil;
    
    for(UILocalNotification *notif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        NSString *routine_history_id = [dict objectForKey:@"routine_history_id"];
        
        if([[notif.userInfo objectForKey:@"routine_history_id"] isEqualToString:routine_history_id]) {
            
            notificationToCancel = notif;
            
            return;
        }
    }
    
    if(notificationToCancel)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
