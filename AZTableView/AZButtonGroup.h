//
//  AZButtonGroup.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZButton.h"

@interface AZButtonGroup : UIView

@property(nonatomic, copy) void (^clickHandler)(NSUInteger index, AZButton *button);
@property (retain, nonatomic) NSArray *buttons;
@property (retain, nonatomic) UIColor *separatorColor;

@end
