//
//  AZBadgeTableViewCell.h
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewCell.h"
#import "AZBadgeLabel.h"

@interface AZBadgeTableViewCell : AZTableViewCell

@property(nonatomic, readonly, strong) AZBadgeLabel *badgeLabel;

@end
