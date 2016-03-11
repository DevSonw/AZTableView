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
#if __has_include(<YYImage/YYImage.h>)
#import <YYModel/YYModel.h>
#else
#import "YYModel.h"
#endif

@class AZRow;
typedef void (^AZRowEvent)(AZRow *row, UIView *fromView);


@class AZTableView;
@class AZSection;

@interface AZRow : NSObject

@property(nonatomic, weak) AZSection *section; ///< Cache the parent section.

@property(nonatomic, strong) NSString *identifier; ///< The identifier for cell reuse.

@property(nonatomic, retain) NSString *text; ///< The textLabel text
@property(nonatomic, retain) NSString *detail; ///< The detailTextlabel text
@property(nonatomic, retain) NSString *image; ///< The image name for cell
@property(nonatomic, retain) NSString *imageURL; ///< The image url or the image base64 encoding string(data:image/gif;base64,xxxx). when image by name provided, will resize the image by url to image by name.
@property(nonatomic, assign) CGFloat imageCornerRadius; ///< Set i image corner radius
@property(nonatomic, retain) NSString *accessibilityLabel; ///< The accessibility for voiceOver

@property(nonatomic, retain) NSString *ref; ///< The reference id
@property(nonatomic, strong) id value; ///< The value for editable form row.
@property(nonatomic, copy) id data; ///< The extra data for the row.

@property(nonatomic, assign) CGFloat height;  ///< Set the row height. Default 44
@property(nonatomic, assign) BOOL    hidden; ///< If hide the row in table. Default NO.
@property(nonatomic, assign) BOOL    enabled; ///< Enabled for user interface and events. default YES
@property(nonatomic, assign) BOOL    hideSeparator; ///< If hide the cell separator line. default NO

@property(nonatomic, assign, readonly) BOOL    focusable;///< Some input row can focused.
@property(nonatomic, assign, readonly) BOOL    focused;///< If the row is focused.

@property(nonatomic, assign) BOOL    deletable; ///< If the row deletable. Default NO
@property(nonatomic, assign) BOOL    sortable; ///< If the row sortable. Default NO

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
@property(nonatomic, copy) AZRowEvent onAccessory;
@property(nonatomic, copy) AZRowEvent onChange;
@property(nonatomic, copy) AZRowEvent onDelete;
@property(nonatomic, copy) AZRowEvent onMove;


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

/**
 The default tintColor
 */
+ (UIColor *)tintColor;


@end
