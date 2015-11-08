//
//  ScaleTableViewCellProtocol.h
//  PanicAttack
//
//  Created by Norbert Nagy on 08/11/15.
//  Copyright © 2015 PanicTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScaleTableViewCell;

typedef void (^ScaleValueChangedBlock)(ScaleTableViewCell *cell);

@protocol ScaleTableViewCellProtocol <NSObject>

@end
