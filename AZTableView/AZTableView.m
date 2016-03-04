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
#import "AZConvert.h"

@interface AZTableView()
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AZTableView{
    BOOL _keyboardIsShowing;
    CGFloat _keyboardHeight;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

@synthesize root = _root, refreshAction, refreshControl = _refreshControl, bounce = _bounce, offsetTop = _offsetTop;

-(id)initWithRoot:(AZRoot *)root{
    if (self = [self initWithFrame:CGRectMake(0, 0, 0, 0) style:root.grouped ? UITableViewStyleGrouped : UITableViewStylePlain]) {
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

- (void)setBounce:(BOOL)bounce{
    self.alwaysBounceVertical = bounce;
}

-(BOOL)bounce{
    return self.alwaysBounceVertical;
}

- (void)setOffsetTop:(float)offsetTop{
    _offsetTop = offsetTop;
    [self setContentInset:UIEdgeInsetsMake(-(_offsetTop), 0, 0, 0)];
}

-(float)offsetTop{
    return _offsetTop;
}

-(void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{
    [super setSeparatorStyle:separatorStyle];
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


- (void)keyboardWillShow:(NSNotification *)sender
{
    if (!self.shouldCheckKeyboard || _keyboardIsShowing || self.frame.size.height == 0) {
        return;
    }
    _keyboardIsShowing = YES;

    _keyboardHeight = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height + 30.f;
    
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curveOption = [[sender.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.bottom += _keyboardHeight;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|curveOption animations:^{
        self.contentInset = edgeInsets;
//        self.scrollIndicatorInsets = edgeInsets;
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    if (!self.shouldCheckKeyboard || !_keyboardIsShowing) {
        return;
    }
    _keyboardIsShowing = NO;
        NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curveOption = [[sender.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.bottom -= _keyboardHeight;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|curveOption animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        self.contentInset = edgeInsets;
//        self.scrollIndicatorInsets = edgeInsets;
    } completion:^(BOOL finished) {
    }];
}


@end
