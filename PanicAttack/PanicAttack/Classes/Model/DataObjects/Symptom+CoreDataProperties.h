//
//  Symptom+CoreDataProperties.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Symptom.h"

NS_ASSUME_NONNULL_BEGIN

@interface Symptom (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Event *event;

@end

NS_ASSUME_NONNULL_END