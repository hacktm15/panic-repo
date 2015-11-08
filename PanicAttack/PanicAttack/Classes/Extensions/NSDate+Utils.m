//
//  NSDate+Utils.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/8/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSDate *)toLocalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSDate *)toGlobalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSString *)toString {
    NSString *string = [[NSDate defaultDateFormatter] stringFromDate:self];
    return string;
}

+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd / MM / yyyy"];
    }
    
    return dateFormatter;
}

@end
