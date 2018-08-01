//
//  Database.h
//  Entr
//
//  Created by Comantra on 23/09/16.
//  Copyright © 2016 crescentek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@class AppDelegate;

@interface Database : NSObject<NSFetchedResultsControllerDelegate>
{
    NSString *path;
    AppDelegate *appDelegate;
}

@property (strong) NSManagedObject * NewContact;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (NSString *)GetDBPath;
+ (Database *)getDatabase;


#pragma MARK -- Delete Methods --

- (void) deleteAllObjects: (NSString *) entityDescription;
- (void) deleteAllObjects: (NSString *)_entityDescription inaAttribute:(NSString *)_aAttribute withId:(int)_Id;
- (void) deleteAllObjects: (NSString *)_entityDescription inaAttribute:(NSString *)_aAttribute withStr:(NSString *)_str;


#pragma MARK -- Select Methods --

-(NSMutableArray *)GetSearchResultsbyiD:(NSString *)_iD;
-(NSMutableArray *)GetSearchNewbyiD:(NSString *)_iD;
-(NSMutableArray *)GetSortedvaluesOfSearchResults:(NSString *)_iD;
-(NSMutableArray *)GetSortedvaluesOfSearchNew:(NSString *)_iD;
-(NSMutableArray *)GetAllSearchResults;
-(NSMutableArray *)GetAllSearchNew;
-(NSMutableArray *)GetAllSearchNewbyType:(NSString *)_type;
-(NSString *)GetMaxidNoOfaEntity:(NSString *)_entityName OfaPrimaryKey:(NSString *)_primaryKey;


//---------------------------------------------------------------------------------------------------------------------------//

-(void)SearchResultsUpdateOfcityID:(NSString *)_cityID clubAddress:(NSString *)_clubAddress clubName:(NSString *)_clubName clubStatus:(NSString *)_clubStatus countryID:(NSString *)_countryID dateAdded:(NSString *)_dateAdded iD:(NSString *)_iD isDel:(NSString *)_isDel startingPrice:(NSString *)_startingPrice index:(int)_index;

-(void)SearchResultsInsertOfcityID:(NSString *)_cityID clubAddress:(NSString *)_clubAddress clubName:(NSString *)_clubName clubStatus:(NSString *)_clubStatus countryID:(NSString *)_countryID dateAdded:(NSString *)_dateAdded iD:(NSString *)_iD isDel:(NSString *)_isDel startingPrice:(NSString *)_startingPrice;

-(void)SearchNewUpdateOfname:(NSString *)_name address:(NSString *)_address type:(NSString *)_type iD:(NSString *)_iD index:(int)_index;

-(void)SearchNewInsertOfname:(NSString *)_name address:(NSString *)_address type:(NSString *)_type iD:(NSString *)_iD;

@end

