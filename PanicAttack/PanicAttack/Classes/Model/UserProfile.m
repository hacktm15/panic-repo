//
//  UserProfile.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (instancetype)init {
    if (self = [super init]) {
        self.dataHandler = [DataHandler new];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static UserProfile *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UserProfile new];
    });
    
    return sharedInstance;
}

@end
