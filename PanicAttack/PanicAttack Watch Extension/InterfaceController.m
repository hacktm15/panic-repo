//
//  InterfaceController.m
//  PanicAttack Watch Extension
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

static NSString *kPanicButtonKey = @"panicButtonKey";
static NSString *kPanicButtonStart = @"Panic";
static NSString *kPanicButtonStop = @"It's OK now";
static NSString *kPanicButtonWait = @"Wait ...";

typedef NS_ENUM (NSUInteger, PanicButtonState) {
    StartPanicEvent = 0,
    StopPanicEvent,
    Waiting,
};

@interface InterfaceController() <WCSessionDelegate>

@property (nonatomic) NSDictionary *panicButtonTitles;
@property (nonatomic) NSDictionary *panicButtonColors;
@property (nonatomic) NSNumber *panicButtonState;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *panicButton;
@end

@implementation InterfaceController

#pragma mark - Controller Lifecycle
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.panicButtonState = @(Waiting);
}

- (void)willActivate {
    [super willActivate];

    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];

    [self handlePanicButtonState];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Actions
- (IBAction)panicButtonAction {
    [self handlePanicButtonState];
}

- (void) displayCommunicationError {

}

- (void) handlePanicButtonState {
    if ([WCSession defaultSession].reachable) {
        NSNumber *buttonState = self.panicButtonState;
        self.panicButtonState = @(Waiting);

        [[WCSession defaultSession] sendMessage: @{ kPanicButtonKey : self.panicButtonTitles[buttonState]} replyHandler: ^(NSDictionary <NSString *, id> *_Nonnull replyMessage) {
            self.panicButtonState = [replyMessage valueForKey: kPanicButtonKey];
        } errorHandler: ^(NSError *_Nonnull error) {
            [self displayCommunicationError];
        }];
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
    [self.panicButton setTitle: self.panicButtonTitles[self.panicButtonState]];
    [self.panicButton setBackgroundColor: self.panicButtonColors[self.panicButtonState]];
}

- (NSDictionary *) panicButtonTitles {
    if (!_panicButtonTitles) {
        _panicButtonTitles = @{
                              @(StartPanicEvent) : kPanicButtonStart,
                              @(StopPanicEvent) : kPanicButtonStop,
                              @(Waiting) : kPanicButtonWait
                              };
    }

    return _panicButtonTitles;
}

- (NSDictionary *) panicButtonColors {
    if (!_panicButtonColors) {
        _panicButtonColors = @{
                              @(StartPanicEvent) : [UIColor redColor],
                              @(StopPanicEvent) : [UIColor greenColor],
                              @(Waiting) : [UIColor grayColor]
                              };
    }

    return _panicButtonColors;
}

@end



