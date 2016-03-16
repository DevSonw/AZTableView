//
//  AZGridRow.m
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZGridRow.h"
#import "AZGridTableViewCell.h"
#import "AZTableView.h"
@interface AZGridRow()

@end


@implementation AZGridRow
@synthesize items;

- (void)updateCell:(AZGridTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.textLabel.text = @"  ";
    cell.items = self.items;
}

- (Class)cellClass
{
    return [AZGridTableViewCell class];
}
@end
