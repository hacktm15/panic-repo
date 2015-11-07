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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"Docs folder: %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    
    if (![[UserProfile sharedInstance].dataHandler fetchLoggedUser]) {
        [self createDummyData];
    }
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabController = [UITabBarController new];
    tabController.title = @"Panic Attack";
    tabController.viewControllers = [self tabViewControllers];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tabController];
    
    [self.window setRootViewController: navController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSArray *) tabViewControllers {
    PanicViewController *panicVC = [[PanicViewController alloc] initWithNibName: @"PanicViewController" bundle: nil];
    
    HistoryViewController *historyVC = [[HistoryViewController alloc] initWithNibName: @"HistoryViewController" bundle: nil];
    
    return @[panicVC, historyVC];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Private

- (void)createDummyData {
    User *user = [[UserProfile sharedInstance].dataHandler createUserWithEmail:@"user@email.com"];
    
    Event *event = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate date]];
    event.user = user;
    event = [[UserProfile sharedInstance].dataHandler createEventWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-518400]];
    event.user = user;
    event.anxietyLevel = @(5);
    event.depressionLevel = @(10);
    event.expected = @(NO);
    event.cause = @(0);
    event.fearLevel = @(7);
    event.observations = @"Some observations";

    NSSet *medications = [NSSet setWithArray:@[[[UserProfile sharedInstance].dataHandler createMedicationWithName:@"cancer cure"], [[UserProfile sharedInstance].dataHandler createMedicationWithName:@"AIDS cure"], [[UserProfile sharedInstance].dataHandler createMedicationWithName:@"cantest cure"]]];
    event.medications = medications;

    NSSet *symptoms = [NSSet setWithArray:@[[[UserProfile sharedInstance].dataHandler createSymptomWithName:@"symptom one"],[[UserProfile sharedInstance].dataHandler createSymptomWithName:@"symptom two"], [[UserProfile sharedInstance].dataHandler createSymptomWithName:@"three"]]];
    event.symptoms = symptoms;
    
    [[UserProfile sharedInstance].dataHandler save];
    
    NSLog(@"%@", [[UserProfile sharedInstance].dataHandler fetchEvents]);
}

@end
