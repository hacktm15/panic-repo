//
//  CoreDataHandler.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHandler : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

- (NSArray *)fetchEntityWithName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (id)insertEntityWithName:(NSString *)entityName;

@end
