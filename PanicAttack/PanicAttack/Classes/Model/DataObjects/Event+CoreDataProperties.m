//
//  Event+CoreDataProperties.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

@dynamic startDate;
@dynamic endDate;
@dynamic depressionLevel;
@dynamic anxietyLevel;
@dynamic expected;
@dynamic cause;
@dynamic observations;
@dynamic fearLevel;
@dynamic user;
@dynamic symptoms;
@dynamic medications;

@end
