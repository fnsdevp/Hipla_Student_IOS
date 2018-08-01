//
//  ManualAttendenceViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 24/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ManualAttendenceViewController.h"

@interface ManualAttendenceViewController ()

@end


@implementation ManualAttendenceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
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
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        
        if ([zoneName isEqualToString:@"conference area"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.btnManual.enabled = YES;
            });
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.btnManual.enabled = YES;
            });
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.btnManual.enabled = YES;
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
                
                self.btnManual.enabled = NO;
            });
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kindly present in class."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.btnManual.enabled = NO;
            });
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kindly present in class."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.btnManual.enabled = NO;
            });
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kindly present in class."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
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

- (void)navigationTicker {
    
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


-(IBAction)sendManual:(id)sender
{
    NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
    
    self.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    if ([routineArr count]>0) {
        
        int class = 0;
        
        for (NSDictionary *routineDict in routineArr) {
            
            NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[self.userInfoDict objectForKey:@"routine_history_id"] integerValue]];
            
            NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
            
            class ++;
            
            if ([routineId isEqualToString:routine_history_id]) {
                
                [self manualAttendence:routineDict];
            }
        }
    }
    
}


-(void)manualAttendence:(NSDictionary *)dict
{
    [SVProgressHUD show];
    
    NSString *routine_history_id = [dict objectForKey:@"routine_history_id"];
    
    NSString *teacher_id = [[dict objectForKey:@"teacher_details"] objectForKey:@"id"];
    
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    NSString *student_id = userId;
    
    NSString *in_time = [dict objectForKey:@"startTime"];
    
    NSString *userUpdate = [NSString stringWithFormat:@"routine_history_id=%@&teacher_id=%@&student_id=%@&in_time=%@&attendance_type=manual&present=N",routine_history_id,teacher_id,student_id,in_time];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"student_attend.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                [self gotoProfile];
                
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


-(void)gotoCongratulation
{
    SuccessAttendenceViewController *confirmScreen = [[SuccessAttendenceViewController alloc]initWithNibName:@"SuccessAttendenceViewController" bundle:nil];
    
    confirmScreen.userInfoDict = self.userInfoDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:confirmScreen animated:YES];
        
    });
    
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:confirmScreen];
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
    
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
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
