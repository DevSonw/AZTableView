//
//  AZSection.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZSection.h"
#import "AZItem.h"
#import "AZRoot.h"
#import "AZConvert.h"

@implementation AZSection

@synthesize hidden, header, key, value = _value, footer, rows = _rows, root, headerHeight, footerHeight, indexTitle, bindData;

+ (NSArray *)modelPropertyBlacklist {
    return @[@"rows"];
}

- (NSDictionary *)modelCustomPreTransformFromDictionary:(NSDictionary *)dic {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (dic[@"bind"]) {
        [data addEntriesFromDictionary:[AZRoot dataFromBind:dic[@"bind"] source:dic[@"bindData"] ? dic[@"bindData"] : self.root.bindData]];
    }
    [AZRoot transformTemplate:@"row" data:data];
    return data;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [AZConvert convertForModel:self data:dic root:self.root];
    if ([dic[@"rows"] isKindOfClass:[NSArray class]]) {
        for (id obj in dic[@"rows"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                AZRow *row = [AZRow rowWithType:obj[@"type"]];
                row.section = self;
                [row yy_modelSetWithDictionary:obj];
                [self addRow:row];
            }
        }
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> rows=%@", self.class, self, self.rows, nil];
}


+(id)sectionWithType:(NSString *)type{
        if ([type isKindOfClass:[NSString class]]) {
            //For extend
            Class cla = NSClassFromString(type);
            if (!cla) {
                if (type && [type length]>0) {
                    type = [type stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[type substringToIndex:1] capitalizedString]];
                }
                cla = NSClassFromString([NSString stringWithFormat:@"AZ%@Section", type]);
            }
            if (cla && [cla isSubclassOfClass:self]) {
                return [cla new];
            } else if(!cla){
                [NSException raise:@"Invalid section type" format:@"type of %@ is invalid", type];
            }
        }
    return [self new];
}

-(id)init{
    if (self = [super init]) {
        self.headerHeight = -1;
        self.footerHeight = -1;
    }
    return self;
}


//- (void)update:(NSDictionary *)setting{
////    [super update:setting];
//    if ([[setting objectForKey:@"rows"] isKindOfClass:[NSArray class]]) {
//        self.rows = [[NSMutableArray alloc] init];
//        for (id s in [setting objectForKey:@"rows"]) {
//            AZRow *row = [AZRow rowWithSetting:s];
//            [self addRow:row];
//        }
//    }else if (!self.rowTemplate && [[setting objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
//        self.rows = [[NSMutableArray alloc] init];
//        for (id s in [setting objectForKey:@"items"]) {
//            AZRow *row = [AZItem rowWithSetting:s];
//            [self addRow:row];
//        }
//    }
//}

//- (void)bindData:(NSDictionary *)data {
//    if (self.bind) {
//        NSDictionary *setting = [AZUtil settingFromBind:self.bind data:data];
//        [self update:setting];
//        NSString *iterate = @"iterate";
//        if (self.bind[iterate]){
//            if (setting[iterate] || ![self.rows count]) {
//                [self toCollection:setting[iterate]];
//            }
//            return;
//        }
//    }
//    for (AZRow *row in self.rows) {
//        [row bindData:data];
//    }
//}

//- (void)toCollection:(NSArray *)items  {
//    [self.rows removeAllObjects];
//    if ([items count]) {
//        if (self.rowTemplate) {
//            for (NSDictionary *data in items) {
//                AZRow *row = [AZRow rowWithSetting:self.rowTemplate];
//                //Set data for collection
//                row.data = data;
//                [self addRow:row];
//                [row bindData:data];
//            }
//        } else if(self.itemTemplate){
//            for (NSDictionary *data in items) {
//                AZRow *row = [AZItem rowWithSetting:self.itemTemplate];
//                //Set data for collection
//                row.data = data;
//                [self addRow:row];
//                [row bindData:data];
//            }
//        }
//    } else if(self.rowTemplate && self.emptyRow){
//        AZRow *row = [AZRow rowWithSetting:self.emptyRow];
//        [self addRow:row];
//    }
//}

- (void)addRow:(AZRow *)row{
    if (self.rows == nil) {
        self.rows = [NSMutableArray array];
    }
    row.section = self;
    [self.rows addObject:row];
}

- (void)insertRow:(AZRow *)row atIndex:(NSUInteger)index{
    if (self.rows == nil) {
        self.rows = [NSMutableArray array];
    }
    [self.rows insertObject:row atIndex:index];
}


- (NSUInteger)indexOfRow:(AZRow *)row{
    if (self.rows) {
        return [self.rows indexOfObject:row];
    }
    return NSNotFound;
}

- (AZRow *)visibleRowAtIndex:(NSInteger)index{
    for (AZRow * q in self.rows)
    {
        if (!q.hidden && index-- == 0)
            return q;
    }
    return nil;
}

- (NSInteger)numberOfVisibleRows{
    NSUInteger c = 0;
    for (AZRow * q in self.rows)
    {
        if (!q.hidden)
            c++;
    }
    return c;
}

- (NSUInteger)indexForVisibleRow:(AZRow*)row{
    NSUInteger c = 0;
    for (AZRow * q in self.rows)
    {
        if (q == row)
            return c;
        if (!q.hidden)
            ++c;
    }
    return NSNotFound;
}

- (void)moveVisibleRowFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex == toIndex) {
        return;
    }
    AZRow *row = [self visibleRowAtIndex:fromIndex];
    NSInteger index = [self.rows indexOfObject:[self visibleRowAtIndex:toIndex]];
    [self.rows removeObject:row];
    if (index == NSNotFound || index >= [self.rows count]) {
        [self.rows addObject:row];
    } else {
        [self.rows insertObject:row atIndex:index];
    }
}

- (id)value{
    if (self.selectable) {
        NSMutableArray *res = [NSMutableArray array];
        for (AZRow * q in self.rows)
        {
            if (!q.hidden && q.selected && (q.data || q.text)){
                [res addObject:q.data ? q.data : q.text];
            }
        }
        return self.multiple ? res : [res count] ? res[0] : nil;
    } else if (self.sortable) {
        NSMutableArray *res = [NSMutableArray array];
        for (AZRow * q in self.rows)
        {
            if (!q.hidden && (q.data || q.text)){
                [res addObject:q.data ? q.data : q.text];
            }
        }
        return res;
    }
    return _value;
}

- (UIView *)headerForTableView:(AZTableView *)tableView{
    return nil;
}
- (UIView *)footerForTableView:(AZTableView *)tableView{
    return nil;
}

- (CGFloat)headerHeightForTableView:(AZTableView *)tableView{
    return self.headerHeight >= 0 ? self.headerHeight : UITableViewAutomaticDimension;
}

- (CGFloat)footerHeightForTableView:(AZTableView *)tableView{
    return self.footerHeight >= 0 ? self.footerHeight : UITableViewAutomaticDimension;
}
- (void)willDisplayHeaderView:(UITableViewHeaderFooterView *)view forTableView:(AZTableView *)tableView{
    view.tintColor = self.headerBackgroundColor;
    if(![view isKindOfClass:[UITableViewHeaderFooterView class]]){
        return;
    }
    
    [[view.contentView viewWithTag:3432] removeFromSuperview];
    if (self.loading) {
        UIActivityIndicatorView *activity = [UIActivityIndicatorView new];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
        activity.tag = 3432;
        [view.contentView addSubview:activity];
        [view.contentView addSubview:view.textLabel];
        activity.translatesAutoresizingMaskIntoConstraints = NO;
        [view.contentView addConstraints:
         @[[NSLayoutConstraint constraintWithItem:activity
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view.textLabel
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1 constant:10.f],
           [NSLayoutConstraint constraintWithItem:activity
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view.textLabel
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1 constant:0]]];
    }
}

- (void)willDisplayFooterView:(UITableViewHeaderFooterView *)view forTableView:(AZTableView *)tableView{
    view.tintColor = self.footerBackgroundColor;
    if(![view isKindOfClass:[UITableViewHeaderFooterView class]]){
        return;
    }
    
}

- (void)didEndDisplayingHeaderView:(UITableViewHeaderFooterView *)view forTableView:(AZTableView *)tableView{
    if(![view isKindOfClass:[UITableViewHeaderFooterView class]]){
        return;
    }
    [[view.contentView viewWithTag:3432] removeFromSuperview];
}
- (void)didEndDisplayingFooterView:(UITableViewHeaderFooterView *)view forTableView:(AZTableView *)tableView{
    
}


@end
