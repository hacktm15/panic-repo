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
#import "PanicEventViewController.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventTable;
@property (nonatomic) NSArray<Event *> *events;

@end

@implementation HistoryViewController

- (NSString *)title {
    return @"History";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.eventTable registerClass: [UITableViewCell class] forCellReuseIdentifier: @"EventCellIdentifier"];
    
    [[UserProfile sharedInstance].dataHandler fetchEventsWithCompletionBlock:^(NSArray<Event *> * _Nullable objects, NSError * _Nullable error) {
        self.events = objects;
        
        [self.eventTable reloadData];
    }];
}

- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:[self title] image:[UIImage imageNamed:@"noun_25104_cc"] tag:2];
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
    
    cell.textLabel.text = self.events[indexPath.row].startDate.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PanicEventViewController *panicEventVC = [[PanicEventViewController alloc] initWithEvent: self.events[indexPath.row]];
    [self.navigationController pushViewController: panicEventVC animated: YES];
}

@end
