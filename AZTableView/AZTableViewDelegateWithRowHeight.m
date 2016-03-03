//
//  AZTableViewDelegateWithRowHeight.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewDelegateWithRowHeight.h"
#import "AZTableView.h"

@implementation AZTableViewDelegateWithRowHeight

- (CGFloat)tableView:(AZTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    return [row heightForTableView:tableView];
}

@end
