//
//  AZButton.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButton.h"
#import "AZRow.h"

@implementation AZButton

@synthesize clickHandler, spacing = _spacing, verticalSpacing = _verticalSpacing, titleFont = _titleFont, titleColor = _titleColor, titleFontSize = _titleFontSize, image = _image;

@synthesize borderColor = _borderColor, borderWidth = _borderWidth, cornerRadius = _cornerRadius, backgroundColor = _backgroundColor;


+ (id)buttonWithTypeName:(NSString *)type{
    return [AZRow createFromType:type defaultClass:self suffix:@"Button" validate:NO];
}

- (void)onClick{
    if (self.clickHandler) {
        self.clickHandler(self);
    }
}

-(id)init{
    if (self = [super init]) {
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[AZRow tintColor] forState:UIControlStateNormal];
        self.enabled = YES;
    }
    return self;
}

//https://developer.apple.com/library/ios/documentation/userexperience/conceptual/transitionguide/AppearanceCustomization.html#//apple_ref/doc/uid/TP40013174-CH15-SW3
- (void)tintColorDidChange{
    if( self.tintAdjustmentMode == UIViewTintAdjustmentModeDimmed ){
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        if (self.borderColor) {
            self.layer.borderColor = [self.tintColor CGColor];
        }
    } else {
        [self setTitleColor:self.titleColor forState:UIControlStateNormal];
        if (self.borderColor) {
            self.layer.borderColor = self.borderColor.CGColor;
        }
    }
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (!_titleColor) {
        [self setTitleColor:enabled ? [AZRow tintColor] : [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1] forState:UIControlStateNormal];
    }
}

-(void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title{
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(NSString *)titleFont {
    _titleFont = titleFont;
    [self setTitleFont:_titleFont size:_titleFontSize ? _titleFontSize : 14.f];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize{
    _titleFontSize = titleFontSize;
    [self setTitleFont:_titleFont size:_titleFontSize];
}

- (void)setTitleFont:(NSString *)titleFont size:(CGFloat)size{
    if (!titleFont || !size) {
        return;
    }
    self.titleLabel.font = [UIFont fontWithName:titleFont size:size];
}

- (void)setImage:(id)image{
    _image = image;
    UIImage *img = [image isKindOfClass:[UIImage class]] ? image : [UIImage imageNamed:image];
    [self setImage: img forState:UIControlStateNormal];
    if (!_spacing) {
        self.spacing = 4.0f;
    }
}

- (void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

- (void)setVerticalSpacing:(CGFloat)spacing{
    _verticalSpacing = spacing;
    // the space between the image and text
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, -imageSize.width, - (imageSize.height + spacing), 0.0);
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                            - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    [self setBackgroundImage:[self buttonImageFromColor:backgroundColor cornerRadius:_cornerRadius] forState:UIControlStateNormal];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    CGSize size = self.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bound = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bound cornerRadius:cornerRadius];
    [path addClip];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bound);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
