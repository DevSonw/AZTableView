//
//  AZTableViewCell.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewCell.h"

@implementation AZTableViewCell

@synthesize style = _style;

-(void)setTextColor:(UIColor *)textColor{
    self.textLabel.textColor = textColor;
}

-(void)setDetailTextColor:(UIColor *)detailTextColor{
    self.detailTextLabel.textColor = detailTextColor;
}


- (void)setTextFont:(NSString *)textFont size:(CGFloat)size{
    self.textLabel.font = [UIFont fontWithName:textFont size: size > 0 ? size : 17.f];
}

- (void)setDetailTextFont:(NSString *)textFont size:(CGFloat)size{
    self.detailTextLabel.font = [UIFont fontWithName:textFont size: size > 0 ? size : 12.f];
}

-(void)setTextColor:(UIColor *)textColor style:(UITableViewCellStyle)style{
    if (self.style == style) {
        self.textLabel.textColor = textColor;
    }
}

-(void)setDetailTextColor:(UIColor *)detailTextColor style:(UITableViewCellStyle)style{
    if (self.style == style) {
        self.detailTextLabel.textColor = detailTextColor;
    }
}

- (void)setTextFont:(NSString *)textFont size:(CGFloat)size style:(UITableViewCellStyle)style{
    if (self.style == style) {
        self.textLabel.font = [UIFont fontWithName:textFont size: size > 0 ? size : 17.f];
    }
}

- (void)setDetailTextFont:(NSString *)textFont size:(CGFloat)size style:(UITableViewCellStyle)style{
    if (self.style == style) {
        self.detailTextLabel.font = [UIFont fontWithName:textFont size: size > 0 ? size : 12.f];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.style = style;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.backgroundColor = [UIColor whiteColor];
        if (style == UITableViewCellStyleValue1) {
            self.detailTextLabel.textColor = [UIColor colorWithRed:0.1653 green:0.2532 blue:0.4543 alpha:1.0000];
        }
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.imageView.image = nil;
    self.textLabel.text = nil;
    self.backgroundColor = [UIColor whiteColor];
    self.detailTextLabel.text = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
    //        self.separatorInset = self.hideSeparator ? UIEdgeInsetsMake(0, self.separatorInset.left, 0, self.bounds.size.width - self.separatorInset.left) : UIEdgeInsetsMake(0, self.separatorInset.left, 0, 0);
    //    }
    for (UIView *view in self.subviews) {
        // Hack! hidden the separator.
        if ([NSStringFromClass([view class]) hasSuffix:@"UITableViewCellSeparatorView"]) {
            view.hidden = self.hideSeparator;
        }
    }
}

- (void)setLoading:(BOOL)loading{
    [[self.imageView viewWithTag:3432] removeFromSuperview];
    _loading = loading;
    if (loading) {
        UIActivityIndicatorView *activity = [UIActivityIndicatorView new];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
        activity.tag = 3432;
        [self.imageView addSubview:activity];
        activity.translatesAutoresizingMaskIntoConstraints = NO;
        [self.imageView addConstraints:
         @[[NSLayoutConstraint constraintWithItem:activity
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.imageView
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1 constant:0],
           [NSLayoutConstraint constraintWithItem:activity
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.imageView
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1 constant:0]]];
    }
}


@end
