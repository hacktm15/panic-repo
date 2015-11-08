//
//  NSDate+Utils.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/8/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;

- (NSString *)toString;
+ (NSDateFormatter *)defaultDateFormatter;

@end
