//
//  TextInputViewController.m
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "TextInputViewController.h"

@interface TextInputViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) NSString *text;

@end

@implementation TextInputViewController

- (NSString *)title {
    return @"Your Observations";
}

- (instancetype)initWithText:(NSString *)text {
    if (self = [super initWithNibName:@"TextInputViewController" bundle:nil]) {
        _text = text;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.textView.text = self.text;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.text = self.textView.text;
    
    self.willDismiss(self.text);
}

@end
