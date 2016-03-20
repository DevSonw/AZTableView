//
//  AZHtmlTableViewCell.h
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewCell.h"
#import "MDHTMLLabel.h"

@interface AZHtmlTableViewCell : AZTableViewCell<MDHTMLLabelDelegate>
@property (nonatomic, retain) MDHTMLLabel *htmlLabel;
@property (nonatomic, copy) void (^clickHandler)(NSURL *URL);
@end
