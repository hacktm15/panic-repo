//
//  TextInputViewController.h
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextInputViewControllerWillDismissBlock)(NSString *);

@interface TextInputViewController : UIViewController

@property (nonatomic, copy) TextInputViewControllerWillDismissBlock willDismiss;

- (instancetype)initWithText:(NSString *)text;

@end
