//
//  AZButtonRow.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/3.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButtonRow.h"
#import "AZButtonTableViewCell.h"
#import "AZTableView.h"

@implementation AZButtonRow


- (void)updateCell:(AZTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    cell.accessibilityTraits = UIAccessibilityTraitButton;
}

- (Class)cellClass{
    return [AZButtonTableViewCell class];
}

- (void)selected:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super selected:tableView indexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
