//
//  AZTableView.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableView.h"
#import "AZTableViewDataSource.h"
#import "AZTableViewDelegate.h"
#import "AZTableViewDelegateWithRowHeight.h"

@interface AZTableView()
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AZTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
    }
    return self;
}

@synthesize root = _root, refreshAction, refreshControl = _refreshControl;

-(id)initWithRoot:(AZRoot *)root{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0) style:root.grouped ? UITableViewStyleGrouped : UITableViewStylePlain]) {
        self.allowsSelectionDuringEditing = YES;
        self.root = root;
        root.tableView = self;
        
        bbDataSource = [[AZTableViewDataSource alloc] init];
        self.dataSource = bbDataSource;
        if (root.highPerformance) {
            bbDelegate = [[AZTableViewDelegate alloc] init];
            self.delegate = bbDelegate;
        } else {
            bbDelegate = [[AZTableViewDelegateWithRowHeight alloc] init];
            self.delegate = bbDelegate;
        }
    }
    return self;
}

-(void)update:(NSDictionary *)setting{
    [self update:setting init:NO];
}

-(void)update:(NSDictionary *)setting init:(BOOL)init{
    if (!init) {
//        [self.root update:setting];
    }
    
//    [AZUtil setStringProperties:@[@"refreshAction"] for:self from:setting];
//    [AZUtil setNumberProperties:@[@"rowHeight", @"highPerformance"] for:self from:setting];
//    [AZUtil setColorProperties:@[@"separatorColor", @"backgroundColor"] for:self from:setting];
    
    if (setting[@"editing"]) {
        [self setEditing:self.root.editing animated:YES];
    }
    if (setting[@"bounce"]) {
        self.alwaysBounceVertical = [setting[@"bounce"] boolValue];
    }
    if (setting[@"offsetTop"]) {
        [self setContentInset:UIEdgeInsetsMake(-([setting[@"offsetTop"] floatValue]), 0, 0, 0)];
    }
    
    if (setting[@"separatorStyle"]) {
        self.tableFooterView = nil;
        if ([setting[@"separatorStyle"] isEqualToString:@"none"]) {
            self.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else if ([setting[@"separatorStyle"] isEqualToString:@"noextra"]) {
            //http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
            self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        } else {
            self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    }
    
    if (self.refreshAction && !self.refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_refreshControl];
    } else if(!self.refreshAction && self.refreshControl){
        [self.refreshControl removeFromSuperview];
        self.refreshControl = nil;
    }
    if (!init) {
        if (setting[@"sections"] || setting[@"data"] || setting[@"addData"]) {
            AZRow *row = [self.root focusedRow];
            [self reloadData];
            //Re focus row...
            if (row && row.section && !row.section.hidden && !row.hidden && row.enabled) {
                [self focusRow:row];
            } else {
                row.focused = NO;
            }
        }
    }
}

- (void)scrollToTop{
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)refresh{
    if (self.refreshControl && !self.refreshControl.isRefreshing) {
        //        [self setContentOffset:CGPointMake(0, -self.contentInset.top-self.refreshControl.frame.size.height) animated:YES];
        //        [self.refreshControl beginRefreshing];
        [self handleRefresh:self.refreshControl];
    }
}

- (void)stopRefresh{
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
        //        [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:YES];
    }
}

-(void)handleRefresh:(UIView *)view{
    [self action:self.refreshAction data:nil extra:nil];
}

- (void)deselect{
    [self deselect:YES];
}

- (void)deselect:(BOOL)animated{
    if ([self indexPathForSelectedRow]) {
        [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:animated];
    }
}

- (BOOL)deleteRowAtIndexPath:(NSIndexPath *)indexPath{
    AZRow *row = [self.root visibleRowAtIndexPath:indexPath];
    if (row) {
        [row.section.rows removeObject:row];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return YES;
    }
    return NO;
}

- (void)action:(id)action data:(id)data extra:(id)extra{
//    [self.action action:action data:data ? data : [self.root values] extra:extra];
}

- (void)focusRow:(AZRow *)row{
    if (!row) {
        return;
    }
    [self focusRowAtIndexPath:[row indexPath]];
}

- (void)focusRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath) {
        return;
    }
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    //Fix the position When to prev cell
    if (!cell || ([self scrollIndicatorInsets].top + self.contentOffset.y > cell.frame.origin.y)) {
        [self scrollToRowAtIndexPath:indexPath
                    atScrollPosition:UITableViewScrollPositionMiddle
                            animated:YES];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (!cell) {
            [[self cellForRowAtIndexPath:indexPath] becomeFirstResponder];
        } else {
            [cell becomeFirstResponder];
        }
    });
}

- (BOOL)updateRow:(id)setting indexPath:(NSIndexPath *)indexPath{
    AZRow *row = [self.root visibleRowAtIndexPath:indexPath];
    if (row) {
//        [row update:setting];
        AZTableViewCell *cell = (AZTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        [row updateCell:cell tableView:self indexPath:indexPath];
        if( [cell respondsToSelector:@selector(layoutSubviews)]){
            [cell layoutSubviews];
        }
        return YES;
    }
    return NO;
}

@end
