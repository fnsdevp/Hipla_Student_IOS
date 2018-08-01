//
//  SelfiViewController.m
//  HiplaStudent
//
//  Created by fnspl3 on 23/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "SelfiViewController.h"

@interface MPODetectionFaceObject : NSObject

@property (nonatomic, strong) UIImage *croppedFaceImage;
@property (nonatomic, strong) NSString *genderText;
@property (nonatomic, strong) NSString *ageText;
@property (nonatomic, strong) NSString *hairText;
@property (nonatomic, strong) NSString *facialHairText;
@property (nonatomic, strong) NSString *makeupText;
@property (nonatomic, strong) NSString *emotionText;
@property (nonatomic, strong) NSString *occlusionText;
@property (nonatomic, strong) NSString *exposureText;
@property (nonatomic, strong) NSString *headPoseText;
@property (nonatomic, strong) NSString *accessoriesText;

@end

@implementation MPODetectionFaceObject

@end

@interface SelfiViewController ()
{
    UIView * _imageContainer1;
    UIButton * _verifyBtn;
    UILabel * _personNameLabel;
    NSInteger _selectIndex;
    
    NSMutableArray * _faces0;
    NSMutableArray * _faces1;
    
    PersonGroup * _selectedGroup;
    GroupPerson * _selectedPerson;
}

@end


@implementation SelfiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad:%@",self);
    
    api = [APIManager sharedManager];
    userInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    
    _viewTakeImage.layer.cornerRadius = 5.0f;
    _viewTakeImage.clipsToBounds = YES;
    
    _viewSubmit.layer.cornerRadius = 5.0f;
    _viewSubmit.clipsToBounds = YES;
    
    _viewSelfie.layer.borderWidth = 2.0f;
    _viewSelfie.layer.borderColor=[UIColor colorWithHexString:@"#B7B7B7"].CGColor;
    
    self.detectionFaces = [[NSMutableArray alloc] init];
    
    _faces0 = [[NSMutableArray alloc] init];
    _faces1 = [[NSMutableArray alloc] init];
    
    [self.viewSubmit setBackgroundColor:[UIColor grayColor]];
    
    self.btnSubmit.enabled = NO;
    
    [self.viewTakeImage setBackgroundColor:[UIColor grayColor]];
    
    self.btnTakeImage.enabled = NO;
    
    _selectedGroup = nil;
    _selectedPerson = nil;
    
    [self previousUserImage];
   
    /*
    
    if (!_navigineCore)
    {
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
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}

- (IBAction)btnBack:(id)sender {
    
    ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    
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
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewSubmit setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnSubmit.enabled = YES;
                
                [self.viewTakeImage setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnTakeImage.enabled = YES;
                
            });
            
        }
        else if ([zoneName isEqualToString:@"conference room small"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewSubmit setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnSubmit.enabled = YES;
                
                [self.viewTakeImage setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnTakeImage.enabled = YES;
                
            });
            
        }
        else if ([zoneName isEqualToString:@"3"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewSubmit setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnSubmit.enabled = YES;
                
                [self.viewTakeImage setBackgroundColor:[UIColor colorWithHexString:@"#00BCEB"]];
                
                self.btnTakeImage.enabled = YES;
                
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
                
                [self.viewSubmit setBackgroundColor:[UIColor grayColor]];
                
                self.btnSubmit.enabled = NO;
                
                [self.viewTakeImage setBackgroundColor:[UIColor grayColor]];
                
                self.btnTakeImage.enabled = NO;
                
            });
            
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewSubmit setBackgroundColor:[UIColor grayColor]];
                
                self.btnSubmit.enabled = NO;
                
                [self.viewTakeImage setBackgroundColor:[UIColor grayColor]];
                
                self.btnTakeImage.enabled = NO;
                
            });
            
        }
        else if ([zoneName isEqualToString:@"3"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewSubmit setBackgroundColor:[UIColor grayColor]];
                
                self.btnSubmit.enabled = NO;
                
                [self.viewTakeImage setBackgroundColor:[UIColor grayColor]];
                
                self.btnTakeImage.enabled = NO;
                
            });
            
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



- (void)navigationTicker{
    
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
    
}

/*-------------------------------------Navigine--------------------------------------------*/

-(void)previousUserImage
{
    NSString *ImageURL = [NSString stringWithFormat:@"http://cxc.gohipla.com/education/admin/apps/webcam/%@",[userInfo objectForKey:@"photo"]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    UIImage *chosenImage = [UIImage imageWithData:imageData];
    
    NSMutableArray * faceArray = _faces1;
    
   // [SVProgressHUD showWithStatus:@"detecting faces"];
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:ProjectOxfordFaceEndpoint key:ProjectOxfordFaceSubscriptionKey];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.8);
    
    [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        if (error) {
            
           // [SVProgressHUD showWithStatus:@"detection failed"];
            
            return;
        }
        
        [faceArray removeAllObjects];
        
        for (MPOFace *face in collection) {
            
            UIImage *croppedImage = [chosenImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
            
            PersonFace * personFace = [[PersonFace alloc] init];
            personFace.image = croppedImage;
            personFace.face = face;
            
            [faceArray addObject:personFace];
            
        }
        
        _faces1 = faceArray;
        
        _verifyBtn.enabled = NO;
        
        if (collection.count == 0) {
            
          //  [SVProgressHUD showWithStatus:@"No face detected."];
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

- (IBAction)btnTakeImage:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.selfiImageVw.image = chosenImage;
    
    [chosenImage fixOrientation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray * faceArray =  _faces0;
    
    [SVProgressHUD showWithStatus:@"detecting faces"];
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:ProjectOxfordFaceEndpoint key:ProjectOxfordFaceSubscriptionKey];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.8);
    
    [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        if (error) {
            
            [SVProgressHUD showWithStatus:@"detection failed"];
            
            [SVProgressHUD dismissWithDelay:1.0];
            
            return;
        }
        
        [faceArray removeAllObjects];
        
        for (MPOFace *face in collection) {
            
            UIImage *croppedImage = [chosenImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
            
            PersonFace * personFace = [[PersonFace alloc] init];
            personFace.image = croppedImage;
            personFace.face = face;
            
            [faceArray addObject:personFace];
            
        }
        
        _faces0 = faceArray;
        
        _verifyBtn.enabled = NO;
        
        if (collection.count == 0) {
            
            [SVProgressHUD showWithStatus:@"No face detected."];
            
            [SVProgressHUD dismissWithDelay:1.0];
            
            self.selfiImageVw.image = nil;
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:@"UIImagePickerControllerOriginalImage"];
    
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error){
        
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
        
    }else{
        
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnSubmit:(id)sender
{
    if (self.selfiImageVw.image != nil)
    {
        [self authenticateImage];
    }
}

- (void)authenticateImage {
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:ProjectOxfordFaceEndpoint key:ProjectOxfordFaceSubscriptionKey];

    [SVProgressHUD showWithStatus:@"verifying faces"];
    
    void (^completionBlock)(MPOVerifyResult *, NSError *) = ^(MPOVerifyResult *verifyResult, NSError *error){
        
        [SVProgressHUD dismiss];
        
        if (error) {
            
            [SVProgressHUD showWithStatus:@"verification failed"];
            
            [SVProgressHUD dismissWithDelay:1.0];
            
            return;
        }
        
        if (verifyResult.isIdentical) {
            
           // NSString * message = nil;
            
            if (self.verificationType == VerificationTypeFaceAndFace)
            {
               // message = [NSString stringWithFormat:@"Two faces are from one person."];
                
               // message = [NSString stringWithFormat:@"Two faces are from one person. The confidence is %@.", verifyResult.confidence];
                
                NSMutableArray *routineArr = [[Common sharedCommonFetch] getDetailsofRoutine:nil];
                
                if ([routineArr count]>0) {
                    
                    int class = 0;
                    
                    for (NSDictionary *routineDict in routineArr) {
                        
                        self.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
                        
                        NSString *routineId = [NSString stringWithFormat:@"%d",(int)[[self.userInfoDict objectForKey:@"routine_history_id"] integerValue]];
                        
                        NSString *routine_history_id = [NSString stringWithFormat:@"%d",(int)[[routineDict objectForKey:@"routine_history_id"] integerValue]];
                        
                        class ++;
                        
                        if ([routineId isEqualToString:routine_history_id]) {
                            
                            [self manualAttendence:routineDict];
                            
                        }
                    }
                }
                
            }
            
            //[SVProgressHUD showWithStatus:message];
            
        } else {
            
           // NSString * message = nil;
            
            if (self.verificationType == VerificationTypeFaceAndFace)
            {
                //message = @"Two faces are not from one person.";
                
                [self gotoManualAttendence];
            }
            
           // [SVProgressHUD showWithStatus:message];
        }
    };
    
    PersonFace *firstSelectedFaceObject = _faces0[0];
    
    if (self.verificationType == VerificationTypeFaceAndFace)
    {
        PersonFace *secondSelectedFaceObject = _faces1[0];
        
        [client verifyWithFirstFaceId:firstSelectedFaceObject.face.faceId faceId2:secondSelectedFaceObject.face.faceId completionBlock:completionBlock];
        
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
    
    NSString *userUpdate = [NSString stringWithFormat:@"routine_history_id=%@&teacher_id=%@&student_id=%@&in_time=%@&attendance_type=auto&present=Y",routine_history_id,teacher_id,student_id,in_time];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"student_attend.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
               // [self gotoCongratulation];
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

-(void)gotoManualAttendence
{
    ManualAttendenceViewController *manualScreen = [[ManualAttendenceViewController alloc]initWithNibName:@"ManualAttendenceViewController" bundle:nil];
    
    self.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    manualScreen.userInfoDict = [Userdefaults objectForKey:@"userInfoDictLocal"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:manualScreen animated:YES];
        
    });
    
//    [self.navigationController pushViewController:manualScreen animated:YES];
//
//    menu = [[MenuTableViewController alloc] init];
//    drawer = [[KYDrawerController alloc] init];
//    [menu setElDrawer:drawer];
//
//    localNavigationController = [[UINavigationController alloc] initWithRootViewController:manualScreen];
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
//
//    });
    
}
    
-(void)gotoCongratulation
{
    SuccessAttendenceViewController *confirmScreen = [[SuccessAttendenceViewController alloc]initWithNibName:@"SuccessAttendenceViewController" bundle:nil];
    
    confirmScreen.userInfoDict = self.userInfoDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:confirmScreen animated:YES];
        
    });
    
//    [self.navigationController pushViewController:confirmScreen animated:YES];
//
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

@end
