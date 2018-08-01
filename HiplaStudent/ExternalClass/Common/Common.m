//
//  Common.m
//  HiplaStudent
//
//  Created by FNSPL on 14/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "Common.h"

static Common *sharedCommon = nil;

@implementation Common

+(Common *) sharedCommonFetch {
    
    @synchronized([Common class])
    {
        if (!sharedCommon) {
            
            sharedCommon = [[self alloc] init];
            
        }
        
        return sharedCommon;
    }
    
    return nil;
    
}


-(NSString *)routineFilePath {
    
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
    NSString* docsDir = [dirPaths objectAtIndex:0];
    NSString* newDir = [docsDir stringByAppendingPathComponent:@"Routine Folder"];
    NSString* fileName = @"routine.json";
    NSString* fileAtPath = [newDir stringByAppendingPathComponent:fileName];
    
    return fileAtPath;
}


- (void)writeStringToFile:(NSString*)aString {
    
    NSString* fileAtPath = [self routineFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}


- (NSString*)readStringFromFile {
    
    NSString *strJson = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[self routineFilePath]] encoding:NSUTF8StringEncoding];
    
    return strJson;
}


- (NSDictionary *)JSONFromFile
{
    NSData *data = [NSData dataWithContentsOfFile:[self routineFilePath]];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (NSMutableArray *)getDetailsofRoutine:(NSString *)givenDate
{
    NSMutableArray* arrRoutines = nil;
    NSDictionary* dicRoutine = [self JSONFromFile];
    NSArray* routines = [dicRoutine objectForKey:@"routine"];
    arrRoutines = [NSMutableArray arrayWithArray:routines];
    
    NSMutableArray* finalRoutines = [NSMutableArray array];
    for (NSDictionary* dic in arrRoutines) {
        
        NSMutableDictionary* routineDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString* startTime = [dic objectForKey:@"startTime"];
        NSArray* arr = [startTime componentsSeparatedByString:@" "];
        NSString* timeFormate = [arr lastObject];
        NSArray* arr2 = [[arr firstObject] componentsSeparatedByString:@":"];
        NSInteger hr = 0;
        NSString* min = @"";
        if ([timeFormate isEqualToString:@"PM"]) {
            
            hr = [[arr2 firstObject] integerValue];
            min = [arr2 objectAtIndex:1];
            hr += 12;
            
        } else {
            
            hr = [[arr2 firstObject] integerValue];
            min = [arr2 objectAtIndex:1];
        }
        
        [routineDic setValue:[NSString stringWithFormat:@"%ld:%@",(long)hr,min] forKey:@"startTimeIn24Hr"];
        [finalRoutines addObject:routineDic];
    }
    arrRoutines = finalRoutines;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"startTimeIn24Hr" ascending: YES];
    
    NSArray *sortedRoutineArray = [arrRoutines sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    
    return  [NSMutableArray arrayWithArray:sortedRoutineArray];
    
}


- (BOOL)isNextClassStart:(NSDictionary *)dicClass {
    
    BOOL isNextClassStart = NO;
    NSDictionary *dict = [self JSONFromFile];
    if ([[dict allKeys] containsObject:@"routine"]) {
        
        self.routineArr = [self getDetailsofRoutine:nil];
        if ([self.routineArr count]>0) {
            
            for (int i=0; i<[self.routineArr count]; i++)
            {
                NSDictionary *dictRoutine = [self.routineArr objectAtIndex:i];
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                
                NSString *strEndTime = [Userdefaults objectForKey:@"endTimeStr"];
                
                NSDate *StartDateTime = [self.dateFormatter dateFromString:strEndTime];
                
                NSComparisonResult compare = [[NSDate date] compare:StartDateTime];
                
                if (compare==NSOrderedDescending)
                {
                    [self startLocalNotificationforRoutineCall:[dictRoutine objectForKey:@"classname"] withSection:[dictRoutine objectForKey:@"section_name"] withPeriodDate:self.currentDateStr withPeriodTime:[dictRoutine objectForKey:@"startTime"] andId:[dictRoutine objectForKey:@"routine_history_id"] withDetails:dictRoutine];
                }
            }
        }
    }
    return isNextClassStart;
}


-(void)getCurrentRoutine:(NSString *)timeStr
{
    [SVProgressHUD show];
    
    api = [APIManager sharedManager];
    
    NSDictionary *userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    NSString *userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&usertype=student&time=%@",userId,timeStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"routine_details_by_time.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                [SVProgressHUD dismiss];
                
                if ([[dict allKeys] containsObject:@"user_routine"])
                {
                    NSArray *arrUser = [dict objectForKey:@"user_routine"];
                    
                    NSDictionary *UserRoutineDict = [arrUser objectAtIndex:0];
                    
                    NSArray *arrRoutine = [UserRoutineDict objectForKey:@"routine"];
                    
                    NSDictionary *routineDict = [arrRoutine objectAtIndex:0];
                    
                    if (routineDict!=nil) {
                        
                        [Userdefaults setObject:routineDict forKey:@"userInfoDictLocal"];
                        
                        [Userdefaults synchronize];
                        
                        if (self.commonDelegate) {
                            
                            [self.commonDelegate currentRoutineStatus:routineDict];
                            
                        } else {
                            
                        }
                        
                    }
                    
                }
                else
                {
                    //[Userdefaults removeObjectForKey:@"userInfoDictLocal"];
                    
                    //[Userdefaults setObject:@"NO" forKey:@"isClassStarted"];
                    
                    //[Userdefaults setObject:@"NO" forKey:@"isSelfieTimerCalled"];
                    
                    //[Userdefaults setObject:@"NO" forKey:@"isStartTimerCalled"];
                    
                    //[Userdefaults removeObjectForKey:@"SneakOutFired"];
                    
                    //[Userdefaults synchronize];
                    
                    if (self.commonDelegate) {
                        
                        [self.commonDelegate currentRoutineStatus:nil];
                        
                    } else {
                        
                    }
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
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
    
}


-(void)checkRoutine:(NSString *)dateStr
{
    api = [APIManager sharedManager];
    
    NSDictionary *dict = [self JSONFromFile];
    
    if ([[dict allKeys] containsObject:@"routine"])
    {
        self.routineArr = [self getDetailsofRoutine:nil];
        
        if ([self.routineArr count]>0) {
            
            //int routineCount = 0;
            
            for (int i=0; i<[self.routineArr count]; i++)
            {
                NSDictionary *dictRoutine = [self.routineArr objectAtIndex:i];
                
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                
                NSString *strEndTime = [Userdefaults objectForKey:@"endTimeStr"];
                
                NSDate *StartDateTime = [self.dateFormatter dateFromString:strEndTime];
                
                NSComparisonResult compare = [[NSDate date] compare:StartDateTime];
                
                if (compare==NSOrderedDescending)
                {
                    [self startLocalNotificationforRoutineCall:[dictRoutine objectForKey:@"classname"] withSection:[dictRoutine objectForKey:@"section_name"] withPeriodDate:self.currentDateStr withPeriodTime:[dictRoutine objectForKey:@"startTime"] andId:[dictRoutine objectForKey:@"routine_history_id"] withDetails:dictRoutine];
                }
            }
        }
    }
    else
    {
        self.routineArr = [[NSMutableArray alloc]init];
    }
    
}


-(void)RoutineWithDetails:(NSString *)dateStr
{
    api = [APIManager sharedManager];
    
    [SVProgressHUD show];
    
    NSDictionary *userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    NSString *userId=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
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
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
    
}


-(void)checkRoutineStatus:(NSString *)routineHistoryId
{
    api = [APIManager sharedManager];
    
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"routine_history_id=%@",routineHistoryId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"check_routineStatus.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"])
            {
                if (self.commonDelegate) {
                    
                    [self.commonDelegate routineStatus:dict];
                    
                } else {
                    
                }
                //                NSDictionary *routineDetails = [dict objectForKey:@"routine_details"];
                //
                //                NSString *statusStr = [routineDetails objectForKey:@"status"];
                
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
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with network, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
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
    
    
//    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
//
//    content.title = @"gg";
//    content.subtitle = @"ggg";
//    content.body = @"hhh";
//    content.sound = [UNNotificationSound defaultSound];
//
//    // Deliver the notification in five seconds.
//    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
//                                                  triggerWithTimeInterval:0 repeats:NO];
//    [trigger nextTriggerDate];
//
//    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"conference room small"
//                                                                          content:content trigger:trigger
//                                      ];
//
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//
//    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//
//        if (!error) {
//            NSLog(@"add NotificationRequest succeeded!");
//        }
//    }];
    
}


-(NSString *)if24HourTime:(NSString *)time
{
    NSString *currentTimeStr = nil;
    
    self.dateFormatter=[[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *currentTime = [self.dateFormatter dateFromString:time];
    
    if (currentTime!=nil)
    {
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        currentTimeStr = [self.dateFormatter stringFromDate:[NSDate date]];
        
        return currentTimeStr;
        
    } else {
        
        return  time;
    }
    
}



@end
