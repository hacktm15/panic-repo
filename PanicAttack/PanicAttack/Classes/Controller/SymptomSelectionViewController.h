//
//  SymptomSelectionViewController.h
//  PanicAttack
//
//  Created by Vlad Rusu on 11/8/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SymptomSelectionViewControllerDelegate;

@interface SymptomSelectionViewController : UIViewController

@property (weak, nonatomic) id<SymptomSelectionViewControllerDelegate> delegate;
@property (nonatomic) NSArray *selectedSymptoms;

@end

@protocol SymptomSelectionViewControllerDelegate <NSObject>

- (void)symptomSelectionViewController:(SymptomSelectionViewController *)symptomSelectionVC didSelectSymptoms:(NSArray *)symptoms;

@end
