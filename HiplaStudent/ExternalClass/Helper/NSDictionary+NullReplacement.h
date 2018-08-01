//
//  NSDictionary+NullReplacement.h
//  Jing
//
//  Created by fnspl3 on 17/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullReplacement)

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;

@end
