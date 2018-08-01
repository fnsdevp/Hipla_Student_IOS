//
//  MenuTableViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 18/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "MenuTableViewController.h"
#import "KYDrawerController.h"
#import "MenuTableViewCell.h"
#import "RoutineViewController.h"
#import "ReportViewController.h"

@interface MenuTableViewController ()

@end


@implementation MenuTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
//    _browseListArray = [[NSArray alloc]initWithObjects:@"BABY",@"BAKING",@"BREAKFAST",@"DRINK",@"HEALTH",@"FRUIT",@"VEGETABLES",nil];
//    _browseimageArray = [[NSArray alloc]initWithObjects:@"avocado.png",@"avocado.png",@"avocado.png",@"avocado.png",@"avocado.png",@"avocado.png",@"avocado.png",nil];
    
    _forUArray = [[NSArray alloc]initWithObjects:@"Routine",@"Attendence Report",@"Path Finder",nil];
    
    _forUimageArray = [[NSArray alloc]initWithObjects:@"routine",@"report",@"navigation",nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePopNotification:)
                                                 name:@"PopVC"
                                               object:nil];
}
    
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userName= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    
    _lblName.text = [NSString stringWithFormat:@"%@",userName];
    
    NSString *ImageURL = [NSString stringWithFormat:@"http://cxc.gohipla.com/education/admin/apps/webcam/%@",[userInfo objectForKey:@"photo"]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    self.ProfimgView.image = [UIImage imageWithData:imageData];
    
    self.ProfimgView.layer.cornerRadius = self.ProfimgView.frame.size.width/2;
    self.ProfimgView.layer.masksToBounds = YES;
    self.ProfimgView.contentMode = UIViewContentModeScaleAspectFill;
    
}

-(void)receivePopNotification:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"PopVC"]) {
        {
            KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
            });
            
            // ProfileViewController *profileViewScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            
            // [self.navigationController pushViewController:profileViewScreen animated:YES];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return [_forUArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"menuCellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if(cell==nil){
        
        //    cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    //    [cell.contentView setBackgroundColor:[UIColor blueColor]];
    //    cell.lblTitle.text = @"menu";
    
        cell.imgView.image= [UIImage imageNamed:[_forUimageArray objectAtIndex:indexPath.row]];
        cell.lblName.text = [_forUArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    
    //    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
    //    ProductCategoryViewController *viewController = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
    
    //    SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
    //    [_elDrawer goToTargetViewController:cartViewScreen];
    
    //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    
        switch ([newIndexPath row]) {
                
            case 0:{
                
                RoutineViewController *RoutineViewScreen = [[RoutineViewController alloc]initWithNibName:@"RoutineViewController" bundle:nil];
            
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_elDrawer goToTargetViewController:RoutineViewScreen];
                });
                
                break;
            }
                
            case 1:{
                
                ReportViewController *ReportViewScreen = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_elDrawer goToTargetViewController:ReportViewScreen];
                });
                
                break;
            }
                
            case 2:{
                
                NavigationViewController *NavViewScreen = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_elDrawer goToTargetViewController:NavViewScreen];
                });
                
                break;
            }
                
            default:
                break;
                
        }
        

    
    //    _elDrawer.mainViewController = navController;
    
    //    [_elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnProfile:(id)sender {
    
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
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });
    
    //  ProfileViewController *profViewScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
    //  [_elDrawer goToTargetViewController:profViewScreen];
    
    //    [[NSNotificationCenter defaultCenter]
    //     postNotificationName:@"PopVC"
    //     object:self];
    
}


@end
