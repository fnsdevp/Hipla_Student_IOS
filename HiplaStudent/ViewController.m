//
//  ViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 12/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    api = [APIManager sharedManager];
    
//    self.locationManager = [[CLLocationManager alloc] init];
//
//    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//
//        [self.locationManager requestAlwaysAuthorization];
//    }
//
//    self.locationManager.delegate = self;
//
//    [self.locationManager startUpdatingLocation];
//    [self.locationManager startUpdatingHeading];
    
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}
    
-(BOOL) NSStringIsValidEmail:(NSString *)emailString{
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
