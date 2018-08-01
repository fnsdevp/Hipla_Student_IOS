//
//  OTPViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "OTPViewController.h"
#import "ProfileViewController.h"
#import "Constants.h"

@interface OTPViewController ()

@end


@implementation OTPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _viewOTP.layer.cornerRadius = 10.0f;
    _viewOTP.clipsToBounds = YES;
    _viewOTP.layer.borderWidth = 2.0f;
    _viewOTP.layer.borderColor=[UIColor greenColor].CGColor;
    
    api = [APIManager sharedManager];
    deviceId = [Utils deviceUUID];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- TextField Validation

-(BOOL) notEmptyChecking{
    
    if([_txtOTP.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtOTP becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnClick:(id)sender {
    
    [self LoginWithDetails];
}

- (IBAction)btnOK:(id)sender {
    
    [self OTPWithDetails];
    
   // [self gotoProfile];
    
}


-(void)OTPWithDetails
{
    if([self notEmptyChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Utils deviceToken];
    
    NSString *userUpdate = [NSString stringWithFormat:@"otp=%@&device_id=%@&session_id=%@&device_type=Ios&device_token=%@",[NSString stringWithFormat:@"%@",self.txtOTP.text],deviceId,_sessionIdStr,deviceToken];
    
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"studentOtpVerification.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                if ([[dict allKeys] containsObject:@"message"]) {
                    
                    NSString *messageStr = [dict objectForKey:@"message"];
                    
                    if ([messageStr containsString:@"Please try again"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again, you have entered wrong OTP."
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            [SVProgressHUD dismiss];
                            
                        });
                        
                    } else {
                        
                        userType = [dict objectForKey:@"usertype"];
                        
                        NSDictionary *userDetails = [[dict objectForKey:@"user_details"] objectAtIndex:0];
                        
                        NSDictionary *userDetails1 = [userDetails dictionaryByReplacingNullsWithBlanks];
                        
                        [Userdefaults setObject:userDetails1 forKey:@"ProfInfo"];
                        [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
                        [Userdefaults setObject:userType forKey:@"userType"];
                        [Userdefaults synchronize];
                        
                        [self gotoProfile];
                    }
                    
                } else {
                    
                    userType = [dict objectForKey:@"usertype"];
                    
                    NSDictionary *userDetails = [[dict objectForKey:@"user_details"] objectAtIndex:0];
                    
                    NSDictionary *userDetails1 = [userDetails dictionaryByReplacingNullsWithBlanks];
                    
                    [Userdefaults setObject:userDetails1 forKey:@"ProfInfo"];
                    [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
                    [Userdefaults setObject:userType forKey:@"userType"];
                    [Userdefaults synchronize];
                    
                    [self gotoProfile];
                    
                }
                
            }
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
            
            
        }
        
    }];
    
}

-(void)LoginWithDetails
{
    if([self notEmptyChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Utils deviceToken];
    NSString *deviceUDID = [Utils deviceUUID];
    
    NSString *userUpdate = [NSString stringWithFormat:@"username=%@&device_token=%@&device_id=%@&device_type=ios",[NSString stringWithFormat:@"%@", self.txtEmailStr], deviceToken, deviceUDID];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"loginTeacher.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                _sessionIdStr = [dict objectForKey:@"session_id"];
                
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
    
    [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
    [Userdefaults synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
}


@end
