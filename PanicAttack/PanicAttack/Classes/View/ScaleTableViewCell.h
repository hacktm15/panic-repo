//
//  ScaleTableViewCell.h
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleTableViewCellProtocol.h"

@interface ScaleTableViewCell : UITableViewCell <ScaleTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scale;

@property (copy, nonatomic) ScaleValueChangedBlock scaleValueChanged;

- (void)selectScaleIndex:(NSInteger)index;
- (void)setTitlesForSegment:(NSArray<NSString *> *)titles;

@end