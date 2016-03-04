//
//  AZInputRow.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZFieldRow.h"
#import "AZInputTableViewCell.h"

@interface AZInputRow : AZFieldRow<AZInputTableViewCellDelegate>

@property(nonatomic, retain) UIColor *textFieldColor;
@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL hiddenToolbar;
@property (nonatomic, assign) BOOL hiddenPrevAndNext;

@property(nonatomic) UITextAutocapitalizationType autocapitalizationType; // default is UITextAutocapitalizationTypeSentences
@property(nonatomic) UITextAutocorrectionType autocorrectionType;         // default is UITextAutocorrectionTypeDefault
@property(nonatomic) UIKeyboardType keyboardType;                         // default is UIKeyboardTypeDefault
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;             // default is UIKeyboardAppearanceDefault
@property(nonatomic) UIReturnKeyType returnKeyType;                       // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
@property(nonatomic, assign) BOOL enablesReturnKeyAutomatically;                  // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
@property(nonatomic, assign) BOOL secureTextEntry;       // default is NO
@property(nonatomic, assign) BOOL clearsOnBeginEditing;                   // default is NO

@property(nonatomic, strong) AZRowEvent onFocus;
@property(nonatomic, strong) AZRowEvent onBlur;
@property(nonatomic, strong) AZRowEvent onDone;

@end
