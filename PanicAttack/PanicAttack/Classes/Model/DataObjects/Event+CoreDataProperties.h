//
//  Event+CoreDataProperties.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSNumber *depressionLevel;
@property (nullable, nonatomic, retain) NSNumber *anxietyLevel;
@property (nullable, nonatomic, retain) NSNumber *expected;
/// 0 - situation; 1 - thought
@property (nullable, nonatomic, retain) NSNumber *cause;
@property (nullable, nonatomic, retain) NSString *observations;
@property (nullable, nonatomic, retain) NSNumber *fearLevel;
@property (nullable, nonatomic, retain) Patient *user;
@property (nullable, nonatomic, retain) NSArray<Symptom *> *symptoms;
@property (nullable, nonatomic, retain) NSArray<Medication *> *medications;

@end

NS_ASSUME_NONNULL_END
