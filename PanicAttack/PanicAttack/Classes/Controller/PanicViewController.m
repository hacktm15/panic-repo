//
//  PanicViewController.m
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "PanicViewController.h"

@interface PanicViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic) BOOL inProgress;
@property (nonatomic) NSDate *startDate;
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
}

#pragma mark - Private

- (NSString *) formatedTime {
    return [NSString stringWithFormat: @"%.0f", [[NSDate date] timeIntervalSinceDate: self.startDate]];
}

- (void) starTimer {
    self.startDate = [NSDate date];
    self.timerLabel.text = @"0";
    
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

#pragma mark - Actions

- (IBAction)startStopButtonPressed:(id)sender {
    self.inProgress = !self.inProgress;
    
    [self.startStopButton setTitle: self.inProgress ? @"Stop" : @"Start" forState: UIControlStateNormal];
    if (self.inProgress) {
        [self starTimer];
    } else {
        [self stopTimer];
    }
}

@end
