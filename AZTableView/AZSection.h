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

@property(nonatomic, retain) NSString *header; ///< The text in the header view.
@property(nonatomic, retain) NSString *footer; ///< The text in the footer view.
@property(nonatomic, retain) NSString *indexTitle;

@property(nonatomic, retain) UIColor *headerBackgroundColor;
@property(nonatomic, retain) UIColor *footerBackgroundColor;

@property(nonatomic, assign) CGFloat headerHeight;
@property(nonatomic, assign) CGFloat footerHeight;

@property(nonatomic, retain) NSMutableArray * rows;
@property(nonatomic, assign) BOOL hidden; ///< Don't display the section in the tableView when YES.

@property(nonatomic, assign) BOOL loading; ///< Show a loading view on the header title left.

@property (retain, nonatomic) NSDictionary *bindData;


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;

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
