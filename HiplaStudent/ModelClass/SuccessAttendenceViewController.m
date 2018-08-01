//
//  SuccessAttendenceViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 24/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "SuccessAttendenceViewController.h"

@interface SuccessAttendenceViewController () {
    
    NSInteger avgExiteZone;
}

@end


@implementation SuccessAttendenceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    self.dateFormatter=[[NSDateFormatter alloc] init];
    
    self.currentDate = [NSDate date];
    
    /*
    
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
    
  //  [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    */
    
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    second = -1;
    minute = -1;
    
    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    if (self.userInfoDict!=nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _lblBranch.text = [self.userInfoDict objectForKey:@"subject_name"];
            
            _lblTime.text = @"";
            
            [self showTimer:self.userInfoDict];
            
        });
        
    }
    
    
   // NSMutableArray *routineArr = [Userdefaults objectForKey:@"routineArr"];
    
//    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfo"];
//
//    if ([routineArr count]>0) {
//
//        for (NSDictionary *routineDict in routineArr) {
//
//            NSString *status = [[self.userInfoDict objectForKey:@"aps"] objectForKey:@"alert"];
//
//            NSArray *statusArr = [status componentsSeparatedByString:@" "];
//
//            NSString *routineId = [statusArr objectAtIndex:0];
//
//            NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
//
//            if ([routineId isEqualToString:routine_history_id]) {
//
//                _lblBranch.text = [routineDict objectForKey:@"subject_name"];
//
//                _lblTime.text = @"";
//
//                [self showTimer:routineDict];
//
//            }
//
//        }
//
//    }
    
//    [self navigationStart];
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
   // NSLog(@"%@",self.userInfoDict);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _navigineCore = nil;
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
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


-(void)showTimer:(NSDictionary *)routineDict
{
   // startTimer = nil;
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *currentDateStr = [self.dateFormatter stringFromDate:self.currentDate];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *currentTimeStr = [self.dateFormatter stringFromDate:self.currentDate];
    
    NSDate *currentTime = [self.dateFormatter dateFromString:currentTimeStr];
    
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ %@",currentDateStr,[routineDict objectForKey:@"endTime"]];
    
    NSDate *endTime = [self.dateFormatter dateFromString:endTimeStr];
    
   // interval = [endTime timeIntervalSinceDate:currentTime];
    
    interval = [endTime timeIntervalSinceDate:[NSDate date]];
    
    //NSLog(@"time interval:%f", interval);
    
    float timeLeft = interval; //(interval/60);
    
    NSString * str = [NSString stringWithFormat:@"%.2f",timeLeft];
    
    minutesLeft = (float)[str floatValue];
        
    if (minutesLeft>0) {
        
        [self performSelector:@selector(startPressed:) withObject:nil afterDelay:0.0];
    }
    else
    {
        self.lblTime.text = [NSString stringWithFormat:@"00m:00s"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
            
            [Userdefaults synchronize];
            
            [self gotoProfile];
            
        });
    }
        
}

    
-(IBAction)startPressed:(id)sender{
    
   minute = floor(minutesLeft / 60);
    
   second = floor(minutesLeft - (minute * 60));
    
   _isStart = YES;
    
//  if (startTimer == nil) {
//
//    startTimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                      target:self
//                                                    selector:@selector(updateTimer)
//                                                    userInfo:nil
//                                                     repeats:YES];
//
//
//    [[NSRunLoop mainRunLoop] addTimer:startTimer forMode:NSRunLoopCommonModes];
//
//  }
    
}

- (void)navigationTicker {
    
    [self updateTimer];
    
    [self navigationTick:nil];
}
    
-(void)updateTimer{
    
    if ((second == 0) && (minute == 0))
    {
       // [startTimer invalidate];
        
       // startTimer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
            
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
    
    NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"])
        {
            BOOL isClassStarted = [Userdefaults boolForKey:@"isClassStarted"];
            
            if(isClassStarted)
            {
                BOOL SneakOutFired = [Userdefaults boolForKey:@"SneakOutFired"];
                
                if (SneakOutFired==NO) {
                    
                    //[self getCurrentRoutineForSneak:outTime];
                    
                    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
                    
                    if (self.userInfoDict!=nil) {
                        
                        [self.dateFormatter setDateFormat:@"hh:mm a"];
                        
                        NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                        
                        [self sneakAttendence:self.userInfoDict currentTime:outTime];
                        
                    }
                }
                
            }
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            BOOL isClassStarted = [Userdefaults boolForKey:@"isClassStarted"];
            
            if(isClassStarted)
            {
                BOOL SneakOutFired = [Userdefaults boolForKey:@"SneakOutFired"];
                
                if (SneakOutFired==NO) {
                    
                    //[self getCurrentRoutineForSneak:outTime];
                    
                    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
                    
                    if (self.userInfoDict!=nil) {
                        
                        [self.dateFormatter setDateFormat:@"hh:mm a"];
                        
                        NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                        
                        [self sneakAttendence:self.userInfoDict currentTime:outTime];
                        
                    }
                }
                
            }
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            BOOL isClassStarted = [Userdefaults boolForKey:@"isClassStarted"];
            
            if(isClassStarted)
            {
                BOOL SneakOutFired = [Userdefaults boolForKey:@"SneakOutFired"];
                
                if (SneakOutFired==NO) {
                    
                    //[self getCurrentRoutineForSneak:outTime];
                    
                    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
                    
                    if (self.userInfoDict!=nil) {
                        
                        [self.dateFormatter setDateFormat:@"hh:mm a"];
                        
                        NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                        
                        [self sneakAttendence:self.userInfoDict currentTime:outTime];
                        
                    }
                }
                
            }
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
        
        _currentZoneName = @"conference area";
        // NSLog(@"RESULT: %lf %lf", res.x, res.y);
        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
        if ([[dic allKeys] containsObject:@"name"]) {
            
            // NSLog(@"zone detected:%@",dic);
            NSString* zoneName = [dic objectForKey:@"name"];
            if ([zoneName isEqualToString:_currentZoneName]) {
                
                avgExiteZone = 0;
                [self enterZoneWithZoneName:_currentZoneName];
                
            } else {
                
                if (avgExiteZone > 5) {
                    
                    avgExiteZone = 0;
                    [self exitZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                    avgExiteZone++;
                }
                
            }
        }
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }
    
}

/*-------------------------------------Navigine--------------------------------------------*/

-(void)sneakAttendence:(NSDictionary *)dict currentTime:(NSString *)outTime
{
    [SVProgressHUD show];
    
    NSString *routine_history_id = [dict objectForKey:@"routine_history_id"];
    
    NSString *teacher_id = [[dict objectForKey:@"teacher_details"] objectForKey:@"id"];
    
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    [Userdefaults setBool:YES forKey:@"SneakOutFired"];
    
    [Userdefaults synchronize];
    
    NSString *student_id = userId;
    
    NSString *userUpdate = [NSString stringWithFormat:@"routine_history_id=%@&teacher_id=%@&student_id=%@&out_time=%@&remark=Marked Absent",routine_history_id,teacher_id,student_id,outTime];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"student_sneakout.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                [Userdefaults setBool:YES forKey:@"SneakOutFired"];
                
                [Userdefaults synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please back to the class."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    
                    [SVProgressHUD dismiss];
                    
                });
                
            }
            
        }
        else
        {
            [Userdefaults setBool:NO forKey:@"SneakOutFired"];
            
            [Userdefaults synchronize];
        }
        
    }];
    
}

-(void)getCurrentRoutineForSneak:(NSString *)timeStr
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
                    
                    [SVProgressHUD dismiss];
                    
                    [self.dateFormatter setDateFormat:@"hh:mm a"];
                    
                    NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                    
                    [self sneakAttendence:UserInfoDict currentTime:outTime];
                    
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _lblBranch.text = [UserInfoDict objectForKey:@"subject_name"];
                        
                        _lblTime.text = @"";
                        
                        [self showTimer:UserInfoDict];
                        
                    });
        
                }
                
                [SVProgressHUD dismiss];
                
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

-(void)gotoProfile
{
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:profileScreen animated:YES];
        
    });
    
}

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

@end
