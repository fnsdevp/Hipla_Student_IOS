//
//  Constants.h
//  HiplaStudent
//
//  Created by fnspl3 on 18/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define allTrim(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define Userdefaults  [NSUserDefaults standardUserDefaults]

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define userDef @"NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];"

//#define DebugLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#define allTrim(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define Dist 10.1

//#define BASE_URL @"http://edu.gohipla.com/ws/"      //distribution

//#define BASE_URL @"http://edu.gohipla.com/ws/"   //development

#define BASE_URL @"http://cxc.gohipla.com/education/ws/"   //development

#define CMX_URL_LOCAL @"https://192.168.1.11/"

#define CMX_URL_GLOBAL @"https://223.30.206.130/"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define FONT_LIGHT(fontSize) [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]
#define FONT_REGULAR(fontSize) [UIFont fontWithName:@"HelveticaNeue-Regular" size:fontSize]
#define FONT_BOLD(fontSize) [UIFont fontWithName:@"Helvetica-Bold" size:fontSize]


#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define GLOBAL ((MPOAppDelegate*)[UIApplication sharedApplication].delegate)
#define IOS7_OR_LATER  ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define NAVIGATION_BAR_HEIGHT (self.navigationController.navigationBar.frame.size.height)

#endif /* Constants_h */
