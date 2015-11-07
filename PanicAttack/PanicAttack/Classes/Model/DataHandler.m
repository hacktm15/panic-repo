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

- (instancetype)init {
    if (self = [super init]) {
        self.coreDataHandler = [CoreDataHandler new];
    }
    
    return self;
}

- (void)save {
    [self.coreDataHandler saveContext];
}

- (User *)createUserWithEmail:(NSString *)email {
    User *user = [self.coreDataHandler insertEntityWithName:NSStringFromClass([User class])];
    user.email = email;
    
    return user;
}

- (User *)fetchLoggedUser {
    NSArray *users = [self.coreDataHandler fetchEntityWithName:NSStringFromClass([User class]) predicate:nil sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES]];
    
    return [users firstObject];
}

- (Event *)createEventWithStartDate:(NSDate *)startDate {
    Event *event = [self.coreDataHandler insertEntityWithName:NSStringFromClass([Event class])];
    event.startDate = startDate;
    
    return event;
}

- (NSArray *)fetchEvents {
    return [self.coreDataHandler fetchEntityWithName:NSStringFromClass([Event class]) predicate:nil sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO]];
}

- (Medication *)createMedicationWithName:(NSString *)name {
    Medication *medication = [self.coreDataHandler insertEntityWithName:NSStringFromClass([Medication class])];
    medication.name = name;
    
    return medication;
}

- (NSArray *)fetchMedicationsWithName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", name];
    
    return [self.coreDataHandler fetchEntityWithName:NSStringFromClass([Medication class]) predicate:predicate sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
}

- (Symptom *)createSymptomWithName:(NSString *)name {
    Symptom *symptom = [self.coreDataHandler insertEntityWithName:NSStringFromClass([Symptom class])];
    symptom.name = name;
    
    return symptom;
}

- (NSArray *)fetchSymptomsWithName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", name];
    
    return [self.coreDataHandler fetchEntityWithName:NSStringFromClass([Symptom class]) predicate:predicate sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
}

@end
