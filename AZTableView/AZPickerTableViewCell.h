//
//  AZPickerTableViewCell.h
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZInputTableViewCell.h"

@interface AZPickerTableViewCell : AZInputTableViewCell

@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) NSArray *selectedIndexes;

@end
