//
//  AZInputTableViewCell.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZInputTableViewCell.h"

@implementation AZInputTableViewCell{
    UISegmentedControl *_prevNext;
    UIToolbar           *_toolBar;
    UIBarButtonItem *_prevItem;
    UIBarButtonItem *_nextItem;
    
    UIBarButtonItem *_doneButton;
    UIBarButtonItem *_flexible;
    UIBarButtonItem *_flexible1;
}

@synthesize textField = _textField, prevEnabled = _prevEnabled, nextEnabled = _nextEnabled, hiddenToolbar = _hiddenToolbar, delegate, hiddenPrevAndNext = _hiddenPrevAndNext, textWidth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _prevEnabled = YES;
        _nextEnabled = YES;
        _textField = [[UITextField alloc] init];
        //Clipping long label
        self.textLabel.lineBreakMode = NSLineBreakByClipping;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        [_textField sizeToFit];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)setHiddenToolbar:(BOOL)hiddenToolbar{
    if (hiddenToolbar) {
        self.textField.inputAccessoryView = nil;
    } else {
        self.textField.inputAccessoryView = [self createActionBar];
        self.prevEnabled = self.prevEnabled;
        self.nextEnabled = self.nextEnabled;
        _prevNext.hidden = self.hiddenPrevAndNext;
        if (self.textField.keyboardAppearance == UIKeyboardAppearanceDark) {
            _toolBar.barStyle = UIBarStyleBlack;
        } else {
            _toolBar.barStyle = UIBarStyleDefault;
        }
    }
    _hiddenToolbar = hiddenToolbar;
}

- (void)setHiddenPrevAndNext:(BOOL)hiddenPrevAndNext{
    if (_prevNext) {
        _prevNext.hidden = hiddenPrevAndNext;
    }
    if (_prevItem) {
        [_toolBar setItems:hiddenPrevAndNext ? [NSArray arrayWithObjects:_flexible, _doneButton, nil] : [NSArray arrayWithObjects:_prevItem, _flexible1, _nextItem, _flexible, _doneButton, nil]];
    }
    _hiddenPrevAndNext = hiddenPrevAndNext;
}

- (void)setPrevEnabled:(BOOL)prevEnabled{
    if (_prevNext) {
        [_prevNext setEnabled:prevEnabled forSegmentAtIndex:0];
    }
    if (_prevItem) {
        [_prevItem setEnabled:prevEnabled];
    }
    _prevEnabled = prevEnabled;
}

- (void)setNextEnabled:(BOOL)nextEnabled{
    if (_prevNext) {
        [_prevNext setEnabled:nextEnabled forSegmentAtIndex:1];
    }
    if (_nextItem) {
        [_nextItem setEnabled:nextEnabled];
    }
    _nextEnabled = nextEnabled;
}


-(UIToolbar *)createActionBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [_toolBar sizeToFit];
        _toolBar.tintColor = [AZRow tintColor];
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")
                                                       style:UIBarButtonItemStyleDone target:self
                                                      action:@selector(handleActionBarDone:)];
        
        _flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _prevItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AZTableView.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionPrev)];
        _nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AZTableView.bundle/next"] style:UIBarButtonItemStylePlain target:self action:@selector(actionNext)];
        _flexible1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _flexible1.width = 30;
        [_toolBar setItems:self.hiddenPrevAndNext ? [NSArray arrayWithObjects:_flexible, _doneButton, nil] : [NSArray arrayWithObjects:_prevItem, _flexible1, _nextItem, _flexible, _doneButton, nil]];
        
    }
    return _toolBar;
}

- (BOOL)handleActionBarDone:(UIBarButtonItem *)doneButton {
    if (_textField) {
        [_textField resignFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellActionDone:)]) {
        [self.delegate tableViewCellActionDone:self];
    }
    return YES;
}

- (void)handleActionBarPreviousNext:(UISegmentedControl *)control {
    if (control.selectedSegmentIndex == 1) {
        [self actionNext];
    } else {
        [self actionPrev];
    }
    //    [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (void)actionPrev{
    if (self.prevEnabled && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellActionPrev:)]) {
        [self.delegate tableViewCellActionPrev:self];
    }
}

- (void)actionNext{
    if (self.nextEnabled && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellActionNext:)]) {
        [self.delegate tableViewCellActionNext:self];
    }
}


- (void)textFieldEditingChanged:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:valueChanged:)]) {
        [self.delegate tableViewCell:self valueChanged:textField.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellShouldBeginEditing:)]) {
        return [self.delegate tableViewCellShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //    _toolBar.tintColor = _toolBar.superview.tintColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellDidBeginEditing:)]) {
        [self.delegate tableViewCellDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellDidEndEditing:)]) {
        [self.delegate tableViewCellDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.nextEnabled && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellActionNext:)]) {
            [self.delegate tableViewCellActionNext:self];
        }
    } else if(textField.returnKeyType == UIReturnKeyDone){
        [self handleActionBarDone:nil];
    }
    return YES;
}

- (BOOL)becomeFirstResponder {
    [_textField becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder{
    [_textField resignFirstResponder];
    return YES;
}

//TODO: image
- (void)fixPosition{
    CGRect frame = self.contentView.frame;
    CGRect preFrame = self.textLabel.frame;
    CGFloat height =  _textField.frame.size.height;
    BOOL hasText = preFrame.size.width > 0;
    CGFloat tWidth = self.textWidth > 0 ? self.textWidth : 90.f;
    if (hasText) {
        CGFloat y = preFrame.origin.y + ( preFrame.size.height -  height ) / 2.0;
        CGFloat x = preFrame.origin.x + tWidth + 10.f;
        _textField.frame = CGRectMake(x, y, frame.size.width - x - 10, height);
        if (self.style != UITableViewCellStyleValue2) {
            preFrame.size.width = tWidth;
            self.textLabel.frame = preFrame;
        }
    }else{
        preFrame = self.imageView.frame;
        CGFloat x = preFrame.origin.x + preFrame.size.width + 15.f;
        CGFloat y = ( frame.size.height -  height ) / 2.0;
        _textField.frame = CGRectMake(x, y, frame.size.width - x - 10, height);
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self fixPosition];
}


@end
