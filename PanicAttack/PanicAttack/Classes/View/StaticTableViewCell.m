//
//  StaticTableViewCell.m
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import "StaticTableViewCell.h"

@implementation StaticTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [self.label layoutIfNeeded];
    self.label.preferredMaxLayoutWidth = CGRectGetWidth(self.label.bounds);
    
    [super layoutSubviews];
}

@end
