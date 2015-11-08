//
//  ScaleTableViewCell.m
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "ScaleTableViewCell.h"

@implementation ScaleTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)scaleValueChanged:(id)sender {
    self.scaleValueChanged(self);
}

#pragma mark - Public

- (void)selectScaleIndex:(NSInteger)index {
    self.scale.selectedSegmentIndex = index;
}

- (void)setTitlesForSegment:(NSArray<NSString *> *)titles {
    [self.scale removeAllSegments];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scale insertSegmentWithTitle:obj atIndex:idx animated:NO];
    }];
}

@end
