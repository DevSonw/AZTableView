//
//  AZButtonGroupRow.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZRow.h"
#import "AZButton.h"

@interface AZButtonGroupRow : AZRow

@property (retain, nonatomic) NSArray *items; ///< Button items, support create by YYModel dictionary
@property (retain, nonatomic) UIColor *separatorColor; ///< Separator color between buttons, default tableView separator color.

@end
