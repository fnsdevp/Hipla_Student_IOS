//
//  StartClassViewController.m
//  HiplaStudent
//
//  Created by FNSPL on 10/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "StartClassViewController.h"
#import "ZoneDetection.h"

@interface StartClassViewController ()

@end


@implementation StartClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    _timeCal = 0.0;
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    _lblTime.text = @"";
    
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
    
    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    if (self.userInfoDict!=nil) {
        
        _lblclassSection.text = [NSString stringWithFormat:@"%@-%@",[self.userInfoDict objectForKey:@"classname"],[self.userInfoDict objectForKey:@"section_name"]];
        
        NSDictionary *dictTeacher = [self.userInfoDict objectForKey:@"teacher_details"];
        
        // NSLog(@"%@",[dictTeacher objectForKey:@"name"]);
        
        _lblTeacherName.text = [NSString stringWithFormat:@"%@",[dictTeacher objectForKey:@"name"]];
        
        _lblPeriod.text = [NSString stringWithFormat:@"%@",[self.userInfoDict objectForKey:@"subject_name"]];
        
        startTime = [NSString stringWithFormat:@"%@",[self.userInfoDict objectForKey:@"startTime"]];
        
        self.roomName = [NSString stringWithFormat:@"%@",[self.userInfoDict objectForKey:@"room_id"]];
        
        [self showTimer:nil];
        
        /*
         self.dateFormatter=[[NSDateFormatter alloc] init];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *strDate = [self.dateFormatter stringFromDate:[NSDate date]];
        
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *strTime = [self.userInfoDict objectForKey:@"startTime"];
        
        NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
        
        NSComparisonResult compare = [[NSDate date] compare:StartDateTime];
        
        if (compare==NSOrderedDescending)
        {
            NSString *currentTime = [Userdefaults objectForKey:@"currentTime"];
            
            if ([currentTime length]==0) {
                
                [self.dateFormatter setDateFormat:@"hh:mm a"];
                
                currentTime = [self.dateFormatter stringFromDate:[NSDate date]];
                
                [Userdefaults setObject:currentTime forKey:@"currentTime"];
                
                [Userdefaults synchronize];
                
            }
            
            [self showTimer:currentTime];
        }
        else
        {
            [Userdefaults removeObjectForKey:@"currentTime"];
            
            [Userdefaults synchronize];
            
            [self showTimer:startTime];
        }
        */
        
    } else {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *outTime = [dateFormatter stringFromDate:currentDate];
        
        [self getCurrentRoutine:outTime];
        
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    second = -1;
    minute = -1;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _navigineCore = nil;
    
  // [[ZoneDetection sharedZoneDetection] setDelegate:nil];
    
}


-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}

-(IBAction)btnNav:(id)sender
{
    [self gotoClass];
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
    [self performSelector:@selector(startPressed:) withObject:nil afterDelay:0.0];
}

-(IBAction)startPressed:(id)sender{
    
    NSString *twoMinTimerStr = [Userdefaults objectForKey:@"2MinTimerTime"];
    
    if ([twoMinTimerStr length]>0)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSDate *twoMinTimerDate = [self.dateFormatter dateFromString:twoMinTimerStr];
        
       // NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:twoMinTimerDate];
        
        NSDate *Date2 = [twoMinTimerDate dateByAddingTimeInterval:(2*60)];
        
        NSTimeInterval time = [Date2 timeIntervalSinceDate:[NSDate date]];
        
        NSString * str = [NSString stringWithFormat:@"%0.2f",time];
        
        minutesLeft = (float)[str floatValue]; //2.0;
        
        if ((minutesLeft>0) && (minutesLeft<120)) {
            
            minute = floor(minutesLeft / 60);
            
            second = floor(minutesLeft - (minute * 60));
            
            _isStart = YES;
            
        } else {
            
            [Userdefaults removeObjectForKey:@"2MinTimerTime"];
            
            [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
            
            [Userdefaults synchronize];
            
            [self gotoProfile];
        }
        
    }
    else
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSString *currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
        
        [Userdefaults setObject:currentDateStr forKey:@"2MinTimerTime"];
        
        [Userdefaults synchronize];
        
        minute = 2.0;//floor(minutesLeft / 60);
        
        second = 0.0;//floor(minutesLeft - (minute * 60));
        
        _isStart = YES;
        
    }
    
//    if (startTimer == nil) {
//
//        startTimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                     target:self
//                                                   selector:@selector(updateTimer)
//                                                   userInfo:nil
//                                                    repeats:YES];
//
//     [[NSRunLoop mainRunLoop] addTimer:startTimer forMode:NSRunLoopCommonModes];
//
//    }
    
}

- (void)navigationTicker {
    
    [self updateTimer];
    
    [self navigationTick:nil];
}

-(void)updateTimer{
    
    if ((second == 0) && (minute == 0))
    {
       // [startTimer invalidate];
        
      //  startTimer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            inClass = true;
            
            [Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
            
            NSString *routinehistoryidStr = [self.userInfoDict objectForKey:@"routine_history_id"];
            
            [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"StartTimer:%@",routinehistoryidStr]];
            
            [Userdefaults removeObjectForKey:@"2MinTimerTime"];
            
            [Userdefaults removeObjectForKey:@"currentTime"];
            
            [Userdefaults synchronize];
            
            [self gotoProfile];
            
        });
        
    }
    else if ((second>0)||(minute>0)) {
        
        inClass = false;
        
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
        
        if ([zoneName isEqualToString:@"conference area"])
        {
            if (inClass) {
                
                if ([_strNotif isEqualToString:@"push"]) {
                    
                    [self gotoAttendence];
                    
                    inClass = false;
                }
            }
            
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            if (inClass) {
                
                if ([_strNotif isEqualToString:@"push"]) {
                    
                    [self gotoAttendence];
                    
                    inClass = false;
                }
            }
            
        }
        else if ([zoneName isEqualToString:@"3"]) {
            
            if (inClass) {
                
                if ([_strNotif isEqualToString:@"push"]) {
                    
                    [self gotoAttendence];
                    
                    inClass = false;
                }
            }
            
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
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *outTime = [dateFormatter stringFromDate:currentDate];
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"])
        {
            
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
            
            //            NSLog(@"zone detected:%@",dic);
            
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

                        _lblclassSection.text = [NSString stringWithFormat:@"%@-%@",[UserInfoDict objectForKey:@"classname"],[UserInfoDict objectForKey:@"section_name"]];

                        NSDictionary *dictTeacher = [UserInfoDict objectForKey:@"teacher_details"];

                        // NSLog(@"%@",[dictTeacher objectForKey:@"name"]);
                        
                         self.roomName = [NSString stringWithFormat:@"%@",[dictTeacher objectForKey:@"room_id"]];

                        _lblTeacherName.text = [NSString stringWithFormat:@"%@",[dictTeacher objectForKey:@"name"]];

                        _lblPeriod.text = [NSString stringWithFormat:@"%@",[UserInfoDict objectForKey:@"subject_name"]];

                        startTime = [NSString stringWithFormat:@"%@",[UserInfoDict objectForKey:@"startTime"]];

                        [self showTimer:startTime];

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

-(void)gotoProfile
{
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:profileScreen animated:YES];
        
    });
}

-(void)gotoAttendence
{
    AttendanceViewController *attendenceScreen = [[AttendanceViewController alloc]initWithNibName:@"AttendanceViewController" bundle:nil];
    
    attendenceScreen.userInfoDict = self.userInfoDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:attendenceScreen animated:YES];
        
    });
}

-(void)gotoClass
{
    NavigationViewController *navScreen = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil];
    
    navScreen.className = self.roomName;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:navScreen animated:YES];
        
    });
}

@end
