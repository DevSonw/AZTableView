//
//  AZRow.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AZTableViewCell.h"
#import "YYModel.h"

#ifndef cellLeftMargin
#define cellLeftMargin (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ? 15 : 10)
#endif

@class AZRow;
typedef void (^AZRowEvent)(AZRow *row, UIView *fromView);


@class AZTableView;
@class AZSection;

@interface AZRow : NSObject

@property(nonatomic, weak) AZSection *section;

@property(nonatomic, strong) NSString *identifier;

@property(nonatomic, retain) NSString *text; ///< The textLabel text
@property(nonatomic, retain) NSString *detail; ///< The detailTextlabel text
@property(nonatomic, retain) NSString *image; ///< The image name for cell
@property(nonatomic, retain) NSString *imageURL; ///< The image url
@property(nonatomic, retain) NSString *imageData; ///< The image base64 encoding string.

@property(nonatomic, assign) CGFloat imageCornerRadius;
@property(nonatomic, retain) NSString *accessibilityLabel; ///< The accessibility for voiceOver

@property(nonatomic, retain) NSString *ref;
@property(nonatomic, strong) id value;
@property(nonatomic, copy) id data;

@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) BOOL    hidden;
@property(nonatomic, assign) BOOL    enabled; ///< enabled for user interface and events.
@property(nonatomic, assign) BOOL    focusable;
@property(nonatomic, assign) BOOL    focused;
@property(nonatomic, assign) BOOL    hideSeparator;

@property(nonatomic, assign) BOOL    deletable;
@property(nonatomic, assign) BOOL    selected;
@property(nonatomic, retain) NSString *selectedImage;


@property(nonatomic, assign) UITableViewCellStyle style;

@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property(nonatomic, retain) id accessoryView;

@property(nonatomic, retain) UIColor *backgroundColor;
@property(nonatomic, retain) UIColor *textColor;
@property(nonatomic, retain) NSString *textFont; //The text font family
@property(nonatomic, assign) CGFloat textFontSize;
@property(nonatomic, retain) UIColor *detailTextColor;
@property(nonatomic, retain) NSString *detailTextFont;
@property(nonatomic, assign) CGFloat detailTextFontSize;
@property(nonatomic, assign) NSInteger detailTextLine;

@property(nonatomic, assign) BOOL loading;

@property (retain, nonatomic) NSDictionary *bindData;

@property(nonatomic, copy) AZRowEvent onSelect;
@property(nonatomic, copy) AZRowEvent onDelete;
@property(nonatomic, copy) AZRowEvent onAccessory;
@property(nonatomic, copy) AZRowEvent onValueChanged;


+ (id)rowWithType:(NSString *)type;

- (NSIndexPath *)indexPath;

- (AZTableViewCell *)cellForTableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath;

-(void)willDisplayCell:(AZTableViewCell *)cell forTableView:(AZTableView *)tableView;
-(void)didEndDisplayingCell:(AZTableViewCell *)cell forTableView:(AZTableView *)tableView;


- (void)updateCell:(AZTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (AZTableViewCell *)createCellForTableView:(AZTableView *)tableView;

- (CGFloat)heightForTableView:(AZTableView *)tableView;
- (id)cellClass;

- (void)selectedAccessory:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)selected:(id)view indexPath:(NSIndexPath *)indexPath;


@end
