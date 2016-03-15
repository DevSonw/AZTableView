//
//  AZButtonGroupTableViewCell.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButtonGroupTableViewCell.h"

@implementation AZButtonGroupTableViewCell

@synthesize buttonGroup = _buttonGroup;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _buttonGroup = [[AZButtonGroup alloc] init];
        [self.contentView addSubview:_buttonGroup];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _buttonGroup.frame = self.contentView.bounds;
}

@end
