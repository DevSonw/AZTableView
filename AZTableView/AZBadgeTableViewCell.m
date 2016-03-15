//
//  AZBadgeTableViewCell.m
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZBadgeTableViewCell.h"

@implementation AZBadgeTableViewCell


@synthesize badgeLabel = _badgeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _badgeLabel = [[AZBadgeLabel alloc] init];
        [self.contentView addSubview:_badgeLabel];
        _badgeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _badgeLabel.contentMode = UIViewContentModeRedraw;
        //        _badgeLabel.contentStretch = CGRectMake(1., 0., 0., 0.);
        _badgeLabel.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.contentView.frame;
    if ([_badgeLabel.text length]) {
        _badgeLabel.hidden = NO;
        CGSize badgeTextSize = [_badgeLabel.text sizeWithFont:_badgeLabel.font];
        
        _badgeLabel.frame = CGRectIntegral(CGRectMake(rect.size.width - badgeTextSize.width - 15.f, ((rect.size.height - badgeTextSize.height) / 2)+1, badgeTextSize.width, badgeTextSize.height));
    } else {
        _badgeLabel.hidden = YES;
    }
}

@end
