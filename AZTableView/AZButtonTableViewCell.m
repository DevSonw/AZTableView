//
//  AZButtonTableViewCell.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/3.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButtonTableViewCell.h"
#import "AZRow.h"

@implementation AZButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self setTextColor:[AZRow tintColor]];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self setTextColor:[AZRow tintColor]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.contentView.frame.size;
    self.textLabel.frame = CGRectMake(0, 0, size.width, size.height);
}
@end
