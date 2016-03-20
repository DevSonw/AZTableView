//
//  AZButtonGroupTableViewCell.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewCell.h"
#import "AZButtonGroup.h"

@interface AZButtonGroupTableViewCell : AZTableViewCell

@property(nonatomic, retain, readonly) AZButtonGroup *buttonGroup;

@end
