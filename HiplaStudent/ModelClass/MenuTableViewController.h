//
//  MenuTableViewController.h
//  HiplaStudent
//
//  Created by fnspl3 on 18/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewCell.h"
#import "KYDrawerController.h"
#import "NavigationViewController.h"

@interface MenuTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
    
    NSDictionary *userInfo;
    NSString *userName;
}
@property (weak,nonatomic) IBOutlet UITableView *tblMenu;
@property (retain, nonatomic) NSArray *browseListArray;
@property (retain, nonatomic) NSArray *browseimageArray;

@property (retain, nonatomic) NSArray *forUArray;
@property (retain, nonatomic) NSArray *forUimageArray;
@property (weak, nonatomic) IBOutlet UIImageView *ProfimgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

- (IBAction)btnProfile:(id)sender;

@property (weak, nonatomic) KYDrawerController *elDrawer;

@end
