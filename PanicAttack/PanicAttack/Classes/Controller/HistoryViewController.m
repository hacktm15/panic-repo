//
//  HistoryViewController.m
//  PanicAttack
//
//  Created by Norbert Nagy on 07/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "HistoryViewController.h"
#import "DataHandler.h"
#import "UserProfile.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventTable;
@property (nonatomic) NSArray *events;

@end

@implementation HistoryViewController

- (NSString *)title {
    return @"History";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.eventTable registerClass: [UITableViewCell class] forCellReuseIdentifier: @"EventCellIdentifier"];
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventCellIdentifier" forIndexPath: indexPath];
    
    return cell;
}

@end
