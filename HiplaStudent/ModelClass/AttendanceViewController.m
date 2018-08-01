//
//  AttendanceViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 23/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "AttendanceViewController.h"

@interface AttendanceViewController ()

@end


@implementation AttendanceViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    _viewYes.layer.cornerRadius = 5.0f;
    _viewYes.clipsToBounds = YES;
    
    //    _viewNo.layer.borderColor=[[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0] CGColor];
    
    _viewNo.layer.cornerRadius = 5.0f;
    _viewNo.clipsToBounds = YES;
    
    [self.viewYes setBackgroundColor:[UIColor grayColor]];
    
    self.btnYes.enabled = NO;
    
    /*
    
    if (!_navigineCore)
    {
        _navigineCore = [[NavigineCore alloc] initWithUserHash: @"C213-85E7-2265-3F4B"
                                                        server: @"https://api.navigine.com"];
        
        _navigineCore.delegate = self;
        
        [_navigineCore downloadLocationByName:@"cxc"
                                  forceReload:NO
                                 processBlock:^(NSInteger loadProcess) {
                                     NSLog(@"%zd",loadProcess);
                                 } successBlock:^(NSDictionary *userInfo) {
                                     [_navigineCore startNavigine];
                                     [_navigineCore startPushManager];
                                 } failBlock:^(NSError *error) {
                                     NSLog(@"%@",error);
                                 }];
        
       // [[ZoneDetection sharedZoneDetection] setDelegate:self];
        
    }
    */
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    //NSLog(@"%@",self.userInfoDict);
    
    second = -1;
    minute = -1;
    
    _lblTime.text = @"";
    
    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
   
    if (self.userInfoDict!=nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
            
            if ([routineArr count]>0) {
                
                int class = 0;
                
                for (NSDictionary *routineDict in routineArr) {
                    
                    NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[self.userInfoDict objectForKey:@"routine_history_id"] integerValue]];
                    
                    NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                    
                    class ++;
                    
                    if ([routineId isEqualToString:routine_history_id]) {
                        
                        _lblclassSection.text = [NSString stringWithFormat:@"%@-%@",[routineDict objectForKey:@"classname"],[routineDict objectForKey:@"section_name"]];
                        
                        _lblTeacherName.text = [NSString stringWithFormat:@"%@",[[routineDict objectForKey:@"teacher_details"] objectForKey:@"name"]];
                        
                        _lblLecture.text = [NSString stringWithFormat:@"%d",class];
                        
                        _lblSubjectName.text = [NSString stringWithFormat:@"%@",[routineDict objectForKey:@"subject_name"]];
                        
                        startTime = [NSString stringWithFormat:@"%@",[routineDict objectForKey:@"startTime"]];
                        
                        routinehistoryidStr = [self.userInfoDict objectForKey:@"routine_history_id"];
                        
                        [self showTimer:startTime];
                        
                    }
                    
                }
                
            }
            
        });
        
    }
    else
    {
        self.dateFormatter=[[NSDateFormatter alloc] init];
        
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *currentTimeStr = [self.dateFormatter stringFromDate:[NSDate date]];
        
        [self getCurrentRoutine:currentTimeStr];
        
    }
    
    
//    NSDate* currentDate = [NSDate date];
//
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"hh:mm a"];
//
//    NSString *outTime = [dateFormatter stringFromDate:currentDate];
//
//    [self getCurrentRoutine:outTime];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//
//    _navigineCore = nil;
//
//    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
//}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}

- (void)navigationTicker {
    
    [self updateTimer];
    
    [self navigationTick:nil];
}

- (IBAction)btnBack:(id)sender {
    
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
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
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

-(void)showTimer:(NSString *)strStartTime
{
    // startTimerAT = nil;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *strTime = strStartTime;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
    
    NSDate *timerDate = [dateFormatter dateFromString:fireDateime];
    
    NSDate *SetAlarmAt = [timerDate dateByAddingTimeInterval:(5*60)];
    
    NSTimeInterval time = [SetAlarmAt timeIntervalSinceDate:[NSDate date]];
    
    [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
    
    [Userdefaults synchronize];
    
    // float timeLeft = (5.0 + (time/60));
    //
    // NSString * str = [NSString stringWithFormat:@"%.2f",finalTime];
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",time];
    
    minutesLeft = (float)[str floatValue]; //2.0;
    
    if ((minutesLeft>0) && (minutesLeft<300)) {
        
        [self performSelector:@selector(startPressed:) withObject:nil afterDelay:0.0];
    }
    else
    {
        self.lblTime.text = [NSString stringWithFormat:@"00m:00s"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.btnYes.enabled = NO;
            self.btnNo.enabled = NO;
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
            
            [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
            
            [Userdefaults synchronize];
            
            [self gotoProfile];
            
        });
    }
}


-(IBAction)startPressed:(id)sender{
    
    minute = floor(minutesLeft / 60);
    
    second = floor(minutesLeft - (minute * 60));
    
    _isStart = YES;
    
 //   if (startTimerAT == nil) {
        
//        startTimerAT = [NSTimer scheduledTimerWithTimeInterval:1
//                                                      target:self
//                                                    selector:@selector(updateTimer)
//                                                    userInfo:nil
//                                                     repeats:YES];
//
//      [[NSRunLoop mainRunLoop] addTimer:startTimerAT forMode:NSRunLoopCommonModes];
        
  //  }
    
}


-(void)updateTimer{
    
    if ((second == 0) && (minute == 0))
    {
        //[startTimerAT invalidate];
        
       // startTimerAT = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.btnYes.enabled = NO;
            self.btnNo.enabled = NO;
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartAttendence:%@",routinehistoryidStr]];
            
            [Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
            
            [Userdefaults synchronize];
            
            [self gotoProfile];
            
        });
        
    }
    else if ((second>0)||(minute>0)) {
        
        if (second == 0)
        {
            second = 60;
            
            minute --;
        }
        else if (second == 60)
        {
            minute --;
        }
        
        second--;
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ((second>=0)&& (minute>=0)) {
            
            _lblTime.text = [NSString stringWithFormat:@"%02.0fm:%02.0fs", minute,second];
            
        } else {
            
            _lblTime.text = [NSString stringWithFormat:@"00m:00s"];
        }
    });
    
}


/*-------------------------------------Navigine--------------------------------------------*/

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self getZone];
    
}

-(void)getZone{
    
    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              _zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                          }
                                      }];
    
    [dataTask resume];
    
}

-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnYes.enabled = YES;
            });
            
        }
        else if ([zoneName isEqualToString:@"conference room small"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnYes.enabled = YES;
            });
            
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnYes.enabled = YES;
                
            });
        }
        else if ([zoneName isEqualToString:@"4"]) {
            
            BOOL restrictedZone  = [Userdefaults boolForKey:@"restrictedZone"];
            
            if (restrictedZone==NO)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                               message:@"You are near the restricted zone. Please do not enter into the restricted zone."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          
                                                                          
                                                                          
                                                                      }];
                
                [alert addAction:defaultAction];
                
                [Userdefaults setBool:YES forKey:@"restrictedZone"];
                
                [Userdefaults synchronize];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        }
    }
}


-(void)exitZoneWithZoneName:(NSString *)zoneName {

    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor grayColor]];
                
                self.btnYes.enabled = NO;
            });
            
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor grayColor]];
                
                self.btnYes.enabled = NO;
            });
            
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewYes setBackgroundColor:[UIColor grayColor]];
                
                self.btnYes.enabled = NO;
            });
        }
        else if ([zoneName isEqualToString:@"4"]) {
            
            [Userdefaults setBool:NO forKey:@"restrictedZone"];
            
            [Userdefaults synchronize];
            
        }
    }
}

- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}


- (void) navigationTick: (NSTimer *)timer {
    
   // NCDeviceInfo *res = _navigineCore.deviceInfo;
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
        // NSLog(@"RESULT: %lf %lf", res.x, res.y);
        
        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
        
        if ([[dic allKeys] containsObject:@"name"]) {
            
            // NSLog(@"zone detected:%@",dic);
            
            NSString* zoneName = [dic objectForKey:@"name"];
            
            if (!_currentZoneName) {
                
                _currentZoneName = zoneName;
                
                [self enterZoneWithZoneName:_currentZoneName];
                
            } else {
                
                if (![zoneName isEqualToString:_currentZoneName]) {
                    
                    [self exitZoneWithZoneName:_currentZoneName];
                    
                    _currentZoneName = zoneName;
                    
                    [self enterZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                }
            }
            
            
        } else {
            
            if (_currentZoneName) {
                
                [self exitZoneWithZoneName:_currentZoneName];
                
                _currentZoneName = nil;
                
            } else {
                
            }
            
        }
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }
    
}

/*-------------------------------------Navigine--------------------------------------------*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnYes:(id)sender
{
    [self gotoSelfieView];
}

- (IBAction)btnNo:(id)sender
{
    [self gotoProfile];
}

-(void)getCurrentRoutine:(NSString *)timeStr
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&usertype=student&time=%@",userId,timeStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"routine_details_by_time.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                NSDictionary *dict2 = [[dict objectForKey:@"user_routine"] objectAtIndex:0];
                
                NSArray *arrRoutine = [dict2 objectForKey:@"routine"];
                
                NSDictionary *UserInfoDict = [arrRoutine objectAtIndex:0];
                
                if (UserInfoDict!=nil) {
                    
                    [Userdefaults setObject:UserInfoDict forKey:@"userInfoDictLocal"];
                    
                    [Userdefaults synchronize];
                    
                    self.userInfoDict  = [NSDictionary dictionaryWithDictionary:UserInfoDict];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                        
                        if ([routineArr count]>0) {
                            
                            int class = 0;
                            
                            for (NSDictionary *routineDict in routineArr) {
                                
                                NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[UserInfoDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                                
                                class ++;
                                
                                if ([routineId isEqualToString:routine_history_id]) {
                                    
                                    _lblclassSection.text = [NSString stringWithFormat:@"%@-%@",[routineDict objectForKey:@"classname"],[routineDict objectForKey:@"section_name"]];
                                    
                                    _lblTeacherName.text = [NSString stringWithFormat:@"%@",[[routineDict objectForKey:@"teacher_details"] objectForKey:@"name"]];
                                    
                                    _lblLecture.text = [NSString stringWithFormat:@"%d",class];
                                    
                                    _lblSubjectName.text = [NSString stringWithFormat:@"%@",[routineDict objectForKey:@"subject_name"]];
                                    
                                    startTime = [NSString stringWithFormat:@"%@",[routineDict objectForKey:@"startTime"]];
                                    
                                    routinehistoryidStr = [self.userInfoDict objectForKey:@"routine_history_id"];
                                    
                                    [self showTimer:startTime];
                                    
                                }
                                
                            }
                            
                        }
                        
                    });
                    
                }
                
                [SVProgressHUD dismiss];
                
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with internet, try again later."
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

-(void)gotoSelfieView
{
    SelfiViewController *selfieScreen = [[SelfiViewController alloc]initWithNibName:@"SelfiViewController" bundle:nil];
    
    self.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    selfieScreen.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:selfieScreen animated:YES];
        
    });
    
//    [self.navigationController pushViewController:selfieScreen animated:YES];
//
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:selfieScreen];
//
//    drawer.mainViewController = localNavigationController;
//
//    drawer.drawerViewController = menu;
//
//    /* Customize */
//    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
//    drawer.drawerWidth = 5*(SCREENWIDTH/8);
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
//    });
    
}
    
-(void)gotoProfile
{
   ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:profileScreen animated:YES];
        
    });
        
//   [self.navigationController pushViewController:profileScreen animated:YES];
//
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:profileScreen];
//
//    drawer.mainViewController = localNavigationController;
//
//    drawer.drawerViewController = menu;
//
//    /* Customize */
//    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
//    drawer.drawerWidth = 5*(SCREENWIDTH/8);
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
//    });
    
}

@end
