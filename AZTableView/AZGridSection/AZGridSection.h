//
//  AZGridSection.h
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZSection.h"

@interface AZGridSection : AZSection

@property(nonatomic, strong) NSArray *items;
@property(nonatomic, assign) CGFloat reduceWidth;

@end
