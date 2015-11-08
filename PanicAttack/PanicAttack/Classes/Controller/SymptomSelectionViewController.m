//
//  SymptomSelectionViewController.m
//  PanicAttack
//
//  Created by Vlad Rusu on 11/8/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "SymptomSelectionViewController.h"

static NSString * const kSymptomsTitles[] = {@"racing or pounding heart", @"fear of dying", @"fear of losing control", @"fear of going crazy", @"difficulty breathing", @"other symptom", @"feeling light headed", @"chest pain or discomfort", @"tingling or numbness", @"hot flushes or cold chills", @"muscle tightness", @"other symptom", @"feeling of unreality", @"blurred vision", @"dizziness, faintness", @"shaking or trembling", @"nausea, stomach problems"};
static const NSInteger kSymptomsCount = 23;

@interface SymptomSelectionViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SymptomSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - Actions

- (void)doneButtonPressed:(id)sender {
    NSMutableArray *selectedSymptoms = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [selectedSymptoms addObject:kSymptomsTitles[indexPath.row]];
    }
    
    [self.delegate symptomSelectionViewController:self didSelectSymptoms:selectedSymptoms];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kSymptomsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = kSymptomsTitles[indexPath.row];
    
    return cell;
}

@end
