//
//  AZTableViewCell.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AZTableView;

@interface AZTableViewCell : UITableViewCell

@property(nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, weak) AZTableView *tableView;

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL hideSeparator;


-(void)setTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
-(void)setDetailTextColor:(UIColor *)detailTextColor UI_APPEARANCE_SELECTOR;
-(void)setTextFont:(NSString *)textFont size:(CGFloat)size UI_APPEARANCE_SELECTOR;
-(void)setDetailTextFont:(NSString *)textFont size:(CGFloat)size UI_APPEARANCE_SELECTOR;

-(void)setTextColor:(UIColor *)textColor style:(UITableViewCellStyle)style UI_APPEARANCE_SELECTOR;
-(void)setDetailTextColor:(UIColor *)detailTextColor style:(UITableViewCellStyle)style UI_APPEARANCE_SELECTOR;
-(void)setTextFont:(NSString *)textFont size:(CGFloat)size style:(UITableViewCellStyle)style UI_APPEARANCE_SELECTOR;
-(void)setDetailTextFont:(NSString *)textFont size:(CGFloat)size style:(UITableViewCellStyle)style UI_APPEARANCE_SELECTOR;


@end
