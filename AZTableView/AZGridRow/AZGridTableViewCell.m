//
//  AZGridTableViewCell.m
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZGridTableViewCell.h"

@interface AZGridTableViewCell()
@property(nonatomic, retain) NSMutableArray *elements;
@end

@implementation AZGridTableViewCell
@synthesize items,elements;

#pragma mark - UI
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame1 = self.contentView.bounds;
    CGRect frame2 = self.textLabel.frame;
    float origin_y = frame2.origin.y;
    float height = frame2.size.height;
    NSInteger count = [elements count];
    if (count) {
        float per = frame1.size.width / count;
        for (int index = 0; index < count; index++) {
            UILabel *lab = (UILabel *)[elements objectAtIndex:index];
            lab.frame = CGRectMake(per *index, origin_y, per, height);
        }
    }
}
#pragma mark - setter && getter
- (void)setItems:(NSArray *)itemArr
{
    if (!elements) {
        elements = [NSMutableArray new];
    }
    NSUInteger count = [itemArr count];
    if (count != [items count]) {
        for (int index = 0; index < [elements count]; index++) {
            [[elements objectAtIndex:index]removeFromSuperview];
        }
        [elements removeAllObjects];
        self.textLabel.font = [UIFont systemFontOfSize:17 - count];
        for (int index = 0; index < count; index++) {
            UILabel *lab = [UILabel new];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor clearColor];
            lab.font = self.textLabel.font;
            lab.highlightedTextColor = self.textLabel.highlightedTextColor;
            [elements addObject:lab];
            [self.contentView addSubview:lab];
        }
    }
    for (int index = 0; index < count; index++) {
        UILabel *lab = [elements objectAtIndex:index];
        lab.text = [[itemArr objectAtIndex:index]description];
        lab.textColor = self.textLabel.textColor;
    }
    items = itemArr;
}
@end
