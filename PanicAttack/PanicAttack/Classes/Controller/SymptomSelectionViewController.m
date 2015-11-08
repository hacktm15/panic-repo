//
//  SymptomSelectionViewController.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/8/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "SymptomSelectionViewController.h"

static NSString * const kSymptomsTitles[] = {@"racing or pounding heart", @"fear of dying", @"fear of losing control", @"fear of going crazy", @"difficulty breathing", @"feeling light headed", @"chest pain or discomfort", @"tingling or numbness", @"hot flushes or cold chills", @"muscle tightness", @"feeling of unreality", @"blurred vision", @"dizziness, faintness", @"shaking or trembling", @"nausea, stomach problems"};
static const NSInteger kSymptomsCount = 15;

@interface SymptomSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SymptomSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableArray *selectedSymptoms = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [selectedSymptoms addObject:kSymptomsTitles[indexPath.row]];
    }
    
    [self.delegate symptomSelectionViewController:self didSelectSymptoms:selectedSymptoms];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kSymptomsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    NSString *title = kSymptomsTitles[indexPath.row];
    cell.textLabel.text = title;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    for (NSString *selectedSymptom in self.selectedSymptoms) {
        if ([title isEqualToString:selectedSymptom]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

@end
