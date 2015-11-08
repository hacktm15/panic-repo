//
//  PanicViewController.h
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanicViewController : UIViewController

- (BOOL)isEventInProgress;
- (void)changeEventToInProgress:(BOOL)status;
- (NSDate *) getTimerStartDate;
- (void) updateHeartRate: (NSString *)heartRate;
@end
