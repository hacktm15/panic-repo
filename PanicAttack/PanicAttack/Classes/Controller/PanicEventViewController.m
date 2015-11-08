//
//  PanicEventViewController.m
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "PanicEventViewController.h"
#import "StaticTableViewCell.h"
#import "ScaleTableViewCell.h"
#import "TextInputViewController.h"
#import "Event.h"

static NSString *staticTableCellIdentifier = @"staticTableCellIdentifier";
static NSString *scaleTableCellIdentifier = @"scaleTableCellIdentifier";

static NSInteger const kScaleMeterIndexAndValueMappingOffset = 1;


@interface PanicEventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventDetailsTable;

@property (nonatomic) Event *event;

@end


@implementation PanicEventViewController

- (NSString *)title {
    return @"Details";
}

- (instancetype)initWithEvent:(Event *)event {
    if (self = [super initWithNibName:@"PanicEventViewController" bundle:nil]) {
        _event = event;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.eventDetailsTable registerNib:[UINib nibWithNibName:@"StaticTableViewCell" bundle:nil] forCellReuseIdentifier:staticTableCellIdentifier];
    [self.eventDetailsTable registerNib:[UINib nibWithNibName:@"ScaleTableViewCell" bundle:nil] forCellReuseIdentifier:scaleTableCellIdentifier];
    
    self.eventDetailsTable.estimatedRowHeight = 44.0;
    self.eventDetailsTable.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 5;
            break;
        default:
            rows = 1;
            break;
    };
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    switch (section) {
        case 0:
            sectionTitle = @"Context Info";
            break;
        case 1:
            sectionTitle = @"Describe Your Panic Attack";
            break;
        default:
            sectionTitle = @"";
            break;
    }
    
    return sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: //Anxiety
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:scaleTableCellIdentifier forIndexPath:indexPath];
                    ((ScaleTableViewCell *)cell).label.text = @"On a scale of 0-10 (0 = not anxious, 10 = extremely anxious), what was your level of anxiety?";
                    if (self.event.anxietyLevel) {
                        [((ScaleTableViewCell *)cell) selectScaleIndex:self.event.anxietyLevel.integerValue - kScaleMeterIndexAndValueMappingOffset];
                    }
                    
                    ((ScaleTableViewCell *)cell).scaleValueChanged = ^(ScaleTableViewCell *tableCell) {
                        NSInteger value = tableCell.scale.selectedSegmentIndex + kScaleMeterIndexAndValueMappingOffset;
                        self.event.anxietyLevel = @(value);
                        [self.event saveInBackground];
                    };
                    break;
                }
                case 1: //Depression
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:scaleTableCellIdentifier forIndexPath:indexPath];
                    ((ScaleTableViewCell *)cell).label.text = @"On a scale of 0-10 (0 = not depressed, 10 = extremely depressed), what was your level of depression?";
                    if (self.event.depressionLevel) {
                        [((ScaleTableViewCell *)cell) selectScaleIndex:self.event.depressionLevel.integerValue - kScaleMeterIndexAndValueMappingOffset];
                    }
                    
                    ((ScaleTableViewCell *)cell).scaleValueChanged = ^(ScaleTableViewCell *tableCell) {
                        NSInteger value = tableCell.scale.selectedSegmentIndex + kScaleMeterIndexAndValueMappingOffset;
                        self.event.depressionLevel = @(value);
                        [self.event saveInBackground];
                    };
                    break;
                }
                default:
                    break;
            }
            break;
        case 1: //Descripe your panic attack
            switch (indexPath.row) {
                case 0: //Expected
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:scaleTableCellIdentifier forIndexPath:indexPath];
                    ((ScaleTableViewCell *)cell).label.text = @"Was your attack expected or unexpected?";
                    [((ScaleTableViewCell *)cell) setTitlesForSegment: @[@"Expected", @"Unexpected"]];
                    if (self.event.expected) {
                        [((ScaleTableViewCell *)cell) selectScaleIndex:self.event.expected.boolValue ? 0 : 1];
                    }
                    
                    ((ScaleTableViewCell *)cell).scaleValueChanged = ^(ScaleTableViewCell *tableCell) {
                        BOOL value = tableCell.scale.selectedSegmentIndex == 0 ? YES : NO;
                        self.event.expected = @(value);
                        [self.event saveInBackground];
                    };
                    break;
                }
                case 1: //Cause
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:scaleTableCellIdentifier forIndexPath:indexPath];
                    ((ScaleTableViewCell *)cell).label.text = @"Was your panic attack triggered by a situation or thought?";
                    [((ScaleTableViewCell *)cell) setTitlesForSegment: @[@"Situation", @"Thought"]];
                    if (self.event.cause) {
                        [((ScaleTableViewCell *)cell) selectScaleIndex:self.event.cause.integerValue];
                    }
                    
                    ((ScaleTableViewCell *)cell).scaleValueChanged = ^(ScaleTableViewCell *tableCell) {
                        NSInteger value = tableCell.scale.selectedSegmentIndex;
                        self.event.cause = @(value);
                        [self.event saveInBackground];
                    };
                    break;
                }
                case 2: //Symptoms
                    cell = [tableView dequeueReusableCellWithIdentifier:staticTableCellIdentifier forIndexPath:indexPath];
                    ((StaticTableViewCell *)cell).label.text = @"No panic symptom selected";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 3: //Fear
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:scaleTableCellIdentifier forIndexPath:indexPath];
                    ((ScaleTableViewCell *)cell).label.text = @"What was your level of fear (0 = no fear, 10 = extreme fear)?";
                    if (self.event.fearLevel) {
                        [((ScaleTableViewCell *)cell) selectScaleIndex:[self.event.fearLevel integerValue] - kScaleMeterIndexAndValueMappingOffset];
                    }
                    
                    ((ScaleTableViewCell *)cell).scaleValueChanged = ^(ScaleTableViewCell *tableCell) {
                        NSInteger value = tableCell.scale.selectedSegmentIndex + kScaleMeterIndexAndValueMappingOffset;
                        self.event.fearLevel = @(value);
                        [self.event saveInBackground];
                    };
                    break;
                }
                case 4: //Observations
                    cell = [tableView dequeueReusableCellWithIdentifier:staticTableCellIdentifier forIndexPath:indexPath];
                    ((StaticTableViewCell *)cell).label.text = @"Your observations";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 2: //Symptoms
                
                break;
            case 4: { //Observations
                TextInputViewController *textInputVC = [[TextInputViewController alloc] initWithText: self.event.observations];
                textInputVC.willDismiss = ^(NSString *text) {
                    self.event.observations = text;
                    [self.event saveInBackground];
                };
                [self.navigationController pushViewController:textInputVC animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

@end
