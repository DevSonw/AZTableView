//
//  AZRoot.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZRoot.h"

@implementation AZRoot

@synthesize grouped, sections = _sections, showIndexTitle, bindData;


+(NSDictionary *)dataFromBind:(NSDictionary *)bind source:(NSDictionary *)source{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    if (!source || ![bind isKindOfClass:[NSDictionary class]]) {
        return setting;
    }
    BOOL isDict = [source isKindOfClass:[NSDictionary class]];
    for (NSString *key in bind) {
        if ([bind[key] isEqualToString:@"self"]) {
            [setting setObject:source forKey:key];
        } else if (isDict && [source objectForKey:bind[key]]) {
            [setting setObject:[source objectForKey:bind[key]] forKey:key];
        }
    }
    return setting;
}

+(void)transformTemplate:(NSString *)key data:(NSMutableDictionary *)data{
    NSString *temp = [key stringByAppendingString:@"Template"];
    NSString *dataKey = [key stringByAppendingString:@"s"];
    if ([data[temp] isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *ar = [NSMutableArray array];
        if ([data[dataKey] isKindOfClass:[NSArray class]]) {
            for (id obj in data[dataKey]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data[temp]];
                dict[@"bindData"] = obj;
                [ar addObject:dict];
            }
        }
        [data setObject:ar forKey:dataKey];
    }
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"sections"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if (dic[@"bind"]) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        [data addEntriesFromDictionary:[AZRoot dataFromBind:dic[@"bind"] source:self.bindData]];
        [data removeObjectForKey:@"bind"];
        return [self yy_modelSetWithDictionary:data];
    }

    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
    [AZRoot transformTemplate:@"section" data:data];

    if (data[@"sections"]) {
        self.sections = nil;
        if ([data[@"sections"] isKindOfClass:[NSArray class]]) {
            for (id obj in data[@"sections"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    AZSection *section = [AZSection sectionWithType:obj[@"type"]];
                    section.root = self;
                    [section yy_modelSetWithDictionary:obj];
                    [self addSection:section];
                }
            }
        }
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> sections=%@", self.class, self, self.sections, nil];
}


-(id)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)addSection:(AZSection *)section{
    if (_sections==nil)
        _sections = [[NSMutableArray alloc] init];
    section.root = self;
    [_sections addObject:section];
}

- (AZSection *)sectionAtIndex:(NSInteger)index{
    return [_sections objectAtIndex:(NSUInteger) index];
}

- (NSInteger)numberOfSections{
    return [_sections count];
}


- (AZSection *)visibleSectionAtIndex:(NSInteger)index{
    for (AZSection * q in _sections)
    {
        if (!q.hidden && index-- == 0)
            return q;
    }
    return nil;
}

- (AZRow *)visibleRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self visibleSectionAtIndex:indexPath.section] visibleRowAtIndex:indexPath.row];
}

- (NSInteger)numberOfVisibleSections{
    NSUInteger c = 0;
    for (AZSection * q in _sections)
    {
        if (!q.hidden)
            c++;
    }
    return c;
}

- (NSUInteger)indexForVisibleSection: (AZSection*)section
{
    NSUInteger c = 0;
    for (AZSection * q in _sections)
    {
        if (q == section)
            return c;
        if (!q.hidden)
            ++c;
    }
    return NSNotFound;
}

- (AZRow *)firstFocusableRow{
    AZRow *cur = nil;
    for (NSInteger i = 0, len = [self.sections count]; i < len; i++) {
        AZSection *section = [self.sections objectAtIndex:i];
        if (!section.hidden) {
            for (NSInteger j = 0, len1 = [section.rows count]; j < len1; j++) {
                AZRow *_row = [section.rows objectAtIndex:j];
                if (!_row.hidden && _row.focusable && _row.enabled) {
                    cur = _row;
                    break;
                }
            }
        }
        if (cur) {
            break;
        }
    }
    return cur;
}

- (AZRow *)lastFocusableRow{
    AZRow *cur = nil;
    for (NSInteger i = [self.sections count] - 1; i >= 0; i--) {
        AZSection *section = [self.sections objectAtIndex:i];
        if (!section.hidden) {
            for (NSInteger j = [section.rows count] - 1; j >= 0; j--) {
                AZRow *_row = [section.rows objectAtIndex:j];
                if (!_row.hidden && _row.focusable && _row.enabled) {
                    cur = _row;
                    break;
                }
            }
        }
        if (cur) {
            break;
        }
    }
    return cur;
}

- (AZRow *)nextSiblingFocusableRow:(AZRow *)row{
    AZRow *cur = nil;
    BOOL found = NO;
    for (NSInteger i = 0, len = [self.sections count]; i < len; i++) {
        AZSection *section = [self.sections objectAtIndex:i];
        if (!section.hidden) {
            for (NSInteger j = 0, len1 = [section.rows count]; j < len1; j++) {
                AZRow *_row = [section.rows objectAtIndex:j];
                if (row == _row) {
                    found = YES;
                    continue;
                }
                if (found && !_row.hidden && _row.focusable && _row.enabled) {
                    cur = _row;
                    break;
                }
            }
        }
        if (cur) {
            break;
        }
    }
    return cur;
}

- (AZRow *)prevSiblingFocusableRow:(AZRow *)row{
    AZRow *cur = nil;
    BOOL found = NO;
    for (NSInteger i = [self.sections count] - 1; i >= 0; i--) {
        AZSection *section = [self.sections objectAtIndex:i];
        if (!section.hidden) {
            for (NSInteger j = [section.rows count] - 1; j >= 0; j--) {
                AZRow *_row = [section.rows objectAtIndex:j];
                if (row == _row) {
                    found = YES;
                    continue;
                }
                if (found && !_row.hidden && _row.focusable && _row.enabled) {
                    cur = _row;
                    break;
                }
            }
        }
        if (cur) {
            break;
        }
    }
    return cur;
}

- (AZRow *)focusedRow{
    AZRow *cur = nil;
    for (NSInteger i = [self.sections count] - 1; i >= 0; i--) {
        AZSection *section = [self.sections objectAtIndex:i];
        if (!section.hidden) {
            for (NSInteger j = [section.rows count] - 1; j >= 0; j--) {
                AZRow *_row = [section.rows objectAtIndex:j];
                if (_row.focused && !_row.hidden && _row.focusable && _row.enabled) {
                    cur = _row;
                    break;
                }
            }
        }
        if (cur) {
            break;
        }
    }
    return cur;
}


- (NSDictionary *)values{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for (AZSection *section in self.sections) {
        if (section.key && section.value) {
            values[section.key] = section.value;
        }
        for (AZRow *row in section.rows) {
            if (row.key && row.value && row.enabled) {
                values[row.key] = row.value;
            }
        }
    }
    return values;
}

@end
