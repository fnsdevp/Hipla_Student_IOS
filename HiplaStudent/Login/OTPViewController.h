//
//  OTPViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYDrawerController.h"
#import "NSDictionary+NullReplacement.h"

@interface OTPViewController : UIViewController<UITextFieldDelegate,KYDrawerControllerDelegate>
{
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    APIManager *api;
    UINavigationController *localNavigationController;
    
    NSString *userType;
    NSString *deviceId;
}
- (IBAction)btnOK:(id)sender;
- (IBAction)btnClick:(id)sender;

@property (weak, nonatomic) NSString *sessionIdStr;
@property (weak, nonatomic) IBOutlet UIView *viewOTP;
@property (weak, nonatomic) IBOutlet UITextField *txtOTP;
@property (weak, nonatomic) KYDrawerController *elDrawer;
@property (weak, nonatomic) NSString *txtEmailStr;


@end
