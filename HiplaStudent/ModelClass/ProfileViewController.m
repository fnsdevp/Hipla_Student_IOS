//
//  ProfileViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 13/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ProfileViewController.h"
#import "RoutineViewController.h"
#import "ZoneDetection.h"
#import "Common.h"

@interface ProfileViewController () {
    
    NSInteger avgExiteZone;
}

@end


@implementation ProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    avgExiteZone = 0;
    
    _imgView.layer.cornerRadius = _imgView.frame.size.height/2;
    _imgView.layer.masksToBounds = YES;
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    self.userInfoDict = [Userdefaults objectForKey:@"userInfo"];
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    [self ProfileDetails];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
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

-(IBAction)btnOK:(id)sender
{
    [self gotoStartClass];
}


-(void)createFolder
{
    self.filemgr =[NSFileManager defaultManager];
    
    self.dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    
    self.docsDir = [self.dirPaths objectAtIndex:0];
    
    self.NewDir = [self.docsDir stringByAppendingPathComponent:@"Routine Folder"];
    
    BOOL isDir = NO;
    
    BOOL isFile = [self.filemgr fileExistsAtPath:self.NewDir isDirectory:&isDir];
    
    if(isFile)
    {
        //it is a file, process it here how ever you like, check isDir to see if its a directory
    }
    else
    {
        if ([self.filemgr createDirectoryAtPath:self.NewDir withIntermediateDirectories:NO attributes:nil error:nil] == YES)
        {
            NSLog(@"%@",self.NewDir);
        }
    }
    
}


-(void)ProfileDetails
{
    self.dateFormatter=[[NSDateFormatter alloc] init];
    
    self.currentDate = [NSDate date];
    
    NSLog(@"viewDidLoad:%@",self);
    
    _lblName.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    
    _lblSemester.text = [NSString stringWithFormat:@"Semester : %@",[userInfo objectForKey:@"class_id"]];
    _lblSection.text = [NSString stringWithFormat:@"Section : %@",[userInfo objectForKey:@"section"]];
    _lblStream.text = [NSString stringWithFormat:@"Stream  : %@",[userInfo objectForKey:@"class"]];
    
    [self.dateFormatter setDateFormat:@"yyyy"];
    
    [self createFolder];
    
    NSString *yearString = [self.dateFormatter stringFromDate:self.currentDate];
    
    _lblYear.text = [NSString stringWithFormat:@"Year :  %@",yearString];
    
    _lbladdress.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"address"]];
    
    _lblPhoneNumber.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"phone"]];
    
    _lblEmailID.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"email"]];
    
    NSString *ImageURL = [NSString stringWithFormat:@"http://cxc.gohipla.com/education/admin/apps/webcam/%@",[userInfo objectForKey:@"photo"]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    self.imgView.image = [UIImage imageWithData:imageData];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.currentDateStr = [self.dateFormatter stringFromDate:[NSDate date]];
    
    [self checkRoutine:self.currentDateStr];
    
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    
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


//- (void) navigationTick: (NSTimer *)timer {
- (void)navigationTicker {
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
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
        
        /*if ([[dic allKeys] containsObject:@"name"]) {
            
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
            
        }*/
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }

//    [self performSelector:@selector(navigationTick:) withObject:nil afterDelay:1.0];
    
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

#pragma mark - sharedZoneDetectionDelegate
-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            NSLog(@"conference area");
            
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
        else if ([zoneName isEqualToString:@"3"]) {
            
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

/*-------------------------------------Navigine--------------------------------------------*/

-(void)updateDevice
{
    NSString *deviceToken = [Utils deviceToken];
    
    NSString *userUpdate = [NSString stringWithFormat:@"userid=%@&usertype=student&device_type=Ios&device_token=%@", userId, deviceToken];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"updatedevice.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
            }
            
        } else {
            
            NSLog(@"Error: %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with internet, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            });
            
        }
        
    }];
    
}


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


- (void)writeStringToFile:(NSString*)aString {
    
    NSString* fileName = @"routine.json";
    
    NSString* fileAtPath = [self.NewDir stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}


- (NSString*)readStringFromFile {
    
    NSString* fileName = @"routine.json";
    
    NSString* fileAtPath = [self.NewDir stringByAppendingPathComponent:fileName];
    
    NSString *strJson = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
    
    
    return strJson;
}


- (NSDictionary *)JSONFromFile
{
    NSString* fileName = @"routine.json";
    NSString* fileAtPath = [self.NewDir stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:fileAtPath];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


-(void)checkRoutine:(NSString *)dateStr
{
    BOOL routineUpdated = [Userdefaults boolForKey:@"routineUpdated"];
    if (routineUpdated) {
        
        [Userdefaults removeObjectForKey:@"isRoutineStartTimerSet"];
        [Userdefaults synchronize];
        
        [self RoutineWithDetails:dateStr];
        
    } else {
        
        NSString *strJson = [self readStringFromFile];
        
        if ([strJson length]>0)
        {
            NSDictionary *dict = [self JSONFromFile];
            NSString* strRoutineDate = [dict objectForKey:@"date"];
            
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString* strCurrentDate = [self.dateFormatter stringFromDate:[NSDate date]];
            NSDate *currentDate = [self.dateFormatter dateFromString:strCurrentDate];
            NSDate *routineDate = [self.dateFormatter dateFromString:strRoutineDate];
            
            if ([currentDate compare:routineDate] == NSOrderedSame)
            {
                NSDictionary *dict = [self JSONFromFile];
                
                if ([[dict allKeys] containsObject:@"routine"])
                {
                    self.routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                    NSNumber* isRoutineStartTimerSet = [Userdefaults objectForKey:@"isRoutineStartTimerSet"];

                    if (([self.routineArr count]>0) && ![isRoutineStartTimerSet boolValue]) {
                        
                        for (int i=0; i<[self.routineArr count]; i++)
                        {
                            NSDictionary *dictRoutine = [self.routineArr objectAtIndex:i];
                            
                            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            
                            NSString *strDate = [self.dateFormatter stringFromDate:self.currentDate];
                            
                            [self.dateFormatter setDateFormat:@"hh:mm a"];
                            
                            NSString *strTime = [dictRoutine objectForKey:@"startTime"];
                            
                            NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                            
                            [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                            
                            NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                            
                            NSComparisonResult compare = [self.currentDate compare:StartDateTime];
                            
                            if (compare==NSOrderedAscending) {
                                
                                [self startLocalNotificationforRoutineCall:[dictRoutine objectForKey:@"classname"] withSection:[dictRoutine objectForKey:@"section_name"] withPeriodDate:self.currentDateStr withPeriodTime:[dictRoutine objectForKey:@"startTime"] andId:[dictRoutine objectForKey:@"routine_history_id"] withDetails:dictRoutine];
                                
                            }
                            
                        }
                        
                        [Userdefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isRoutineStartTimerSet"];
                        [Userdefaults synchronize];
                    }
                    
                    [self updateDevice];
                    
                }
                else
                {
                    self.routineArr = [[NSMutableArray alloc]init];
                }
                
            }
            else
            {
                [self RoutineWithDetails:dateStr];
                
            }
            
        } else {
            
            [self RoutineWithDetails:dateStr];
        }

    }
    
   // [self getUserDetails];

}


-(void)RoutineWithDetails:(NSString *)dateStr
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"userid=%@&date=%@&usertype=student&device_type=ios",userId,dateStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"routinebydate_student.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            self.userRoutineInfo = [[NSMutableArray alloc] init];
            
            if ([successStr isEqualToString:@"success"]) {
                
                if ([[dict allKeys] containsObject:@"user_routine"])
                {
                    self.userRoutineInfo = [NSMutableArray arrayWithArray:[dict objectForKey:@"user_routine"]];
                    
                    if ([self.userRoutineInfo count]>0) {
                        
                        NSDictionary *ProfDict = (NSDictionary *)[self.userRoutineInfo objectAtIndex:0];
                        
                        NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                        
                        NSLog(@"DICT=====%@",dict);
                        
                        NSError * err;
                        
                        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
                        
                        NSString * routineString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        
                        [self writeStringToFile:routineString];
                        
                        self.routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                                                
                        NSNumber* isRoutineStartTimerSet = [Userdefaults objectForKey:@"isRoutineStartTimerSet"];
                        
                        if (([self.routineArr count]>0) && (![isRoutineStartTimerSet boolValue]))
                        {
                            for (int i=0; i<[self.routineArr count]; i++)
                            {
                                NSDictionary *dictRoutine = [self.routineArr objectAtIndex:i];
                                
                                [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                
                                NSString *strDate = [self.dateFormatter stringFromDate:self.currentDate];
                                
                                [self.dateFormatter setDateFormat:@"hh:mm a"];
                                
                                NSString *strTime = [dictRoutine objectForKey:@"startTime"];
                                
                                NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                                
                                [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                                
                                NSDate *StartDateTime = [self.dateFormatter dateFromString:fireDateime];
                                
                                NSComparisonResult compare = [self.currentDate compare:StartDateTime];
                                
                                if (compare==NSOrderedAscending) {
                                    
                                    [self startLocalNotificationforRoutineCall:[dictRoutine objectForKey:@"classname"] withSection:[dictRoutine objectForKey:@"section_name"] withPeriodDate:self.currentDateStr withPeriodTime:[dictRoutine objectForKey:@"startTime"] andId:[dictRoutine objectForKey:@"routine_history_id"] withDetails:dictRoutine];
                                    
                                }
                                
                            }
                            
                            [Userdefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isRoutineStartTimerSet"];
                            [Userdefaults synchronize];
                            
                        }
                        
                        [self updateDevice];
                        
                    }
                    
                }
                else
                {
                    self.routineArr = [[NSMutableArray alloc]init];
                }
                
                [Userdefaults setBool:NO forKey:@"routineUpdated"];
                
                [Userdefaults synchronize];
                
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with Routine details, try again later."
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
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with internet, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
                [SVProgressHUD dismiss];
                
            });
            
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
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                if ([[dict allKeys] containsObject:@"user_routine"])
                {
                    NSDictionary *dict2 = (NSDictionary *)[[dict objectForKey:@"user_routine"] objectAtIndex:0];
                    
                    NSArray *arrRoutine = [NSArray arrayWithArray:[dict2 objectForKey:@"routine"]];
                    
                    NSDictionary *UserInfoDict = (NSDictionary *)[arrRoutine objectAtIndex:0];
                    
                    if (UserInfoDict!=nil) {
                        
                        [self.dateFormatter setDateFormat:@"hh:mm a"];
                        
                        NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                        
                        [self sneakAttendence:UserInfoDict currentTime:outTime];
                        
                    }
                }
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


-(void)getUserDetails
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&user_type=student",userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"user_details.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                NSString *userType = [dict objectForKey:@"usertype"];
                
                NSDictionary *userDetails = [[dict objectForKey:@"user_details"] objectAtIndex:0];
                
                NSDictionary *userDetails1 = [userDetails dictionaryByReplacingNullsWithBlanks];
                
                [Userdefaults setObject:userDetails1 forKey:@"ProfInfo"];
                [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
                [Userdefaults setObject:userType forKey:@"userType"];
                
                [Userdefaults removeObjectForKey:@"userUpdated"];
                
                [Userdefaults synchronize];
                
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with internet, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                });
                
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

-(void)startLocalNotificationforRoutineCall:(NSString *)className withSection:(NSString *)section withPeriodDate:(NSString *)Date withPeriodTime:(NSString *)Time andId:(NSString *)routineHistoryId withDetails:(NSDictionary *)dictRoutine{
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",Date,Time];
    
    NSDate *now = [self.dateFormatter dateFromString:fireDateime];
    
    NSDate *SetAlarmAt = [now dateByAddingTimeInterval:-(2*60)];
    
    NSString *str1 = [NSString stringWithFormat:@"Your %@-%@ class will start today on %@.",className,section,Time];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = SetAlarmAt;
    notification.alertBody = str1;
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    
    notification.userInfo = dictRoutine;
    
    notification.repeatInterval=0;
    
    [Userdefaults setBool:true forKey:[NSString stringWithFormat:@"RoutineCalled:%@",routineHistoryId]];
    
    [Userdefaults synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    });
    
}

-(void)endLocalNotificationforRoutineCall:(NSString *)className withSection:(NSString *)section withPeriodDate:(NSString *)Date withPeriodTime:(NSString *)endTime andId:(NSString *)routineHistoryId withDetails:(NSDictionary *)dictRoutine{
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",Date,endTime];
    
    NSDate *SetAlarmAt = [self.dateFormatter dateFromString:fireDateime];
    
    NSString *str1 = [NSString stringWithFormat:@"Your %@-%@ ended today on %@.",className,section,endTime];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = SetAlarmAt;
    notification.alertBody = str1;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.self.userInfo = dictRoutine;
    
    notification.repeatInterval=0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    });
    
}

- (IBAction)clickedOpen:(id)sender {

    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
        
    });
    
}


-(void)gotoStartClass
{
    StartClassViewController *startclassScreen = [[StartClassViewController alloc]initWithNibName:@"StartClassViewController" bundle:nil];
    
    NSLog(@"%@",_userInfoDict);
    
    startclassScreen.userInfoDict = self.userInfoDict;
    
    startclassScreen.isStart = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:startclassScreen animated:YES];
    });
    
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:startclassScreen];
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


-(void)gotoAttendenceClass
{
    
    AttendanceViewController *attendenceScreen = [[AttendanceViewController alloc]initWithNibName:@"AttendanceViewController" bundle:nil];
    
    NSLog(@"%@",_userInfoDict);
    
    attendenceScreen.userInfoDict = self.userInfoDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:attendenceScreen animated:YES];
    });
    
//    [self.navigationController pushViewController:attendenceScreen animated:YES];
//
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:attendenceScreen];
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

-(void)gotoSuccessView
{
    SuccessAttendenceViewController *successScreen = [[SuccessAttendenceViewController alloc]initWithNibName:@"SuccessAttendenceViewController" bundle:nil];
    
    NSLog(@"%@",_userInfoDict);
    
    successScreen.userInfoDict = self.userInfoDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:successScreen animated:YES];
    });
    
//    [self.navigationController pushViewController:successScreen animated:YES];
//
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:successScreen];
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
