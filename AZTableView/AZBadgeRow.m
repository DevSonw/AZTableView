//
//  AZBadgeRow.m
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZBadgeRow.h"
#import "AZBadgeTableViewCell.h"

@implementation AZBadgeRow

@synthesize badge, badgeColor, badgeTextColor;

- (id)init{
    if (self = [super init]) {
        self.badgeColor = [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
        self.badgeTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)updateCell:(AZBadgeTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.badgeLabel.text = self.badge;
    cell.badgeLabel.textColor = self.badgeTextColor;
    cell.badgeLabel.badgeColor = self.badgeColor;
}

- (Class)cellClass{
    return [AZBadgeTableViewCell class];
}


@end
