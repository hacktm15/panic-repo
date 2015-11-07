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

- (User *)createUserWithEmail:(NSString *)email;
- (void)fetchUserWithEmail:(NSString *)email completionBlock:(PFQueryArrayResultBlock)completion;

- (Event *)createEventWithStartDate:(NSDate *)startDate;
- (void)fetchEventsWithCompletionBlock:(PFQueryArrayResultBlock)completion;

- (Medication *)createMedicationWithName:(NSString *)name;
- (void)fetchMedicationsWithName:(NSString *)name completionBlock:(PFQueryArrayResultBlock)completion;

- (Symptom *)createSymptomWithName:(NSString *)name;
- (void)fetchSymptomsWithName:(NSString *)name completionBlock:(PFQueryArrayResultBlock)completion;

@end
