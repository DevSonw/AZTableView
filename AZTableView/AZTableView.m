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

@synthesize root = _root, bounce = _bounce, offsetTop = _offsetTop;

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

- (void)deselect{
    [self deselect:YES];
}

- (void)deselect:(BOOL)animated{
    if ([self indexPathForSelectedRow]) {
        [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:animated];
    }
}

- (void)deleteRow:(AZRow *)row indexPath:(NSIndexPath *)indexPath{
    [row.section.rows removeObject:row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)focusCellAtIndexPath:(NSIndexPath *)indexPath{
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

- (BOOL)updateCellForRow:(AZRow *)row indexPath:(NSIndexPath *)indexPath{
    AZTableViewCell *cell = (AZTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    if(!cell){
        return NO;
    }
    [row updateCell:cell tableView:self indexPath:indexPath];
    if( [cell respondsToSelector:@selector(layoutSubviews)]){
        [cell layoutSubviews];
    }
    return YES;
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
        self.contentInset = edgeInsets;
//        self.scrollIndicatorInsets = edgeInsets;
    } completion:^(BOOL finished) {
    }];
}


@end
