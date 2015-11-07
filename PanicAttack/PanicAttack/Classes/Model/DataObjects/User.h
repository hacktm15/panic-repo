//
//  User.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Event;

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject <PFSubclassing>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
