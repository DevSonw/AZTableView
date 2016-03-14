//
//  AZPickerTableViewCell.m
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZPickerTableViewCell.h"


@interface AZPickerTableViewCell()<UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation AZPickerTableViewCell

@synthesize items = _items;
@synthesize pickerView = _pickerView, selectedIndexes = _selectedIndexes;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textField.hidden = YES;
    }
    return self;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView sizeToFit];
    }
    return _pickerView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.inputView = self.pickerView;
    [super textFieldDidBeginEditing:textField];
}

#pragma mark - Getting/setting value from UIPickerView

-(void)setSelectedIndexes:(id)value{
    if (value && _pickerView) {
        for (int i = 0; i < [value count]; i++) {
            if (_pickerView) {
                [_pickerView selectRow:[[value objectAtIndex:i] intValue] inComponent:i animated:YES];
            }
        }
    }
    _selectedIndexes = value;
}

#pragma mark - UIPickerView data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.items count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.items objectAtIndex:(NSUInteger) component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id val = [[self.items objectAtIndex:(NSUInteger) component] objectAtIndex:(NSUInteger) row];
    return [val description];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *indexes = [NSMutableArray array];
    
    for (int i = 0; i < pickerView.numberOfComponents; i++)
    {
        NSInteger rowIndex = [pickerView selectedRowInComponent:i];
        [indexes addObject:@(rowIndex)];
    }
    _selectedIndexes = indexes;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:valueChanged:)]) {
        [self.delegate tableViewCell:self valueChanged:_selectedIndexes];
    }
}

- (void)fixPosition{
}

@end
