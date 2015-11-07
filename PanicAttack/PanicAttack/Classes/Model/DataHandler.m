//
//  DataHandler.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "DataHandler.h"
#import "CoreDataHandler.h"

@interface DataHandler ()

@property (nonatomic) CoreDataHandler *coreDataHandler;

@end

@implementation DataHandler

- (User *)createUserWithEmail:(NSString *)email {
    User *user = [User object];
    user.email = email;
    [user saveInBackground];
    
    return user;
}

- (void)fetchUserWithEmail:(NSString *)email completionBlock:(PFQueryArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:[User parseClassName]];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (Event *)createEventWithStartDate:(NSDate *)startDate {
    Event *event = [Event object];
    event.startDate = startDate;
    [event saveInBackground];
    
    return event;
}

- (void)fetchEventsWithCompletionBlock:(PFQueryArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:[Event parseClassName]];
    [query orderByDescending:@"startDate"];
    [query includeKey:@"symptoms"];
    [query includeKey:@"medications"];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (Medication *)createMedicationWithName:(NSString *)name {
    Medication *medication = [Medication object];
    medication.name = name;
    [medication saveInBackground];
    
    return medication;
}

- (void)fetchMedicationsWithName:(NSString *)name completionBlock:(PFQueryArrayResultBlock)completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", name];
    
    PFQuery *query = [PFQuery queryWithClassName:[Medication parseClassName] predicate:predicate];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (Symptom *)createSymptomWithName:(NSString *)name {
    Symptom *symptom = [Symptom object];
    symptom.name = name;
    [symptom saveInBackground];
    
    return symptom;
}

- (void)fetchSymptomsWithName:(NSString *)name completionBlock:(PFQueryArrayResultBlock)completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", name];
    
    PFQuery *query = [PFQuery queryWithClassName:[Symptom parseClassName] predicate:predicate];
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
