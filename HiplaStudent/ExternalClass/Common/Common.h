//
//  Common.h
//  HiplaStudent
//
//  Created by FNSPL on 14/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APIManager.h"

@protocol CommonDelegate
@optional

- (void)routineStatus:(NSDictionary *)dicRoutine;
- (void)currentRoutineStatus:(NSDictionary *)dicRoutine;

@end

@interface Common : NSObject
{
    APIManager *api;
}
@property (nonatomic, weak) id<CommonDelegate> commonDelegate;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *userRoutineInfo;
@property (nonatomic, strong) NSMutableArray *routineArr;
@property (nonatomic, strong) NSString *currentDateStr;

+(Common *) sharedCommonFetch;

- (NSMutableArray *)getDetailsofRoutine:(NSString *)givenDate;
- (NSDictionary *)JSONFromFile;
- (void)getCurrentRoutine:(NSString *)timeStr;
- (void)RoutineWithDetails:(NSString *)dateStr;
- (void)checkRoutine:(NSString *)dateStr;
- (void)checkRoutineStatus:(NSString *)routineHistoryId;
- (NSString*)readStringFromFile;
- (BOOL)isNextClassStart:(NSDictionary *)dicClass;
- (void)writeStringToFile:(NSString*)aString;

@end
