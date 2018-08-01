//
//  RoutineViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 13/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "RoutineViewController.h"
#import "RoutineTableViewCell.h"
#import "RoutineCollectionViewCell.h"

@interface RoutineViewController (){
    
        
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
        NSString *fdate;
        NSString *sdate;
        NSString *hr;
        NSString *min;
        NSString *per;
        
        NSString *daySel;
        NSString *monthSel;
        NSString *yearSel;
        
        NSString *fDateSel;
        NSString *sDateSel;
        NSString *phone;
        NSArray *venues;
        
        NSMutableArray *arrTimes;
        NSMutableArray *arrIndex;
    
        NSDictionary *userInfo;

}

@property (nonatomic, strong) NSMutableArray *routineArr;
@property (nonatomic, strong) NSArray *userRoutineInfo;

@end


@implementation RoutineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    NSLog(@"viewDidLoad:%@",self);
    
    fdate = @"";
    sdate = @"";
    fromTime = @"";
    toTime = @"";
    
    arrTimes = [[NSMutableArray alloc] init];
    
    self.currentDate = [NSDate date];
    self.dateFormatter=[[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [self.dateFormatter setLocale:locale];
    
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    
    fdate = [self.dateFormatter stringFromDate:self.currentDate];
    sdate = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(24*60*60)]];
    
    selectedDate = fdate;
    
    initialDate = [self.dateFormatter dateFromString:fdate];
    
    [self.collectionViewDates registerNib:[UINib nibWithNibName:@"RoutineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RoutineCollectionViewCell"];
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    self.routineArr = [[NSMutableArray alloc] init];
    
    //db = [Database getDatabase];
    
   // self.userInfoDict = [NSDictionary dictionaryWithDictionary:[Userdefaults objectForKey:@"userInfo"]];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.currentDateStr = [self.dateFormatter stringFromDate:self.currentDate];
    
    [self RoutineWithDetails:self.currentDateStr];
    
    self.userInfoDict = (NSDictionary *)[Userdefaults objectForKey:@"userInfoDictLocal"];
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
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
        
       // [[ZoneDetection sharedZoneDetection] setDelegate:self];
        
    }
     */
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.routineArr count]>0) {
        
        return  [self.routineArr count];
        
    }
    else{
        
        return  0;
        
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"RoutineTableViewCell";
    
    RoutineTableViewCell *cell = (RoutineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RoutineTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }

    cell.viewSubject.layer.borderColor = [UIColor colorWithHexString:@"#ececec"].CGColor;
    cell.viewSubject.layer.borderWidth = 1.0;
    cell.viewSubject.layer.cornerRadius = 5.0;
    
    if ([self.routineArr count]>0) {
        
        NSDictionary *dict = [self.routineArr objectAtIndex:indexPath.row];
        
        cell.lblName.text=[NSString stringWithFormat:@"%@",[[dict objectForKey:@"teacher_details"] objectForKey:@"name"]];
        cell.lblStartTime.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"startTime"]];
        cell.lblEndTime.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"endTime"]];
        cell.lblSubject.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"subject_name"]];
        
        self.roomName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"room_id"]];
        
        [cell.btnStart setTitleColor:[UIColor colorWithHexString:@"#586669"] forState:UIControlStateNormal];
        
        [cell.btnEnd setTitleColor:[UIColor colorWithHexString:@"#586669"] forState:UIControlStateNormal];
        
        
        
        //blue - #308AD2
        
        //grey - #586669
        
    }
    else{
        
        cell.lblName.text=@"";
        cell.lblStartTime.text=@"";
        cell.lblEndTime.text=@"";
        cell.lblSubject.text=@"";
    }
    
    [cell.btnNavigation addTarget:nil action:@selector(btnNav:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.routineArr objectAtIndex:indexPath.row];
    
    if (self.userInfoDict!=nil)
    {
        NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[self.userInfoDict objectForKey:@"routine_history_id"] integerValue]];
        
        NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[dict objectForKey:@"routine_history_id"] integerValue]];
        
        if ([routineId isEqualToString:routine_history_id])
        {
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
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry, this class is not running currently."
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  
                                                                                  
                                                                                  
                                                                              }];
                        
                        [alert addAction:defaultAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
                }
            }
            
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry, this class is not running currently."
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      
                                                                      
                                                                  }];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
    }
    else
    {
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *currentTimeStr = [self.dateFormatter stringFromDate:self.currentDate];
        
        [self getCurrentRoutine:currentTimeStr withDict:dict];
    }
    
}

-(IBAction)btnNav:(id)sender
{
    [self gotoClass];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSArray *)setTheDate:(NSDate *)Date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [calendar startOfDayForDate:Date];
    
    NSLog(@"%@", startDate);
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss YYYY"];
    NSString *startDateStr = [format stringFromDate:startDate];
    
    NSArray *dateArr = [startDateStr componentsSeparatedByString:@" "];
    
    return dateArr;
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
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *outTime = [dateFormatter stringFromDate:currentDate];
    
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

//- (void) navigationTick: (NSTimer *)timer
- (void)navigationTicker{
    
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

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
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
    
    static NSString *identifier = @"RoutineCollectionViewCell";
    
    RoutineCollectionViewCell *cell1 = (RoutineCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell1.tag = indexPath.item;
    cell1.btnDate.tag = indexPath.item;
    cell1.delegate = self;
    
    
    if (isSelectedDate) {
        
        if (indexPath.item==0) {
            
            nextday = initialDate;
        }
        else
        {
            nextday = initialDate;
            
            nextday = [NSDate dateWithTimeInterval:((indexPath.item)*(24*60*60)) sinceDate:nextday];
        }
        
        NSLog(@"%@",nextday);
        NSLog(@"%d",(int)cell1.tag);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"EEE"];
        
        day = [df stringFromDate:nextday];
        
        cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
        
        [df setDateFormat:@"yyyy-MM-dd"];
        
        date = [df stringFromDate:nextday];
        
        cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
        
        if (seletedTag == cell1.tag) {
            
            [cell1.btnDate  setSelected:YES];
            
            cell1.backVW.backgroundColor = [UIColor whiteColor];
            cell1.backVW.layer.borderWidth = 1.0;
            cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
            
            cell1.line.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [cell1.btnDate  setSelected:NO];
            
            cell1.backVW.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            cell1.backVW.layer.borderWidth = 1.0;
            cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
            
            cell1.line.backgroundColor = [UIColor whiteColor];
            
        }
        
    } else {
        
        if (indexPath.item==0) {
            
            nextday = [NSDate date];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            [df setDateFormat:@"EEE"];
            
            day = [df stringFromDate:nextday];
            
            cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
            
            [df setDateFormat:@"yyyy-MM-dd"];
            
            date = [df stringFromDate:nextday];
            
            cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
            
        }
        else
        {
            nextday = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextday];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            [df setDateFormat:@"EEE"];
            
            day = [df stringFromDate:nextday];
            
            cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
            
            [df setDateFormat:@"yyyy-MM-dd"];
            
            date = [df stringFromDate:nextday];
            
            cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
            
        }
        
        [cell1.btnDate  setSelected:NO];
        
        seletedTag = (int)indexPath.row;
        
        if (indexPath.row == 0) {
            
            [cell1.btnDate  setSelected:YES];
            
            cell1.backVW.backgroundColor = [UIColor whiteColor];
            cell1.backVW.layer.borderWidth = 1.0;
            cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
            
            cell1.line.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [cell1.btnDate  setSelected:NO];
            
            cell1.backVW.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            cell1.backVW.layer.borderWidth = 1.0;
            cell1.backVW.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
            
            cell1.line.backgroundColor = [UIColor whiteColor];
        }
    }
    
    return cell1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoutineCollectionViewCell *cell1 = (RoutineCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell1.delegate = self;
    
}


#pragma Mark - MeetingFormCollectionViewCellDelegate

- (void)dateCellTap:(id)sender {
    
    RoutineCollectionViewCell* cell = (RoutineCollectionViewCell *)sender;
    
    UIButton* btn = cell.btnDate;
    
    seletedTag = (int)btn.tag;
    
    if ([btn isSelected]) {
        
        [btn setSelected:NO];
        
        cell.backVW.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        cell.backVW.layer.borderWidth = 1.0;
        cell.backVW.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
        
        cell.line.backgroundColor = [UIColor whiteColor];
        
        isSelectedDate = NO;
        
    }
    else
    {
        [btn setSelected:YES];
        
        cell.backVW.backgroundColor = [UIColor whiteColor];
        cell.backVW.layer.borderWidth = 1.0;
        cell.backVW.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
        
        cell.line.backgroundColor = [UIColor whiteColor];
        
        isSelectedDate = YES;
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dtSelected = [NSDate dateWithTimeInterval:(seletedTag*(24*60*60)) sinceDate:[NSDate date]];
        
        NSString *currentDateStr = [dt stringFromDate:dtSelected];
        
        [self RoutineWithDetails:currentDateStr];
        
    }
}

-(void)endLocalNotificationforRoutineCall:(NSString *)className withSection:(NSString *)section withPeriodDate:(NSString *)Date withPeriodTime:(NSString *)endTime andId:(NSString *)routineHistoryId withDetails:(NSDictionary *)dictRoutine{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *fireDateime = [NSString stringWithFormat:@"%@ %@",Date,endTime];
    
    NSDate *SetAlarmAt = [dateFormatter dateFromString:fireDateime];
    
    NSString *str1 = [NSString stringWithFormat:@"Your %@-%@ ended today on %@.",className,section,endTime];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = SetAlarmAt;
    notification.alertBody = str1;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    
    notification.userInfo = dictRoutine;
    
    notification.repeatInterval=0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
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
            
            if ([successStr isEqualToString:@"success"]) {
                
                if ([[dict allKeys] containsObject:@"user_routine"])
                {
                    self.userRoutineInfo = [NSArray arrayWithArray:[dict objectForKey:@"user_routine"]];
                    
                    if ([self.userRoutineInfo count]>0) {
                        
                        NSDictionary *dict2 = [NSDictionary dictionaryWithDictionary:[self.userRoutineInfo objectAtIndex:0]];
                        
                        NSDictionary *ProfDict = [dict2 dictionaryByReplacingNullsWithBlanks];
                        
                        NSArray *arrRoutine = [NSArray arrayWithArray:[ProfDict objectForKey:@"routine"]];
                        
                        NSLog(@"ARR=====%@",arrRoutine);
                        
                        self.routineArr = [NSMutableArray arrayWithArray:arrRoutine];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_tblVwRoutines reloadData];
                            
                        });
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_collectionViewDates reloadData];
                        
                    });
                }
                else
                {
                    self.routineArr = [[NSMutableArray alloc]init];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_tblVwRoutines reloadData];
                        
                        [_collectionViewDates reloadData];
                        
                    });
                    
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
                    
                    NSDate* currentDate = [NSDate date];
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    
                    NSString *outTime = [dateFormatter stringFromDate:currentDate];
                    
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


-(void)getCurrentRoutine:(NSString *)timeStr withDict:(NSDictionary *)Dict
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&usertype=teacher&time=%@",userId,timeStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"routine_details_by_time.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                [SVProgressHUD dismiss];
                
                NSArray *arrUser = [dict objectForKey:@"user_routine"];
                
                NSDictionary *UserRoutineDict = [arrUser objectAtIndex:0];
                
                NSArray *arrRoutine = [UserRoutineDict objectForKey:@"routine"];
                
                NSDictionary *routineDict = [arrRoutine objectAtIndex:0];
                
                self.userInfoDict = routineDict;
                
                if (self.userInfoDict!=nil) {
                    
                    [Userdefaults setObject:self.userInfoDict forKey:@"userInfoDictLocal"];
                    
                    [Userdefaults synchronize];
                    
                    NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[self.userInfoDict objectForKey:@"routine_history_id"] integerValue]];
                    
                    NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[Dict objectForKey:@"routine_history_id"] integerValue]];
                    
                    if ([routineId isEqualToString:routine_history_id])
                    {
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
                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry, this class is not running currently."
                                                                                                   message:nil
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action) {
                                                                                              
                                                                                              
                                                                                              
                                                                                          }];
                                    
                                    [alert addAction:defaultAction];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                }
                            }
                        }
                        
                    }
                    else
                    {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry, this class is not running currently."
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  
                                                                                  
                                                                                  
                                                                              }];
                        
                        [alert addAction:defaultAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        
                    }
                    
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry, this class is not running currently."
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              
                                                                              
                                                                              
                                                                          }];
                    
                    [alert addAction:defaultAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
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


-(void)gotoClass
{
    NavigationViewController *navScreen = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil];
    
    navScreen.className = self.roomName;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:navScreen animated:YES];
        
    });
    
 //   [self.navigationController pushViewController:navScreen animated:YES];
    
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:navScreen];
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

@end
