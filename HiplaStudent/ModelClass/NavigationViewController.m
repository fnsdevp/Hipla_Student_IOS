////
////  NavigationViewController.m
////  HiplaStudent
////
////  Created by FNSPL on 16/01/18.
////  Copyright © 2018 fnspl3. All rights reserved.
////
//
//#import "NavigationViewController.h"
//
//@interface NavigationViewController ()
//
//@end
//
//@implementation NavigationViewController
//
//- (void)viewDidLoad {
//
//    [super viewDidLoad];
//
//    [self.navigationController.navigationBar setHidden:YES];
//
//    NSLog(@"viewDidLoad:%@",self);
//
//    [[ZoneDetection sharedZoneDetection] setDelegate:self];
//
// //   if (!_navigineCore) {
//
//        //    _sv.frame = self.view.frame;
//        //    self.view.frame = CGRectMake(0, self.firstView.frame.origin.y+self.firstView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//
//        //_sv.frame = self.view.frame;
//        _sv.delegate = self;
//        _sv.pinchGestureRecognizer.enabled = YES;
//        _sv.minimumZoomScale = 1.f;
//        _sv.zoomScale = 1.f;
//        _sv.maximumZoomScale = 2.f;
//
//        [_sv addSubview:_imageView];
//
////        _navigineCore = [[NavigineCore alloc] initWithUserHash: @"C213-85E7-2265-3F4B"
////                                                        server: @"https://api.navigine.com"];
////        _navigineCore.delegate = self;
//
//
//    arrNames = [[NSMutableArray alloc] initWithObjects:@"conference room",@"conference room small", nil];
//
//    arrPointx = [[NSMutableArray alloc] initWithObjects:@"22.92",@"15.21", nil];
//
//    arrPointy = [[NSMutableArray alloc] initWithObjects:@"19.00",@"38.52", nil];
//
//
//        // Point on map
//
//        _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//
//        _current.backgroundColor = [UIColor redColor];
//        //_current.backgroundColor = [UIColor clearColor];
//        //_current.image = [UIImage imageNamed:@"location"];
//        _current.layer.cornerRadius = _current.frame.size.height/2.f;
//
//        [_imageView addSubview:_current];
//
//        _imageView.userInteractionEnabled = YES;
//
//        _isRouting = NO;
//
////        NSString *str = [Userdefaults objectForKey:@"navigationStart"];
////
////       if ([str isEqualToString:@"YES"])
////       {
//
//          [self setupNavigine];
//
////       }
//
////        [_navigineCore downloadLocationByName:@"cxc"
////                                  forceReload:NO
////                                 processBlock:^(NSInteger loadProcess) {
////
////                                     NSLog(@"%zd",loadProcess);
////
////                                 } successBlock:^(NSDictionary *userInfo) {
////
////                                     [self setupNavigine];
////
////                                 } failBlock:^(NSError *error) {
////
////                                     NSLog(@"%@",error);
////
////                                 }];
//
//
//      //  [[ZoneDetection sharedZoneDetection] setDelegate:self];
//
// //   }
//
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//
//    [SVProgressHUD show];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//
//    _navigineCore = nil;
//
//    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
//}
//
//-(void)dealloc
//{
//    NSLog(@"dealloc:%@",self);
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//
//    [self getZone];
//
//}
//
//-(void)navigateForConferenceRoom
//{
//    CGFloat xPoint = [[arrPointx objectAtIndex:0] floatValue];
//    CGFloat yPoint = [[arrPointy objectAtIndex:0] floatValue];
//
//    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
//
//    _isRouting = YES;
//}
//
//-(void)navigateForConferenceRoomSmall
//{
//    CGFloat xPoint = [[arrPointx objectAtIndex:1] floatValue];
//    CGFloat yPoint = [[arrPointy objectAtIndex:1] floatValue];
//
//    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
//
//    _isRouting = YES;
//}
//
//- (IBAction)showMenu:(UIButton *)sender
//{
//    [self stopRoute];
//
//    NSArray *menuItems =
//    @[
//
//      [KxMenuItem menuItem:@"conference room"
//                     image:nil
//                    target:self
//                    action:@selector(navigateForConferenceRoom)],
//
//      [KxMenuItem menuItem:@"conference room small"
//                     image:nil
//                    target:self
//                    action:@selector(navigateForConferenceRoomSmall)]
//
//      ];
//
//
//    [KxMenu showMenuInView:self.view.window
//                  fromRect:CGRectMake((SCREENWIDTH - 65), (sender.frame.origin.y - 30), sender.frame.size.width, sender.frame.size.width)
//                 menuItems:menuItems];
//
//    //sender.frame
//
//}
//
//-(void)getZone{
//
//    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
//
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
//
//    //create the Method "GET"
//    [urlRequest setHTTPMethod:@"GET"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                      {
//                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
//                                          if(httpResponse.statusCode == 200)
//                                          {
//                                              NSError *parseError = nil;
//
//                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//
//                                              NSLog(@"The response is - %@",responseDictionary);
//
//                                              _zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
//
//                                          }
//                                          else
//                                          {
//                                              NSLog(@"Error");
//                                          }
//                                      }];
//
//    [dataTask resume];
//
//}
//
//-(void) setupNavigine {
//
//    NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
//    if ([location.sublocations count]) {
//
//        NCSublocation *sublocation = location.sublocations[0];
//        [_imageView removeAllSubviews];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
////            _imageView.layer.sublayers = nil;
//            [_imageView addSubview:_current];
//
//        });
//
//        //    [self presentViewController:_navigineCore.location.viewController animated:YES completion:nil];
//
//        NSData *imageData = sublocation.pngImage;
//        UIImage *image = [UIImage imageWithData:imageData];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            float scale = 1.f;
//            if (image.size.width / image.size.height >
//                self.view.frame.size.width / self.view.frame.size.height) {
//                scale = self.view.frame.size.height / image.size.height;
//            }
//            else {
//                scale = self.view.frame.size.width / image.size.width;
//            }
//            _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
//            _imageView.image = image;
//            _sv.contentSize = _imageView.frame.size;
//
//        });
//
//    } else {
//
//    }
//
//
//   // [self drawZones];
//
////    dispatch_async(dispatch_get_main_queue(), ^{
////
////    });
//
//}
//
//- (void) drawZones {
//
//    NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
//    NSArray *zones = sublocation.zones;
//
//    for (NCZone *zone in zones) {
//        UIBezierPath *zonePath     = [[UIBezierPath alloc] init];
//        CAShapeLayer *zoneLayer = [CAShapeLayer layer];
//        NSArray *points = zone.points;
//        NCLocationPoint *point0 = points[0];
//
//        [zonePath moveToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
//                                          _imageView.height * (1. - point0.y.doubleValue / sublocation.height))];
//        for (NCLocationPoint *point in zone.points) {
//            [zonePath addLineToPoint:CGPointMake(_imageView.width * point.x.doubleValue / sublocation.width,
//                                                 _imageView.height * (1. - point.y.doubleValue / sublocation.height))];
//        }
//        [zonePath addLineToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
//                                             _imageView.height *(1. - point0.y.doubleValue / sublocation.height))];
//        unsigned int result = 0;
//        NSScanner *scanner = [NSScanner scannerWithString:zone.color];
//        [scanner setScanLocation:1];
//        [scanner scanHexInt:&result];
//
//        zoneLayer.hidden = NO;
//        zoneLayer.path            = [zonePath CGPath];
//        zoneLayer.strokeColor     = [kColorFromHex(result) CGColor];
//        zoneLayer.lineWidth       = 2.0;
//        zoneLayer.lineJoin        = kCALineJoinRound;
//        zoneLayer.fillColor       = [[kColorFromHex(result) colorWithAlphaComponent:0.5] CGColor];
//
//        [_imageView.layer addSublayer:zoneLayer];
//    }
//}
//
//-(void)navigateForClass:(NSString *)class
//{
//    // [self stopRoute];
//
//    if ([class isEqualToString:@"conference area"])
//    {
//        indexId = 0;
//    }
//    else if ([class isEqualToString:@"conference room small"])
//    {
//        indexId = 1;
//    }
//
//    CGFloat xPoint = [[arrPointx objectAtIndex:indexId] floatValue];
//    CGFloat yPoint = [[arrPointy objectAtIndex:indexId] floatValue];
//
//    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
//
//    _isRouting = YES;
//}
//
//
//- (void)drawPathWithEndPoint:(CGPoint)endPoint
//{
//    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
//
//    CGFloat xPoint = endPoint.x;
//    CGFloat yPoint = endPoint.y;
//
//    NCLocationPoint *location = [NCLocationPoint pointWithLocation:res.location sublocation:res.sublocation x:[NSNumber numberWithFloat:xPoint] y:[NSNumber numberWithFloat:yPoint]];
//
//    [[ZoneDetection sharedZoneDetection].navigineCore addTatget:location];
//
//}
//
//-(void)enterZoneWithZoneName:(NSString *)zoneName {
//
//    if (zoneName) {
//
//        if ([zoneName isEqualToString:@"conference area"]) {
//
//
//        }
//        else if ([zoneName isEqualToString:@"conference room small"]) {
//
//
//        }
//        else if ([zoneName isEqualToString:@"3"])
//        {
//
//        }
//        else if ([zoneName isEqualToString:@"4"]) {
//
//            BOOL restrictedZone  = [Userdefaults boolForKey:@"restrictedZone"];
//
//            if (restrictedZone==NO)
//            {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
//                                                                               message:@"You are near the restricted zone. Please do not enter into the restricted zone."
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {
//
//
//
//                                                                      }];
//
//                [alert addAction:defaultAction];
//
//                [Userdefaults setBool:YES forKey:@"restrictedZone"];
//
//                [Userdefaults synchronize];
//
//                [self presentViewController:alert animated:YES completion:nil];
//
//            }
//
//        }
//    }
//}
//
//
//-(void)exitZoneWithZoneName:(NSString *)zoneName {
//
//    if (zoneName) {
//
//        if ([zoneName isEqualToString:@""])
//        {
//
//        }
//        else if ([zoneName isEqualToString:@"4"]) {
//
//            [Userdefaults setBool:NO forKey:@"restrictedZone"];
//
//            [Userdefaults synchronize];
//
//        }
//    }
//}
//
//
//- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
//
//    NSDictionary* zone = nil;
//
//    if (_zoneArray) {
//
//        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
//
//            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
//
//            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
//
//            if ([coordinates count]>0) {
//
//                UIBezierPath* path = [[UIBezierPath alloc]init];
//
//                for (NSInteger j=0; j < [coordinates count]; j++) {
//
//                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
//
//                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
//
//                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
//                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
//
//                        CGPoint point = CGPointMake(xPoint, yPoint);
//
//                        if (j == 0) {
//
//                            [path moveToPoint:point];
//
//                        } else {
//
//                            [path addLineToPoint:point];
//                        }
//                    }
//                }
//
//                [path closePath];
//
//                if ([path containsPoint:currentPoint]) {
//
//                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
//
//                    break;
//
//                } else {
//
//                    zone = nil;
//
//                }
//            }
//        }
//
//    } else {
//
//    }
//
//    return zone;
//}
//
//- (void)stopRoute {
//
//    _isRouting = NO;
//
//    [routeLayer removeFromSuperlayer];
//    routeLayer = nil;
//
//    [uipath removeAllPoints];
//    uipath = nil;
//    [[ZoneDetection sharedZoneDetection].navigineCore cancelTargets];
//}
//
//- (void)navigationTicker {
//
//   // NCDeviceInfo *res = _navigineCore.deviceInfo;
//
//    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
//
//    NSLog(@"Error code:%zd",res.error.code);
//
//    if (res.error.code == 0) {
//
//        [SVProgressHUD dismiss];
//
//        NSLog(@"RESULT: %lf %lf", res.x, res.y);
//
//        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
//
//        if ([[dic allKeys] containsObject:@"name"]) {
//
//            // NSLog(@"zone detected:%@",dic);
//
//            NSString* zoneName = [dic objectForKey:@"name"];
//
//            if (!_currentZoneName) {
//
//                _currentZoneName = zoneName;
//
//                [self enterZoneWithZoneName:_currentZoneName];
//
//
//            } else {
//
//                if (![zoneName isEqualToString:_currentZoneName]) {
//
//                    [self exitZoneWithZoneName:_currentZoneName];
//
//                    _currentZoneName = zoneName;
//
//                    [self enterZoneWithZoneName:_currentZoneName];
//
//                } else {
//
//                }
//            }
//
//
//        } else {
//
//            if (_currentZoneName) {
//
//                [self exitZoneWithZoneName:_currentZoneName];
//
//                _currentZoneName = nil;
//
//            } else {
//
//            }
//
//        }
//
////        NSString *str = [Userdefaults objectForKey:@"navigationStart"];
////
////        if ([str isEqualToString:@"YES"])
////        {
////            [Userdefaults setObject:@"NO" forKey:@"navigationStart"];
////
////            [Userdefaults synchronize];
////
////            [self setupNavigine];
////        }
//
//
//         dispatch_async(dispatch_get_main_queue(), ^{
//
//             _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
//                                           _imageView.height / _sv.zoomScale * (1. - res.ky));
//
//             if ([self.className length]>0)
//             {
//                 [self performSelector:@selector(navigateForClass:) withObject:_className afterDelay:0.3];
//             }
//
//         });
//
//    }
//    else{
//
//        NSLog(@"Error code:%zd",res.error.code);
//    }
//
//    if (_isRouting) {
//
//        NCRoutePath *devicePath = res.paths.firstObject;
//
//        NSArray *path = devicePath.points;
//
//        float distance = devicePath.lenght;
//
//        [self drawRouteWithPath:path andDistance:distance];
//
//    }
//}
//
//-(void) drawRouteWithPath: (NSArray *)path
//              andDistance: (float)distance {
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        //    // We check that we are close to the finish point of the route
//        if (distance <= 0.2) {
//
//            [self stopRoute];
//
//        }
//        else {
//
//            [routeLayer removeFromSuperlayer];
//            [uipath removeAllPoints];
//
//            uipath     = [[UIBezierPath alloc] init];
//            routeLayer = [CAShapeLayer layer];
//
//            for (int i = 0; i < path.count; i++ ) {
//
//                NCLocationPoint *point = path[i];
//                NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
//                CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
//
//                CGFloat xPoint =  (point.x.doubleValue / imageSizeInMeters.width) * (_imageView.width / _sv.zoomScale);
//                CGFloat yPoint =  (1. - point.y.doubleValue / imageSizeInMeters.height)  * (_imageView.height / _sv.zoomScale);
//                if(i == 0) {
//                    [uipath moveToPoint:CGPointMake(xPoint, yPoint)];
//                }
//                else {
//                    [uipath addLineToPoint:CGPointMake(xPoint, yPoint)];
//                }
//            }
//        }
//
//        routeLayer.hidden          = NO;
//        routeLayer.path            = [uipath CGPath];
//        //    routeLayer.strokeColor     = [kColorFromHex(0x4AADD4) CGColor];
//        routeLayer.strokeColor     = [[UIColor blueColor] CGColor];
//
//        routeLayer.lineWidth       = 5.0;
//        routeLayer.lineJoin        = kCALineJoinRound;
//        routeLayer.fillColor       = [[UIColor clearColor] CGColor];
//
//        [_imageView.layer addSublayer:routeLayer];
//        [_imageView bringSubviewToFront:_current];
//
//    });
//
//}
//
//#pragma mark UIScrollViewDelegate methods
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//
//    return _imageView;
//}
//
//#pragma mark NavigineCoreDelegate methods
//
//- (void) didRangePushWithTitle:(NSString *)title
//                       content:(NSString *)content
//                         image:(NSString *)image
//                            id:(NSInteger)id{
//
//    // Your code
//
//}
//
//- (IBAction)btnBack:(id)sender {
//
//    if ([self.className length]>0)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        ProfileViewController *profileScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self.navigationController pushViewController:profileScreen animated:YES];
//        });
//
//    }
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
