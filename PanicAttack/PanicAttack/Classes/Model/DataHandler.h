//
//  DataHandler.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Event.h"
#import "Medication.h"
#import "Symptom.h"

@interface DataHandler : NSObject

- (void)save;

- (User *)createUserWithEmail:(NSString *)email;
- (User *)fetchLoggedUser;

- (Event *)createEventWithStartDate:(NSDate *)startDate;
- (NSArray *)fetchEvents;

- (Medication *)createMedicationWithName:(NSString *)name;
- (NSArray *)fetchMedicationsWithName:(NSString *)name;

- (Symptom *)createSymptomWithName:(NSString *)name;
- (NSArray *)fetchSymptomsWithName:(NSString *)name;

@end
