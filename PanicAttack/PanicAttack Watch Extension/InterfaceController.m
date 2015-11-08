//
//  InterfaceController.m
//  PanicAttack Watch Extension
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

static NSString *kEventNotInProgressPanicButtonTitle = @"Start Monitoring";
static NSString *kEventInProgressPanicButtonTitle = @"It's OK now";
static NSString *kPanicButtonWait = @"Wait ...";

static NSString *kPanicButtonKey = @"panicButtonKey";
static NSString *kTimerKey = @"timerKey";
static NSString *kHeartRateKey = @"heartRateKey";

static NSString *kGarWatchErrorTypeCommunicationKey = @"error";

typedef NS_ENUM (NSUInteger, PanicButtonState) {
    EventNotInProgress = 0,
    EventInProgress,
    Waiting,
};

@interface InterfaceController() <WCSessionDelegate, HKWorkoutSessionDelegate>

@property (nonatomic) NSDictionary *panicButtonTitles;
@property (nonatomic) NSDictionary *panicButtonColors;
@property (nonatomic) NSDictionary *panicButtonTitleColors;
@property (nonatomic) NSNumber *panicButtonState;
@property (nonatomic) WCSession* session;
@property (nonatomic) HKWorkoutSession *workoutSession;
@property (nonatomic) HKHealthStore *healthStore;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *panicButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTimer *timer;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *heartRate;
@end

@implementation InterfaceController

#pragma mark - Controller Lifecycle
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    if ([WCSession isSupported]) {
        [self checkAndEstablishSession];
    }
}

- (void)willActivate {
    [super willActivate];

    [self checkAndEstablishSession];

    self.panicButtonState = @(Waiting);
    [self.timer setHidden: YES];
    [self.heartRate setHidden:YES];

    [self handlePanicButtonState];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void) checkAndEstablishSession {
    if (!self.session) {
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    [self.timer setDate: [message valueForKey: kTimerKey]];
    self.panicButtonState = [message valueForKey: kPanicButtonKey];
}

#pragma mark - Actions
- (IBAction)panicButtonAction {
    [self handlePanicButtonState];
}

- (void) displayCommunicationError {
    [self pushControllerWithName: kGarWatchErrorTypeCommunicationKey context: nil];
}

- (void) handlePanicButtonState {
    if ([WCSession defaultSession].reachable) {
        NSNumber *currentButtonState = self.panicButtonState;

        if (self.panicButtonState.unsignedIntegerValue == EventNotInProgress) {
            currentButtonState = @(EventInProgress);
        } else if (self.panicButtonState.unsignedIntegerValue == EventInProgress) {
            currentButtonState = @(EventNotInProgress);
        }

        self.panicButtonState = @(Waiting);

        [[WCSession defaultSession] sendMessage: @{kPanicButtonKey : currentButtonState}
                                   replyHandler: ^(NSDictionary <NSString *, id> *_Nonnull replyMessage) {
                                       [self.timer setDate: [replyMessage valueForKey: kTimerKey]];
                                       self.panicButtonState = [replyMessage valueForKey: kPanicButtonKey];
                                   }
                                   errorHandler: ^(NSError *_Nonnull error) {
                                       [self displayCommunicationError];
                                   }
         ];
    } else {
        [self displayCommunicationError];
    }
}

- (void)setPanicButtonState:(NSNumber *)panicButtonState {
    if (_panicButtonState != panicButtonState) {
        _panicButtonState = panicButtonState;
        [self configurePanicButton];
    }
}

- (void) configurePanicButton {
    if (self.panicButtonState.unsignedIntegerValue == EventInProgress) {
        [self startTimer];
    } else if (self.panicButtonState.unsignedIntegerValue == EventNotInProgress) {
        [self stopTimer];
    }

    NSDictionary *fontAttributes = @{ NSForegroundColorAttributeName : self.panicButtonTitleColors[self.panicButtonState]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:self.panicButtonTitles[self.panicButtonState] attributes: fontAttributes];
    [self.panicButton setAttributedTitle: attributedTitle];
    [self.panicButton setBackgroundColor: self.panicButtonColors[self.panicButtonState]];
}

- (void) startTimer {
    [self.timer start];
    [self.timer setHidden: NO];
    [self startWorkout];
}

- (void) stopTimer {
    [self.timer stop];
    [self.timer setHidden: YES];
    _healthStore = nil;
}

- (NSDictionary *) panicButtonTitles {
    if (!_panicButtonTitles) {
        _panicButtonTitles = @{
                               @(EventNotInProgress) : kEventNotInProgressPanicButtonTitle,
                               @(EventInProgress) : kEventInProgressPanicButtonTitle,
                               @(Waiting) : kPanicButtonWait
                               };
    }

    return _panicButtonTitles;
}

- (NSDictionary *) panicButtonColors {
    if (!_panicButtonColors) {
        _panicButtonColors = @{
                               @(EventNotInProgress) : [UIColor redColor],
                               @(EventInProgress) : [UIColor greenColor],
                               @(Waiting) : [UIColor grayColor]
                               };
    }

    return _panicButtonColors;
}

- (NSDictionary *) panicButtonTitleColors {
    if (!_panicButtonTitleColors) {
        _panicButtonTitleColors = @{
                               @(EventNotInProgress) : [UIColor whiteColor],
                               @(EventInProgress) : [UIColor blackColor],
                               @(Waiting) : [UIColor whiteColor]
                               };
    }

    return _panicButtonTitleColors;
}

- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [HKHealthStore new];
    }

    return _healthStore;
}

- (void) startWorkout {
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierHeartRate];
    NSSet *dataTypes = [NSSet setWithObject:quantityType];
    [self.healthStore requestAuthorizationToShareTypes: nil readTypes:dataTypes completion:^(BOOL success, NSError * _Nullable error) {

    }];
    // Create a new workout session
    self.workoutSession = [[HKWorkoutSession alloc] initWithActivityType:HKWorkoutActivityTypeOther locationType: HKWorkoutSessionLocationTypeIndoor];
    self.workoutSession.delegate = self;

    // Start the workout session
    [self.healthStore startWorkoutSession: self.workoutSession];

}

#pragma mark HKWorkoutSessionDelegate
-(void)workoutSession:(HKWorkoutSession *)workoutSession didFailWithError:(NSError *)error {

}

-(void)workoutSession:(HKWorkoutSession *)workoutSession didChangeToState:(HKWorkoutSessionState)toState fromState:(HKWorkoutSessionState)fromState date:(NSDate *)date {
    if (toState == HKWorkoutSessionStateRunning) {
        [self getHeartRate];
    }
}

- (void) getHeartRate {
    HKSampleType *sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitSecond value: -10 toDate: endDate options: 0];
    // Match samples with a start date after the workout start
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate: startDate endDate: nil  options: HKQueryOptionStrictStartDate];
    HKQueryAnchor *anchor = [HKQueryAnchor anchorFromValue: HKAnchoredObjectQueryNoAnchor];
    HKAnchoredObjectQuery *query = [[HKAnchoredObjectQuery alloc] initWithType:sampleType predicate:predicate anchor: anchor limit: HKObjectQueryNoLimit resultsHandler:^(HKAnchoredObjectQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable sampleObjects, NSArray<HKDeletedObject *> * _Nullable deletedObjects, HKQueryAnchor * _Nullable newAnchor, NSError * _Nullable error) {
        if (error) {
            // Perform proper error handling here...
            // NSLog(@"*** An error occured while performing the anchored object query. %@ ***", error.localizedDescription);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                HKUnit *heartRateUnit = [HKUnit unitFromString: @"count/min"];
                HKQuantitySample *sample = [sampleObjects firstObject];
                double value = [sample.quantity doubleValueForUnit: heartRateUnit];
                if (value > 0.001) {
                    [self.heartRate setHidden: NO];
                    NSString *heartRate = [NSString stringWithFormat:@"%.0fbpm", value];
                    [self.heartRate setText: heartRate];
                    [[WCSession defaultSession] sendMessage: @{kHeartRateKey : [NSString stringWithFormat:@"%.0f", value]}
                                               replyHandler: ^(NSDictionary <NSString *, id> *_Nonnull replyMessage) {
                                               }
                                               errorHandler: ^(NSError *_Nonnull error) {
                                               }
                     ];

                }
                [self getHeartRate];
            });
        }
    }];

    [self.healthStore executeQuery: query];
}
@end
