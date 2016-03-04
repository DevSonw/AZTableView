//
//  AZFieldRow.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZFieldRow.h"

@implementation AZFieldRow


- (AZFieldTableViewCell *)createCellForTableView:(AZTableView *)tableView{
    AZFieldTableViewCell *cell = (AZFieldTableViewCell *)[super createCellForTableView:tableView];
    cell.delegate = self;
    return cell;
}

@end
