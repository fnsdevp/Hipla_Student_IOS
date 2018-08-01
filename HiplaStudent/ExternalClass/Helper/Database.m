//
//  Database.m
//  Entr
//
//  Created by Comantra on 23/09/16.
//  Copyright © 2016 crescentek. All rights reserved.
//

#import "Database.h"

#define DATABASE_FILENAME @"Entr.sqlite"

@implementation Database

@synthesize NewContact,managedObjectContext,fetchedResultsController;

+ (Database *)getDatabase
{
    static Database *getdb = nil;
    
    if (getdb == nil)
    {
        getdb = [[Database alloc] init];
    }
    
    return getdb;
}


- (NSString *)GetDBPath {
    
    if(path==nil) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:DATABASE_FILENAME];
        
        NSLog(@"path..%@",path);
    }
    
    return path;
}


-(NSMutableArray *)GetAllSearchResults
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"SearchResults" inManagedObjectContext:context]];
    
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    
    return [results mutableCopy];
    
}


-(NSMutableArray *)GetAllSearchNew
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"SearchNew" inManagedObjectContext:context]];
    
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    
    return [results mutableCopy];
    
}


-(NSMutableArray *)GetAllSearchNewbyType:(NSString *)_type
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"SearchNew"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    
    //NSLog(@"_stateCode...%@",_stateCode);
    
    // request.resultType = NSDictionaryResultType;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"type = %@",_type]];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"type", nil]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *statelist = [fetchedObjects mutableCopy];
    
    // NSLog(@"statelist...%@",statelist);
    
    return statelist;
    
}


-(NSString *)GetMaxidNoOfaEntity:(NSString *)_entityName OfaPrimaryKey:(NSString *)_primaryKey
{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:[NSString stringWithFormat:@"%@",_entityName]
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@==max(%@)",_primaryKey,_primaryKey]];
    request.sortDescriptors = [NSArray array];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSString *ID = [[fetchedObjects valueForKey:[NSString stringWithFormat:@"%@",_primaryKey]] objectAtIndex:0];
    
    //NSLog(@"ID...%@",ID);
    
    return ID;
    
}

-(NSMutableArray *)GetSearchResultsbyiD:(NSString *)_iD
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"SearchResults"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    
    //NSLog(@"_stateCode...%@",_stateCode);
    
    // request.resultType = NSDictionaryResultType;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD = %@",_iD]];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"iD", nil]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *statelist = [fetchedObjects mutableCopy];
    
    // NSLog(@"statelist...%@",statelist);
    
    return statelist;
    
}

-(NSMutableArray *)GetSearchNewbyiD:(NSString *)_iD
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"SearchNew"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    
    //NSLog(@"_stateCode...%@",_stateCode);
    
    // request.resultType = NSDictionaryResultType;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD = %@",_iD]];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"iD", nil]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *statelist = [fetchedObjects mutableCopy];
    
    // NSLog(@"statelist...%@",statelist);
    
    return statelist;
    
}

-(NSMutableArray *)GetSortedvaluesOfSearchNew:(NSString *)_iD
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchNew"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    
    //request.resultType = NSDictionaryResultType;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD == %d",_iD]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"iD" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor1,sortDescriptor2, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *ControlsNames = [fetchedObjects mutableCopy];
    
    
    // NSLog(@"ControlsNames...%@",ControlsNames);
    
    return ControlsNames;
    
}


-(NSMutableArray *)GetSortedvaluesOfSearchResults:(NSString *)_iD
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchResults"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    
    //request.resultType = NSDictionaryResultType;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD == %d",_iD]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"iD" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"cityID" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"countryID" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [NSSortDescriptor sortDescriptorWithKey:@"isDel" ascending:YES];
    NSSortDescriptor *sortDescriptor5 = [NSSortDescriptor sortDescriptorWithKey:@"startingPrice" ascending:YES];
    NSSortDescriptor *sortDescriptor6 = [NSSortDescriptor sortDescriptorWithKey:@"clubName" ascending:YES];
    NSSortDescriptor *sortDescriptor7 = [NSSortDescriptor sortDescriptorWithKey:@"clubAddress" ascending:YES];
    NSSortDescriptor *sortDescriptor8 = [NSSortDescriptor sortDescriptorWithKey:@"startingPrice" ascending:YES];
    NSSortDescriptor *sortDescriptor9 = [NSSortDescriptor sortDescriptorWithKey:@"clubStatus" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor1,sortDescriptor2,sortDescriptor3,sortDescriptor4,sortDescriptor5,sortDescriptor6,sortDescriptor7,sortDescriptor8,sortDescriptor9, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *ControlsNames = [fetchedObjects mutableCopy];
    
    
    // NSLog(@"ControlsNames...%@",ControlsNames);
    
    return ControlsNames;
    
}


- (void) deleteAllObjects: (NSString *)_entityDescription inaAttribute:(NSString *)_aAttribute withId:(int)_Id
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityDescription inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ == %d",_aAttribute,_Id]];
    
    //NSLog(@"entityDescription...%@",_entityDescription);
    //NSLog(@"attributeNo...%d",_attributeNo);
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:request error:nil];
    
    NSLog(@"items...%@",items);
    
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
        
        NSLog(@"%@ object deleted",_entityDescription);
    }
    
    [context save:&error];
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@",_entityDescription,error);
    }
    
}


- (void) deleteAllObjects: (NSString *)_entityDescription inaAttribute:(NSString *)_aAttribute withStr:(NSString *)_str
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityDescription inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ == %@",_aAttribute,_str]];
    
    //NSLog(@"entityDescription...%@",_entityDescription);
    //NSLog(@"attributeNo...%d",_attributeNo);
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:request error:nil];
    
    NSLog(@"items...%@",items);
    
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
        
        NSLog(@"%@ object deleted",_entityDescription);
    }
    
    [context save:&error];
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@",_entityDescription,error);
    }
    
}

- (void) deleteAllObjects: (NSString *) entityDescription
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:nil];
    
    
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
        
        NSLog(@"%@ object deleted",entityDescription);
    }
    
    [context save:&error];
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}


//---------------------------------------------------------------------------------------------------------------------------//
// Insert & Update tables.....


-(void)SearchResultsUpdateOfcityID:(NSString *)_cityID clubAddress:(NSString *)_clubAddress clubName:(NSString *)_clubName clubStatus:(NSString *)_clubStatus countryID:(NSString *)_countryID dateAdded:(NSString *)_dateAdded iD:(NSString *)_iD isDel:(NSString *)_isDel startingPrice:(NSString *)_startingPrice index:(int)_index
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *UserMappingList = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"SearchResults" inManagedObjectContext:context]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD == %d",_iD]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    UserMappingList = [fetchedObjects mutableCopy];
    
    NewContact = [UserMappingList objectAtIndex:0];
    
    [NewContact setValue: _cityID forKey:@"cityID"];
    [NewContact setValue: _clubAddress forKey:@"clubAddress"];
    [NewContact setValue: _clubName forKey:@"clubName"];
    [NewContact setValue: _clubStatus forKey:@"clubStatus"];
    [NewContact setValue: _countryID forKey:@"countryID"];
    [NewContact setValue: _dateAdded forKey:@"dateAdded"];
    [NewContact setValue: _iD forKey:@"iD"];
    [NewContact setValue: _isDel forKey:@"isDel"];
    [NewContact setValue: _startingPrice forKey:@"startingPrice"];
    
    NSError *error;
    [context save:&error];
    
}


-(void)SearchResultsInsertOfcityID:(NSString *)_cityID clubAddress:(NSString *)_clubAddress clubName:(NSString *)_clubName clubStatus:(NSString *)_clubStatus countryID:(NSString *)_countryID dateAdded:(NSString *)_dateAdded iD:(NSString *)_iD isDel:(NSString *)_isDel startingPrice:(NSString *)_startingPrice
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NewContact = [NSEntityDescription
                  insertNewObjectForEntityForName:@"SearchResults"
                  inManagedObjectContext:context];
    
    
    [NewContact setValue: _cityID forKey:@"cityID"];
    [NewContact setValue: _clubAddress forKey:@"clubAddress"];
    [NewContact setValue: _clubName forKey:@"clubName"];
    [NewContact setValue: _clubStatus forKey:@"clubStatus"];
    [NewContact setValue: _countryID forKey:@"countryID"];
    [NewContact setValue: _dateAdded forKey:@"dateAdded"];
    [NewContact setValue: _iD forKey:@"iD"];
    [NewContact setValue: _isDel forKey:@"isDel"];
    [NewContact setValue: _startingPrice forKey:@"startingPrice"];
    
    
    NSError *error;
    [context save:&error];
    
}

-(void)SearchNewUpdateOfname:(NSString *)_name address:(NSString *)_address type:(NSString *)_type iD:(NSString *)_iD index:(int)_index
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *UserMappingList = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"SearchNew" inManagedObjectContext:context]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"iD == %d",_iD]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    
    UserMappingList = [fetchedObjects mutableCopy];
    
    NewContact = [UserMappingList objectAtIndex:0];
    
    [NewContact setValue: _name forKey:@"name"];
    [NewContact setValue: _address forKey:@"address"];
    [NewContact setValue: _type forKey:@"type"];
    [NewContact setValue: _iD forKey:@"iD"];
    
    NSError *error;
    [context save:&error];
    
}

-(void)SearchNewInsertOfname:(NSString *)_name address:(NSString *)_address type:(NSString *)_type iD:(NSString *)_iD
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NewContact = [NSEntityDescription
                  insertNewObjectForEntityForName:@"SearchNew"
                  inManagedObjectContext:context];
    
    
    [NewContact setValue: _name forKey:@"name"];
    [NewContact setValue: _address forKey:@"address"];
    [NewContact setValue: _type forKey:@"type"];
    [NewContact setValue: _iD forKey:@"iD"];
    
    
    NSError *error;
    [context save:&error];
    
    
}

@end
