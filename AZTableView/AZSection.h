//
//  AZSection.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZRow.h"

@class AZRoot;

@interface AZSection : NSObject

@property(nonatomic, weak) AZRoot *root;
@property(nonatomic, strong) NSString *ref;
@property(nonatomic, strong) id value;

@property(nonatomic, retain) NSString *header;
@property(nonatomic, retain) NSString *footer;
@property(nonatomic, retain) NSString *indexTitle;

@property(nonatomic, retain) UIColor *headerBackgroundColor;
@property(nonatomic, retain) UIColor *footerBackgroundColor;

@property(nonatomic, assign) CGFloat headerHeight;
@property(nonatomic, assign) CGFloat footerHeight;

@property(nonatomic, retain) NSMutableArray * rows;
@property(nonatomic, assign) BOOL hidden;

@property(nonatomic, assign) BOOL selectable;
@property(nonatomic, assign) BOOL multiple;

@property(nonatomic, assign) BOOL loading;

@property (retain, nonatomic) NSDictionary *bindData;


+(id)sectionWithType:(NSString *)type;

- (void)addRow:(AZRow *)row;
- (void)insertRow:(AZRow *)row atIndex:(NSUInteger)index;
- (NSUInteger)indexOfRow:(AZRow *)row;

- (AZRow *)visibleRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfVisibleRows;
- (NSUInteger)indexForVisibleRow:(AZRow*)row;

- (UIView *)headerForTableView:(AZTableView *)tableView;
- (UIView *)footerForTableView:(AZTableView *)tableView;
- (CGFloat)headerHeightForTableView:(AZTableView *)tableView;
- (CGFloat)footerHeightForTableView:(AZTableView *)tableView;
- (void)willDisplayHeaderView:(UIView *)view forTableView:(AZTableView *)tableView;
- (void)willDisplayFooterView:(UIView *)view forTableView:(AZTableView *)tableView;

- (void)didEndDisplayingHeaderView:(UIView *)view forTableView:(AZTableView *)tableView;
- (void)didEndDisplayingFooterView:(UIView *)view forTableView:(AZTableView *)tableView;


@end
