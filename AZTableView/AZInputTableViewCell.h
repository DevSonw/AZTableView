//
//  AZInputTableViewCell.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZFieldTableViewCell.h"
@class AZInputTableViewCell;

@protocol AZInputTableViewCellDelegate <AZFieldTableViewCellDelegate>

@optional

- (void)tableViewCellActionNext:(AZInputTableViewCell *)tableViewCell;
- (void)tableViewCellActionPrev:(AZInputTableViewCell *)tableViewCell;
- (void)tableViewCellActionDone:(AZInputTableViewCell *)tableViewCell;

- (BOOL)tableViewCellShouldBeginEditing:(AZInputTableViewCell *)tableViewCell;
- (void)tableViewCellDidBeginEditing:(AZInputTableViewCell *)tableViewCell;
- (void)tableViewCellDidEndEditing:(AZInputTableViewCell *)tableViewCell;
@end


@interface AZInputTableViewCell : AZFieldTableViewCell<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) BOOL hiddenToolbar;
@property (nonatomic, assign) BOOL hiddenPrevAndNext;
@property (nonatomic, assign) BOOL prevEnabled;
@property (nonatomic, assign) BOOL nextEnabled;
@property (nonatomic, assign) CGFloat textWidth;
@property (nonatomic, assign) id<AZInputTableViewCellDelegate> delegate;// default is nil. weak reference
- (void)fixPosition;

@end
