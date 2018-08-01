//
//  ReportViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 16/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ReportViewController.h"
#import "NSMutableArray+TTMutableArray.h"

@interface ReportViewController (){
    
    NSArray *hours;
    UIView *navView;
    bool firstDate;
    bool secondDate;
    
    NSString *userId;
    NSString *department;
    NSString *designation;
    NSString *fromTime;
    NSString *toTime;
    NSString *duration;
    NSString *agenda;
    NSString *hr;
    NSString *min;
    NSString *per;
    
    NSString *daySel;
    NSString *monthSel;
    NSString *yearSel;
    
    NSString *phone;
    NSArray *venues;
    
    NSMutableArray *arrTimes;
    NSMutableArray *arrIndex;
}

@end


@implementation ReportViewController

- (void)loadBarChatView
{
//    [super loadView];
    
    __barColors = @[[UIColor blueColor], [UIColor redColor], [UIColor blackColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor colorWithHexString:@"#00AF54"]];
    
    _currentBarColor = 5;
    
    _chart = [[SimpleBarChart alloc] initWithFrame:CGRectMake(10.0, 10.0, (self.chartView.frame.size.width - 20), (self.chartView.frame.size.height - 10))];
    
//    _chart.center = CGPointMake(self.chartView.frame.size.width / 2.0, self.chartView.frame.size.height / 2.0);
    
    _chart.delegate                  = self;
    _chart.dataSource                = self;
    _chart.barShadowOffset           = CGSizeMake(2.0, 1.0);
    _chart.animationDuration         = 1.0;
    _chart.barShadowColor            = [UIColor lightGrayColor];
    _chart.barShadowAlpha            = 0.5;
    _chart.barShadowRadius           = 1.0;
    _chart.barWidth                  = 18.0;
    _chart.xLabelType                = SimpleBarChartXLabelTypeVerticle;
    _chart.incrementValue            = 10;
    _chart.barTextType               = SimpleBarChartBarTextTypeTop;
    _chart.barTextColor              = [UIColor blueColor];
    _chart.gridColor                 = [UIColor lightGrayColor];
    
    [_chart setBackgroundColor:[UIColor clearColor]];
    
    [self.chartView addSubview:_chart];
    
    [_chart reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self.navigationController.navigationBar setHidden:YES];
    
    NSLog(@"viewDidLoad:%@",self);
    
    _Values = [NSArray arrayWithObjects:@"0", @"10", @"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90", @"100", @"110", nil];
    
    _Months = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    
    _MonthsValues = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    
    fromTime = @"";
    toTime = @"";
    
    arrTimes = [[NSMutableArray alloc] init];
    
    self.currentDate = [NSDate date];
    self.dateFormatter=[[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [self.dateFormatter setLocale:locale];
    
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    
    self.userInfoDict = [Userdefaults objectForKey:@"userInfo"];
    
    self.subjectList = [[NSMutableArray alloc] init];
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    [self.collectionViewDates registerNib:[UINib nibWithNibName:@"ReportCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReportCollectionViewCell"];
    
    [self performSelector:@selector(loadBarChatView) withObject:nil afterDelay:0.3];
    
    [self SubjectList:userId];
    
    /*

    if (!_navigineCore) {
        
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
        
    }
     */
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _navigineCore = nil;
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (_zoneTimer) {
    //
    //            [_zoneTimer invalidate];
    //            _zoneTimer = nil;
    //        }
    //    });
    
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
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
                    
                    [self getCurrentRoutineForSneak:outTime];
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
                    
                    [self getCurrentRoutineForSneak:outTime];
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
                    
                    [self getCurrentRoutineForSneak:outTime];
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

//- (void) navigationTick: (NSTimer *)timer {
- (void)navigationTicker {
    
  //  NCDeviceInfo *res = _navigineCore.deviceInfo;
    
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
    
//    [self performSelector:@selector(navigationTick:) withObject:nil afterDelay:1.0];
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
                    
                    [self.dateFormatter setDateFormat:@"hh:mm a"];
                    
                    NSString *outTime = [self.dateFormatter stringFromDate:self.currentDate];
                    
                    [self sneakAttendence:UserInfoDict currentTime:outTime];
                    
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


#pragma mark SimpleBarChartDataSource

- (NSUInteger)numberOfBarsInBarChart:(SimpleBarChart *)barChart
{
    return _Values.count;
}

- (CGFloat)barChart:(SimpleBarChart *)barChart valueForBarAtIndex:(NSUInteger)index
{
    return [[_Values objectAtIndex:index] floatValue];
}

- (NSString *)barChart:(SimpleBarChart *)barChart textForBarAtIndex:(NSUInteger)index
{
    return [_MonthsValues objectAtIndex:index];
}

- (NSString *)barChart:(SimpleBarChart *)barChart xLabelForBarAtIndex:(NSUInteger)index
{
    return [_Months objectAtIndex:index];
}

- (UIColor *)barChart:(SimpleBarChart *)barChart colorForBarAtIndex:(NSUInteger)index
{
    return [__barColors objectAtIndex:_currentBarColor];
}



#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.subjectList count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (SCREENHEIGHT == 568.0) {
        
        return CGSizeMake(72, 85);
    }
    else if (SCREENHEIGHT == 667.0) {
        
        return CGSizeMake(82, 85);
    }
    else if (SCREENHEIGHT == 736.0) {
        
        return CGSizeMake(90, 85);
    }
    else {
        
        return CGSizeMake(90, 85);
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ReportCollectionViewCell";
    
    ReportCollectionViewCell *cell1 = (ReportCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell1.tag = indexPath.item;
    
    if (seletedTag == cell1.tag) {
        
        cell1.backVW.backgroundColor = [UIColor whiteColor];
        cell1.backVW.layer.borderWidth = 1.0;
        cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
        
        cell1.line.backgroundColor = [UIColor whiteColor];
        
        cell1.lblSubject.text = [[self.subjectList objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else
    {
        cell1.backVW.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        cell1.backVW.layer.borderWidth = 1.0;
        cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
        
        cell1.line.backgroundColor = [UIColor whiteColor];
        
        cell1.lblSubject.text = [[self.subjectList objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    
    return cell1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCollectionViewCell *cell1 = (ReportCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell1.backVW.backgroundColor = [UIColor whiteColor];
    cell1.backVW.layer.borderWidth = 1.0;
    cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
    
    cell1.line.backgroundColor = [UIColor whiteColor];
    
    seletedTag = (int)indexPath.row;
    
    NSString *subjectIdStr = [NSString stringWithFormat:@"%d",(int)[[[self.subjectList objectAtIndex:seletedTag] objectForKey:@"subject_id"] integerValue]];
    
    [self ReportByStudent:userId withsubject:subjectIdStr];
    
}

-(void)SubjectList:(NSString *)studentId
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"student_id=%@",studentId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"all_subject.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                self.subjectList = [dict objectForKey:@"subject"];
                
                NSString *subjectIdStr = [NSString stringWithFormat:@"%@",[[self.subjectList objectAtIndex:0] objectForKey:@"subject_id"]];
                
                [self ReportByStudent:userId withsubject:subjectIdStr];
                
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
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with internet, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
    
}


-(void)ReportByStudent:(NSString *)studentId withsubject:(NSString *)subjectId
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"student_id=%@&subject_id=%@",studentId,subjectId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"student_attendance_report.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                if ([[dict allKeys] containsObject:@"message"]) {
                    
                   NSString *msgStr = [dict objectForKey:@"message"];
                    
                    if (![msgStr containsString:@"Not matched.please try again!"]) {
                        
                        NSMutableArray *listArr = [dict objectForKey:@"list"];
                        
                        _MonthsValues = [[NSMutableArray alloc] init];
                        
                        for (NSString *monthstr in _Months) {
                            
                            [self.dateFormatter setDateFormat:@"MMMM"];
                            
                            NSString *stringFromDate = [self.dateFormatter stringFromDate:self.currentDate];
                            
                            if ([stringFromDate containsString:monthstr]) {
                                
                                NSString *strTotal = [NSString stringWithFormat:@"%d",(int)[[[listArr objectAtIndex:0] objectForKey:@"TotalClass"] integerValue]];
                                
                                NSString *strCurrent = [NSString stringWithFormat:@"%d",(int)[[[listArr objectAtIndex:0] objectForKey:@"getPresentValue"] integerValue]];
                                
                                float precentage = (100 * [strCurrent integerValue])/[strTotal integerValue];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    self.percentagelbl.text = [NSString stringWithFormat:@"%d %%",(int)precentage];
                                    
                                    self.percentagelbl.textColor = [UIColor colorWithHexString:@"#00AF54"];
                                    
                                });
                                
                                NSString *str = [NSString stringWithFormat:@"%d",(int)precentage];
                                
                                [_MonthsValues addObject:str];
                                
                                
                            } else {
                                
                                [_MonthsValues addObject:@"0"];
                            }
                        }
                        
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_chart reloadData];
                    
                    [self.collectionViewDates reloadData];
                    
                });
                
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
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
    
}


@end
