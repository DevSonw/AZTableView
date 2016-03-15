//
//  AZHtmlRow.h
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZRow.h"

@interface AZHtmlRow : AZRow
@property(nonatomic, strong) NSString *html;
@property(nonatomic, assign) NSInteger htmlTextLine;
@property(nonatomic, strong) NSString *onLink;
@end
