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
#import "UserProfile.h"
#import <Parse/Parse.h>
#import <WatchConnectivity/WatchConnectivity.h>

static NSString *kPanicButtonKey = @"panicButtonKey";

typedef NS_ENUM (NSUInteger, PanicButtonState) {
    StartPanicEvent = 0,
    StopPanicEvent,
    Waiting,
};

@interface AppDelegate () <WCSessionDelegate>

@property (nonatomic) PanicViewController *panicVC;
@property (nonatomic) HistoryViewController *historyVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParse];
    
    [[UserProfile sharedInstance].dataHandler fetchUserWithEmail:@"user@email.com" completionBlock:^(NSArray<User *> * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            [self createDummyData];
        }
    }];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabController = [UITabBarController new];
    tabController.title = @"Panic Attack";
    tabController.viewControllers = [self tabViewControllers];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tabController];
    
    [self.window setRootViewController: navController];
    [self.window makeKeyAndVisible];

    [self establishSession];

    return YES;
}

- (NSArray *) tabViewControllers {
    self.panicVC = [[PanicViewController alloc] initWithNibName: @"PanicViewController" bundle: nil];
    
    self.historyVC = [[HistoryViewController alloc] initWithNibName: @"HistoryViewController" bundle: nil];
    
    return @[self.panicVC, self.historyVC];
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

    [self establishSession];
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
    [User registerSubclass];
    [Symptom registerSubclass];
    [Event registerSubclass];
    [Medication registerSubclass];
    [Parse setApplicationId:@"cx8RDcpcylmUJ4jX9FEjrZAlBSy0WGx7RN8VLSvT"
                  clientKey:@"MftOIZiUAUKeDxRF09LviiPVYvK157guoiKwg9du"];
}

- (void)createDummyData {
    User *user = [[UserProfile sharedInstance].dataHandler createUserWithEmail:@"user@email.com"];
    
    Event *event = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate date]];
    event.user = user;
    [event saveInBackground];
    
    event = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-518400]];
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
    
    [event saveInBackground];
}

#pragma mark - Public

- (void)eventProgressChangedInApp:(BOOL)inProgress {
    
}

#pragma mark - WatchKit
- (void) establishSession {
    if ([WCSession isSupported]) {
        WCSession* session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void) session: (WCSession *) session didReceiveMessage: (NSDictionary <NSString *, id> *) message replyHandler: (void (^)(NSDictionary <NSString *, id> *_Nonnull)) replyHandler {
    replyHandler(@{kPanicButtonKey : @(StopPanicEvent)});

}

@end
