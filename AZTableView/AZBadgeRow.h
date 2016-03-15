//
//  AZBadgeRow.h
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZRow.h"

@interface AZBadgeRow : AZRow

@property(nonatomic, retain) UIColor *badgeTextColor;
@property(nonatomic, retain) UIColor *badgeColor;
@property(nonatomic, strong) NSString *badge;


@end
