//
//  AZInputRow.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZInputRow.h"

@implementation AZInputRow

@synthesize textFieldColor, placeholder, autocapitalizationType, autocorrectionType, keyboardType, keyboardAppearance, returnKeyType, enablesReturnKeyAutomatically, secureTextEntry, clearsOnBeginEditing, hiddenPrevAndNext, hiddenToolbar, textWidth, placeholderTextColor;

@synthesize onBlur, onFocus, onDone;


- (id)init{
    if (self = [super init]) {
        self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.keyboardType = UIKeyboardTypeDefault;
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeyDefault;
        self.enablesReturnKeyAutomatically = NO;
        self.secureTextEntry = NO;
        self.focusable = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)updateCell:(AZInputTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.textField.text = [self.value description];
    //    cell.selectionStyle = self.enabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.userInteractionEnabled = self.enabled;//will disable the accessoryView
    cell.textField.placeholder = self.placeholder;
    if (self.placeholder.length > 0 && self.placeholderTextColor) {
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:@{
                                                                                  NSForegroundColorAttributeName : self.placeholderTextColor
                                                                                  }];
    } else if (self.placeholder.length) {
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder];
    } else {
        cell.textField.attributedPlaceholder = nil;
    }
    cell.textField.autocapitalizationType = self.autocapitalizationType;
    cell.textField.autocorrectionType = self.autocorrectionType;
    cell.textField.keyboardType = self.keyboardType;
    cell.textField.keyboardAppearance = self.keyboardAppearance;
    cell.textField.secureTextEntry = self.secureTextEntry;
    cell.textField.clearsOnBeginEditing = self.clearsOnBeginEditing;
    if (self.returnKeyType != UIReturnKeyDefault) {
        cell.textField.returnKeyType = self.returnKeyType;
    }
    cell.textWidth = self.textWidth;
    cell.textField.enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically;
    //Set toolbar after keyboardAppearance for set barStyle
    cell.hiddenPrevAndNext = self.hiddenPrevAndNext;
    cell.hiddenToolbar = self.hiddenToolbar;
    cell.prevEnabled = [tableView.root firstFocusableRow] != self;
    cell.nextEnabled = [tableView.root lastFocusableRow] != self;
    cell.textField.enabled = self.enabled;
    if (self.textFieldColor) {
        cell.textField.textColor = self.textFieldColor;
    }
}

- (Class)cellClass{
    return [AZInputTableViewCell class];
}

- (void)selected:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if (self.enabled && !self.hidden) {
        AZInputTableViewCell *cell = (AZInputTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
    }
}

- (void)tableViewCell:(AZInputTableViewCell *)tableViewCell valueChanged:(id)value{
//    NSDictionary *extra = [self extraData:[tableViewCell.tableView indexPathForCell:tableViewCell]];
    self.value = value;
    if (self.onChange) {
        self.onChange(self, tableViewCell);
    }
}

- (BOOL)tableViewCellShouldBeginEditing:(AZInputTableViewCell *)tableViewCell{
    self.focused = YES;
    tableViewCell.tableView.shouldCheckKeyboard = YES;
    
    return YES;
}

- (void)tableViewCellDidBeginEditing:(AZInputTableViewCell *)tableViewCell{
    AZTableView *tableView = tableViewCell.tableView;
    self.focused = YES;
    tableViewCell.tableView.shouldCheckKeyboard = YES;

    if ([tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]] != tableViewCell) {
        [tableView selectRowAtIndexPath:[tableView indexPathForCell:tableViewCell] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if(self.returnKeyType == UIReturnKeyDefault){
        tableViewCell.textField.returnKeyType = tableViewCell.nextEnabled ? UIReturnKeyNext : UIReturnKeyDone;
    }
    
    if (self.onFocus) {
        self.onFocus(self, tableViewCell);
    }
}

- (void)tableViewCellDidEndEditing:(AZInputTableViewCell *)tableViewCell{
    self.focused = NO;
    tableViewCell.tableView.shouldCheckKeyboard = NO;
    
    [tableViewCell.tableView deselect];
    if (self.onBlur) {
        self.onBlur(self, tableViewCell);
    }
}

- (void)tableViewCellActionNext:(AZInputTableViewCell *)tableViewCell{
    AZRow *row = [tableViewCell.tableView.root nextSiblingFocusableRow:self];
    if (row) {
        self.focused = NO;
        row.focused = YES;
        [tableViewCell.tableView focusRow:row];
    }
}

- (void)tableViewCellActionPrev:(AZInputTableViewCell *)tableViewCell{
    AZRow *row = [tableViewCell.tableView.root prevSiblingFocusableRow:self];
    if (row) {
        self.focused = NO;
        row.focused = YES;
        [tableViewCell.tableView focusRow:row];
    }
}

- (void)tableViewCellActionDone:(AZInputTableViewCell *)tableViewCell{
    if (self.onDone) {
        //Dalay for view dismiss, Fix tintColor changed when show alertView
        //UIKeyboard Animation Duration
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            self.onDone(self, tableViewCell);
        });
    }
}

@end
