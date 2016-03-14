//
//  AZButton.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZButton : UIButton

+ (id)buttonWithTypeName:(NSString *)type;

@property(nonatomic, copy) void (^clickHandler)(AZButton *button);

@property(nonatomic, assign) CGFloat spacing; ///< The spacing of the image and text.
@property(nonatomic, assign) CGFloat verticalSpacing; ///< The spacing of the image and text, text below the image.

@property(nonatomic, strong) UIColor *titleColor; ///< The title color.
@property(nonatomic, strong) NSString *title; ///< The title text.
@property(nonatomic, strong) NSString *titleFont; ///< The title font.
@property(nonatomic, assign) CGFloat titleFontSize; ///< The title font size.
@property(nonatomic, strong) id image; ///< The image or imageName.

@property(nonatomic, strong) UIColor *backgroundColor; ///< The background color.
@property(nonatomic, strong) UIColor *borderColor; ///< The border color.
@property(nonatomic, assign) CGFloat borderWidth; ///< The border color.
@property(nonatomic, assign) CGFloat cornerRadius; ///< The corner radius.

///accessibilityLabel, enabled

@end
