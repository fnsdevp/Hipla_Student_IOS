//
//  LoginViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "LoginViewController.h"
#import "OTPViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewEmail.layer.cornerRadius = 10.0f;
    _viewEmail.clipsToBounds = YES;
    _viewEmail.layer.borderWidth = 2.0f;
    _viewEmail.layer.borderColor=[UIColor greenColor].CGColor;
    
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
    
    if([_txtEmail.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}
    
-(BOOL) validityChecking:(UITextField *) textField{
    
    BOOL validEmail = [Utils isEmailAddress:_txtEmail.text];
    
    if(validEmail == NO){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide a valid email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [_txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}


- (IBAction)btnLogin:(id)sender {
    
    [self LoginWithDetails];
    
   // [self gotoOTP];
    
}


-(void)LoginWithDetails
{
    if([self notEmptyChecking] == NO){return;}
    
    [SVProgressHUD show];
        
    NSString *deviceToken = [Utils deviceToken];
        
    NSString *userUpdate = [NSString stringWithFormat:@"username=%@&device_id=%@&device_type=Ios&device_token=%@",[NSString stringWithFormat:@"%@",self.txtEmail.text],deviceId,deviceToken];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
        
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"loginStudent.php" completion:^(NSDictionary * dict, NSError *error) {
        
            [SVProgressHUD dismiss];
            
            NSLog(@"%@",dict);
            
            NSLog(@"%@",error);
            
            if (!error) {
                
                NSString *successStr = [dict objectForKey:@"status"];
                
                if ([successStr isEqualToString:@"success"]) {
                    
                    sessionIdStr = [dict objectForKey:@"session_id"];
                    
                    [self gotoOTP];
                        
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"This mobile number doesnot exist as a Student."
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                        [SVProgressHUD dismiss];
                        
                    });
                    
                }
                    
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
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

    
-(void)gotoOTP
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        OTPViewController *otpScreen = [[OTPViewController alloc]initWithNibName:@"OTPViewController" bundle:nil];
//
//        otpScreen.sessionIdStr = sessionIdStr;
//        otpScreen.txtEmailStr = self.txtEmail.text;
//
//        [self.navigationController pushViewController:otpScreen animated:YES];
//
//    });
    
    
    OTPViewController *otpScreen = [[OTPViewController alloc]initWithNibName:@"OTPViewController" bundle:nil];
    
    [self.navigationController pushViewController:otpScreen animated:YES];
    
    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];

    otpScreen.sessionIdStr = sessionIdStr;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        otpScreen.txtEmailStr = self.txtEmail.text;
    });

    [menu setElDrawer:drawer];

    localNavigationController = [[UINavigationController alloc] initWithRootViewController:otpScreen];

    drawer.mainViewController = localNavigationController;

    drawer.drawerViewController = menu;

    /* Customize */
    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    drawer.drawerWidth = 5*(SCREENWIDTH/8);

    dispatch_async(dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
}

    
@end
