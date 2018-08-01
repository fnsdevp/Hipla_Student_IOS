//
//  LoginViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LoginViewController : ViewController<UITextFieldDelegate>
{
    NSArray *productCategory;
    NSString *deviceId;
    NSString *sessionIdStr;
}
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
    
- (IBAction)btnLogin:(id)sender;

@end
