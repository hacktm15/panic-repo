//
//  UserProfile.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataHandler.h"
#import "User.h"

@interface UserProfile : NSObject

@property (nonatomic) User *user;

@property (nonatomic) DataHandler *dataHandler;

+ (instancetype)sharedInstance;

@end
