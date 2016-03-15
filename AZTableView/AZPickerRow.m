//
//  AZPickerRow.m
//  AZTableViewExample
//
//  Created by Hao on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZPickerRow.h"
#import "AZPickerTableViewCell.h"

@interface AZPickerRow()

@property(nonatomic, strong) NSArray *selectedIndexes;

@end

@implementation AZPickerRow

@synthesize items = _items;

- (id)init{
    if (self = [super init]) {
        self.style = UITableViewCellStyleValue1;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

-(void)setValue:(id)value
{
    NSMutableArray *indexes = [NSMutableArray array];
    if (value) {
        if (![value isKindOfClass:[NSArray class]]) {
            value = @[value];
        }
        NSInteger len = MIN([self.items count], [value count]);
        for (int i = 0; i < len; i++) {
            id val = [value objectAtIndex:i];
           __block NSInteger ind = 0;
            NSArray *items = [self.items objectAtIndex:i];
                if ([val isKindOfClass:[NSString class]]) {
                    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([val isEqualToString:obj]) {
                            ind = idx;
                            *stop = YES;
                        }
                    }];
                }
            [indexes addObject:@(ind)];
        }
        _selectedIndexes = indexes;
    }
}

-(NSString *)selectedDisplay{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < [self.selectedIndexes count]; i++) {
        id val = [[self.items objectAtIndex:i] objectAtIndex:[[self.selectedIndexes objectAtIndex:i] intValue]];
        [ar addObject:[val description]];
    }
    return [ar componentsJoinedByString:@" "];
}

-(id)selectedValue{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < [self.selectedIndexes count]; i++) {
        [ar addObject:[[self.items objectAtIndex:i] objectAtIndex:[[self.selectedIndexes objectAtIndex:i] intValue]]];
    }
    return [ar count] == 1 ? [ar objectAtIndex:0] : ar;
}


-(id)value{
    return [self selectedValue];
}


- (void)tableViewCellDidBeginEditing:(AZPickerTableViewCell *)tableViewCell{
    tableViewCell.selectedIndexes = self.selectedIndexes;
    [super tableViewCellDidBeginEditing:tableViewCell];
}

- (void)tableViewCell:(AZInputTableViewCell *)tableViewCell valueChanged:(id)value{
    self.selectedIndexes = value;
    tableViewCell.detailTextLabel.text = [self selectedDisplay];
    [super tableViewCell:tableViewCell valueChanged:[self selectedValue]];
}

- (void)updateCell:(AZPickerTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.selectionStyle = self.enabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = [self selectedDisplay];
    cell.items = self.items;
    [cell.pickerView reloadAllComponents];
}

- (Class)cellClass{
    return [AZPickerTableViewCell class];
}

@end
