//
//  PanicViewController.m
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "PanicViewController.h"
#import "DataHandler.h"
#import "AppDelegate.h"
#import "PanicEventViewController.h"
#import "UserProfile.h"
#import "Event.h"
#import <HealthKit/HealthKit.h>

@interface PanicViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic) BOOL inProgress;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *stopDate;
@property (nonatomic) NSTimer *timer;

@end

@implementation PanicViewController

- (NSString *)title {
    return @"Panic";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startStopButton.layer.borderWidth = 1.0;
    self.startStopButton.layer.borderColor = [UIColor blueColor].CGColor;
    
    self.timerLabel.text = @"";
    
    self.inProgress = NO;
    [self.startStopButton setTitle: self.inProgress ? @"Stop" : @"Start" forState: UIControlStateNormal];
}

#pragma mark - Private

- (void)setInProgress:(BOOL)inProgress {
    if (self.inProgress != inProgress) {
        _inProgress = inProgress;
        
        [self.startStopButton setTitle: self.inProgress ? @"Stop" : @"Start" forState: UIControlStateNormal];
        if (self.inProgress) {
            [self startPanicEvent];
        } else {
            [self stopPanicEvent];
        }
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel eventProgressChangedInApp: self.inProgress];
    }
}

- (NSString *) formatedTime {
    return [NSString stringWithFormat: @"%.0f", [[NSDate date] timeIntervalSinceDate: self.startDate]];
}

- (void) startPanicEvent {
    self.startDate = [NSDate date];
    self.timerLabel.text = @"0";
    
    [self starTimer];
}

- (void) stopPanicEvent {
    [self stopTimer];
    self.stopDate = [NSDate date];
    
    [self navigateToEvent];
}

- (void) starTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(tick:) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.timerLabel.text = @"";
}

- (void) tick: (NSTimer *) timer {
    self.timerLabel.text = [self formatedTime];
}

- (void)navigateToEvent {
#warning CONVERT DATE TO SYSTEM TIMEZONE
    Event *newEvent = [[UserProfile sharedInstance].dataHandler createEventWithStartDate: self.startDate];
    PanicEventViewController *panicEventVC = [[PanicEventViewController alloc] initWithEvent: newEvent];
    [self.navigationController pushViewController: panicEventVC animated: YES];
    
//    [[UserProfile sharedInstance].dataHandler fetchEventsWithCompletionBlock:^(NSArray<Event *> * _Nullable objects, NSError * _Nullable error) {
//        PanicEventViewController *panicEventVC = [[PanicEventViewController alloc] initWithEvent: [objects firstObject]];
//        [self.navigationController pushViewController: panicEventVC animated: YES];
//    }];
}

#pragma mark - Public

- (BOOL)isEventInProgress {
    return self.inProgress;
}

- (void)changeEventToInProgress:(BOOL)status {
    if (self.inProgress == status) {
        return;
    }
    self.inProgress = status;
}

- (NSDate *) getTimerStartDate {
    return self.startDate;
}

#pragma mark - Actions

- (IBAction)startStopButtonPressed:(id)sender {
    self.inProgress = !self.inProgress;
}

#pragma mark - HeartBeat
@end
