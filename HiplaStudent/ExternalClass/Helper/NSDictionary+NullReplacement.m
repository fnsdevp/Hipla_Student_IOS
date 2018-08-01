//
//  NSDictionary+NullReplacement.m
//  Jing
//
//  Created by fnspl3 on 17/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "NSDictionary+NullReplacement.h"

@implementation NSDictionary (NullReplacement)

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks {
    
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        
        id object = [self objectForKey:key];
        
        if (object == nul) [replaced setObject:blank forKey:key];
        
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
