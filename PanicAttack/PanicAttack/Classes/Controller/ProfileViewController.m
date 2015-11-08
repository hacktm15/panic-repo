//
//  ProfileViewController.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/7/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfile.h"

#define kMinWeight 30

typedef NS_ENUM(NSInteger, PickerViewType) {
    PickerViewTypeNone,
    PickerViewTypeSex,
    PickerViewTypeBirthDate,
    PickerViewTypeWeight
};

@interface ProfileViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cells;

@property (nonatomic) PickerViewType pickerViewType;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomConstraint;
//
//@property (nonatomic) NSNumber *selectedWeight;
//@property (nonatomic) NSNumber *selectedSex;
//@property (nonatomic) NSDate *selectedBirthDate;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"UserUpdated" object:nil];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
//    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    self.pickerViewType = PickerViewTypeNone;
}

- (NSString *)title {
    return @"Profile";
}

#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd / MM / yyyy"];
    }
    
    return dateFormatter;
}

- (void)setPickerViewType:(PickerViewType)pickerViewType {
    if (_pickerViewType != pickerViewType) {
        _pickerViewType = pickerViewType;
        
//        [self.pickerView reloadAllComponents];
//        
//        self.datePickerBottomConstraint.constant = -216;
//        self.pickerViewBottomConstraint.constant = -216;
//        if (pickerViewType == PickerViewTypeBirthDate) {
//            self.datePickerBottomConstraint.constant = 0;
//            self.datePicker.date = self.selectedBirthDate ? : self.datePicker.date;
//            self.birthDateLabel.text = self.datePicker.date.description;
//            self.birthDateLabel.textColor = [UIColor darkTextColor];
//        } else if (pickerViewType == PickerViewTypeSex) {
//            [self.pickerView selectRow:self.selectedSex.integerValue inComponent:0 animated:NO];
//            self.sexLabel.text = [self pickerView:self.pickerView titleForRow:self.selectedSex.integerValue forComponent:0];
//            self.sexLabel.textColor = [UIColor darkTextColor];
//            self.pickerViewBottomConstraint.constant = 0;
//        } else if (pickerViewType == PickerViewTypeWeight) {
//            [self.pickerView selectRow:MAX(0, self.selectedWeight.integerValue - kMinWeight) inComponent:0 animated:NO];
//            self.weightLabel.text = [self pickerView:self.pickerView titleForRow:MAX(0, self.selectedWeight.integerValue - kMinWeight) forComponent:0];
//            self.weightLabel.textColor = [UIColor darkTextColor];
//            self.pickerViewBottomConstraint.constant = 0;
//        }
//        
//        [UIView animateWithDuration:.3f animations:^{
//            [self.view layoutIfNeeded];
//        }];
    }
}

#pragma mark - Actions

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.view];
    
    __block BOOL didTapInCell = NO;
    [self.cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, tapLocation)) {
            if (idx == 2) {
                self.pickerViewType = PickerViewTypeSex;
                [self.view endEditing:YES];
            } else if (idx == 3) {
                self.pickerViewType = PickerViewTypeBirthDate;
                [self.view endEditing:YES];
            } else if (idx == 4) {
                self.pickerViewType = PickerViewTypeWeight;
                [self.view endEditing:YES];
            } else {
                self.pickerViewType = PickerViewTypeNone;
            }
            
            didTapInCell = YES;
            *stop = YES;
        }
    }];
    
    if (!didTapInCell) {
        self.pickerViewType = PickerViewTypeNone;
    }
}

- (IBAction)datePickerValueDidChange:(id)sender {
//    self.selectedBirthDate = self.datePicker.date;
//    self.birthDateLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
//
//    [self updateUser];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.pickerViewType = PickerViewTypeNone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.firstNameTextField) {
        [UserProfile sharedInstance].user.firstName = self.firstNameTextField.text;
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [UserProfile sharedInstance].user.lastName = self.lastNameTextField.text;
        self.pickerViewType = PickerViewTypeSex;
    }
    
    return YES;
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case PickerViewTypeWeight:
            return 200;
            
        case PickerViewTypeSex:
            return 2;
            
        default:
            return 0;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.pickerViewType == PickerViewTypeSex) {
        return (row == 0) ? @"M" : @"F";
    } else {
        return [NSString stringWithFormat:@"%ld Kg", (long)row + kMinWeight];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (self.pickerViewType == PickerViewTypeSex) {
//        self.selectedSex = @(row);
//        self.sexLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//        
//        [self updateUser];
//    } else {
//        self.selectedWeight = @(row + kMinWeight);
//        self.weightLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//
//        [self updateUser];
//    }
}

#pragma mark - Private

- (void)updateUI {
    dispatch_async(dispatch_get_main_queue(), ^{
    self.firstNameTextField.text = [UserProfile sharedInstance].user.firstName;
    self.lastNameTextField.text = [UserProfile sharedInstance].user.lastName;
    
    if ([UserProfile sharedInstance].user.weight) {
        self.weightLabel.text = [NSString stringWithFormat:@"%ld Kg", [UserProfile sharedInstance].user.weight.integerValue];
        self.weightLabel.textColor = [UIColor darkTextColor];
    } else {
        self.weightLabel.text = @"Update in Health App";
        self.weightLabel.textColor = [UIColor lightGrayColor];
    }
    
    if ([UserProfile sharedInstance].user.sex) {
        self.sexLabel.text = ([UserProfile sharedInstance].user.sex.integerValue == 0) ? @"M" : @"F";
        self.sexLabel.textColor = [UIColor darkTextColor];
    } else {
        self.sexLabel.text = @"Update in Health App";
        self.sexLabel.textColor = [UIColor lightGrayColor];
    }
    
    if ([UserProfile sharedInstance].user.birthDate) {
        self.birthDateLabel.text = [self.dateFormatter stringFromDate:[UserProfile sharedInstance].user.birthDate];
        self.birthDateLabel.textColor = [UIColor darkTextColor];
    } else {
        self.birthDateLabel.text = @"Update in Health App";
        self.birthDateLabel.textColor = [UIColor lightGrayColor];
    }
    });
}

- (void)updateUser {
//    [UserProfile sharedInstance].user.firstName = self.firstNameTextField.text;
//    [UserProfile sharedInstance].user.lastName = self.lastNameTextField.text;
//    [UserProfile sharedInstance].user.weight = self.selectedWeight;
//    [UserProfile sharedInstance].user.sex = self.selectedSex;
//    [UserProfile sharedInstance].user.birthDate = self.selectedBirthDate;
//    
//    [[UserProfile sharedInstance].user saveInBackground];
}

@end
