//
//  AppDelegate.m
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "PanicViewController.h"
#import "HistoryViewController.h"
#import "ProfileViewController.h"
#import "UserProfile.h"
#import <Parse/Parse.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <HealthKit/HealthKit.h>
#import "HKHealthStore+AAPLExtensions.h"

static NSString *kPanicButtonKey = @"panicButtonKey";
static NSString *kTimerKey = @"timerKey";

typedef NS_ENUM (NSUInteger, PanicButtonState) {
    EventNotInProgress = 0,
    EventInProgress,
    Waiting,
};

@interface AppDelegate () <WCSessionDelegate>

@property (nonatomic) HKHealthStore *healthStore;
@property (nonatomic) PanicViewController *panicVC;
@property (nonatomic) HistoryViewController *historyVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParse];
    
    self.healthStore = [HKHealthStore new];
    
    [[UserProfile sharedInstance].dataHandler fetchUserWithEmail:@"user@email.com" completionBlock:^(NSArray<Patient *> * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            [self createDummyData];
        } else {
            [UserProfile sharedInstance].user = [objects firstObject]; // LOGIN
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUpdated" object:nil];
            
            [self readHealthKitData];
        }
    }];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabController = [UITabBarController new];
    tabController.title = @"Panic Attack";
    tabController.viewControllers = [self tabViewControllers];
    tabController.selectedViewController = self.panicVC;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tabController];
    
    [self.window setRootViewController: navController];
    [self.window makeKeyAndVisible];

    [self establishSession];

    return YES;
}

- (NSArray *) tabViewControllers {
    ProfileViewController *profileVC = [ProfileViewController new];
    
    self.panicVC = [[PanicViewController alloc] initWithNibName: @"PanicViewController" bundle: nil];
    
    self.historyVC = [[HistoryViewController alloc] initWithNibName: @"HistoryViewController" bundle: nil];
    
    return @[profileVC, self.panicVC, self.historyVC];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [self readHealthKitData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Private

- (void)setupParse {
    [Patient registerSubclass];
    [Symptom registerSubclass];
    [Event registerSubclass];
    [Medication registerSubclass];
    [Parse setApplicationId:@"cx8RDcpcylmUJ4jX9FEjrZAlBSy0WGx7RN8VLSvT"
                  clientKey:@"MftOIZiUAUKeDxRF09LviiPVYvK157guoiKwg9du"];
}

- (void)createDummyData {
    Patient *user = [[UserProfile sharedInstance].dataHandler createUserWithEmail:@"user@email.com"];
    user.firstName = @"Vlad";
    user.lastName = @"Dracul";
    user.sex = @0;
    user.birthDate = [NSDate dateWithTimeIntervalSince1970:0];
    user.weight = @89;
    
    [UserProfile sharedInstance].user = user; // LOGIN
    
    Event *event1 = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate date]];
    event1.user = user;
    
    Event *event = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-518400]];
    event.user = user;
    event.anxietyLevel = @(5);
    event.depressionLevel = @(10);
    event.expected = @(NO);
    event.cause = @(0);
    event.fearLevel = @(7);
    event.observations = @"Some observations";

    NSArray *medications = @[[[UserProfile sharedInstance].dataHandler createMedicationWithName:@"cancer cure"], [[UserProfile sharedInstance].dataHandler createMedicationWithName:@"AIDS cure"], [[UserProfile sharedInstance].dataHandler createMedicationWithName:@"cantest cure"]];
    event.medications = medications;

    NSArray *symptoms = @[[[UserProfile sharedInstance].dataHandler createSymptomWithName:@"symptom one"],[[UserProfile sharedInstance].dataHandler createSymptomWithName:@"symptom two"], [[UserProfile sharedInstance].dataHandler createSymptomWithName:@"three"]];
    event.symptoms = symptoms;
    
    [user saveInBackground];
    [event1 saveInBackground];
    [event saveInBackground];
}

- (void)postUserUpdatedNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUpdated" object:nil];
    });
}

#pragma mark - Public

- (void)eventProgressChangedInApp:(BOOL)inProgress {
    [self updateWatchWithPanicButtonState: inProgress ? @(EventInProgress) : @(EventNotInProgress)];
}

#pragma mark - WatchKit
- (void) establishSession {
    if ([WCSession isSupported]) {
        WCSession* session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void) updateWatchWithPanicButtonState: (NSNumber *)panicButtonState {
    if ([WCSession defaultSession].reachable) {
        [[WCSession defaultSession] sendMessage: @{
                                                   kPanicButtonKey : panicButtonState,
                                                   kTimerKey : [self.panicVC getTimerStartDate],
                                                   }
                                   replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {

                                   }
                                   errorHandler:^(NSError * _Nonnull error) {

        }];
    }
}

- (void) session: (WCSession *) session didReceiveMessage: (NSDictionary <NSString *, id> *) message replyHandler: (void (^)(NSDictionary <NSString *, id> *_Nonnull)) replyHandler {
    NSNumber *requestedState = [message valueForKey: kPanicButtonKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *timerStartDate = [NSDate date];

            if (requestedState.unsignedIntegerValue != Waiting) {
                [self.panicVC changeEventToInProgress: requestedState.unsignedIntegerValue];
            }

            NSNumber *replyButtonState;

            if ([self.panicVC isEventInProgress]) {
                replyButtonState = @(EventInProgress);
                timerStartDate = [self.panicVC getTimerStartDate];
            } else {
                replyButtonState = @(EventNotInProgress);
            }
            replyHandler(@{
                           kPanicButtonKey : replyButtonState,
                           kTimerKey : timerStartDate,
                           });

        });
}

#pragma mark - HealthKit

- (NSSet *)dataTypesToRead {
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    
    return [NSSet setWithObjects:weightType, birthdayType, biologicalSexType, nil];
}

- (void)readHealthKitData {
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:nil];
                [UserProfile sharedInstance].user.birthDate = dateOfBirth;
                [[UserProfile sharedInstance].user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self postUserUpdatedNotification];
                }];
                
                HKBiologicalSexObject *biologicalSexObject = [self.healthStore biologicalSexWithError:nil];
                if (biologicalSexObject) {
                    if (biologicalSexObject.biologicalSex == HKBiologicalSexMale) {
                        [UserProfile sharedInstance].user.sex = @0;
                    } else if (biologicalSexObject.biologicalSex == HKBiologicalSexFemale) {
                        [UserProfile sharedInstance].user.sex = @1;
                    } else {
                        [UserProfile sharedInstance].user.sex = nil;
                    }
                    
                    [[UserProfile sharedInstance].user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self postUserUpdatedNotification];
                    }];
                }
            });
            
            HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
                if (mostRecentQuantity) {
                    // Determine the weight in the required unit.
                    HKUnit *weightUnit = [HKUnit gramUnit];
                    double usersWeight = [mostRecentQuantity doubleValueForUnit:weightUnit] / 1000;
                    
                    // Update the user interface.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UserProfile sharedInstance].user.weight = @(usersWeight);
                        [[UserProfile sharedInstance].user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            [self postUserUpdatedNotification];
                        }];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UserProfile sharedInstance].user.weight = nil;
                        [[UserProfile sharedInstance].user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            [self postUserUpdatedNotification];
                        }];
                    });
                }
            }];
        }];
    }
}

@end
