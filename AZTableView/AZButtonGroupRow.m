//
//  AZButtonGroupRow.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButtonGroupRow.h"
#import "AZButtonGroupTableViewCell.h"
#import "AZTableView.h"

@implementation AZButtonGroupRow


- (Class)cellClass{
    return [AZButtonGroupTableViewCell class];
}

- (void)updateCell:(AZButtonGroupTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    cell.buttonGroup.separatorColor = self.separatorColor ? self.separatorColor : tableView.separatorColor;
    cell.buttonGroup.buttons = self.items;
    __weak AZRow *weakRow = self;
    __weak AZButtonGroupTableViewCell *weakCell = cell;
    cell.buttonGroup.clickHandler = ^(NSUInteger index, AZButton *button){
        self.value = @(index);
        if(self.onSelect){
            self.onSelect(weakRow, weakCell);
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)selected:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
}

@end
