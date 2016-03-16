//
//  AZGridSection.m
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZGridSection.h"
#import "AZGridRow.h"
#import "AZTableView.h"

@interface AZGridSection()

@property(nonatomic, strong) UIView *gridView;

@end


NSInteger const  viewTag  = 120523;

@implementation AZGridSection
@synthesize items,reduceWidth,gridView;

- (void)setItems:(NSArray *)itemArr
{
    items = itemArr;
    self.header = @" ";
}

- (void)willDisplayHeaderView:(UIView *)view forTableView:(AZTableView *)tableView
{
    [super willDisplayHeaderView:view forTableView:tableView];
    //Recalculate position
    [[view viewWithTag:viewTag] removeFromSuperview];
    [view addSubview:[self gridView:view]];
}

- (void)didEndDisplayingHeaderView:(UIView *)view forTableView:(AZTableView *)tableView
{
    [super didEndDisplayingHeaderView:view forTableView:tableView];
    [[view viewWithTag:viewTag] removeFromSuperview];
}

#pragma mark - getter && setter
- (UIView *)gridView:(UIView *)view
{
    if (!gridView) {
        CGFloat total = view.frame.size.width;
        UIColor *textColor = nil;
        UIFont *font = nil;
        if ([view respondsToSelector:@selector(textLabel)]) {
            UILabel *lab = [view performSelector:@selector(textLabel)];
            textColor = lab.textColor;
            font = lab.font;
        }
        gridView = [UIView new];
        gridView.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height);
        gridView.tag = viewTag;
        gridView.backgroundColor = [UIColor clearColor];
        gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        CGFloat width = (total - self.reduceWidth) / [items count];
        for (int i = 0; i < [items count]; i++) {
            NSString *item = items[i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, 30)];
            if (textColor) {
                label.textColor = textColor;
            }
            if (font) {
                label.font = font;
            }
            label.text = item;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            [gridView addSubview:label];
        }
    }
    return gridView;
}
@end
