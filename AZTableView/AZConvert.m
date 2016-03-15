//
//  AZConvert.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZConvert.h"

#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "AZRoot.h"


static NSMapTable<Class, NSDictionary *> *AZModelProperties = nil;

@implementation AZConvert

+ (void) convertForModel:(id)model data:(NSDictionary *)data root:(AZRoot *)root{
    
    //root has the strong reference of row.
    //row has the strong reference of block.
    //Weak reference the root instance for block memory circle.
    __weak AZRoot *_root = root;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AZModelProperties = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableCopyIn];
    });
    
    Class cls = ((id<YYModel>)model).class;
    if (![AZModelProperties objectForKey:cls]) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        // Create all property metas.
        YYClassInfo *curClassInfo = [YYClassInfo classInfoWithClass:cls];
        while (curClassInfo && curClassInfo.superCls != nil) { // recursive parse super class, but ignore root class (NSObject/NSProxy)
            [propertyInfos addEntriesFromDictionary:curClassInfo.propertyInfos];
            curClassInfo = curClassInfo.superClassInfo;
        }
        [AZModelProperties setObject:propertyInfos forKey:cls];
    }
    
    NSDictionary *propertyInfos = [AZModelProperties objectForKey:cls];
    
    id (*convert)(id, SEL, id) = (typeof(convert))objc_msgSend;
    
    for (NSString *key in data) {
        id value = data[key];
        if (propertyInfos[key] && value != [NSNull null]) {
            YYClassPropertyInfo *prop = propertyInfos[key];
            switch ((prop.type & YYEncodingTypeMask)) {
                case YYEncodingTypeObject:{
                    if (!prop.cls) {
                        //Set the (id) type data.
                        [model setValue:value forKey:key];
                    } else if ([prop.cls isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSNumber class]]) {
                        //Convert number format date which YYModel ignore.
                        [model setValue:[NSDate dateWithTimeIntervalSince1970:[value doubleValue] / 1000.0] forKey:key];
                    } else {
                        SEL sel = prop.cls ? NSSelectorFromString([NSString stringWithFormat:@"%@:", NSStringFromClass(prop.cls), nil]) : nil;
                        if (sel && [self respondsToSelector:sel]) {
                            id val = convert([self class], sel, value);
                            [model setValue:val forKey:key];
                        }
                    }
                } break;
                case YYEncodingTypeBlock:{
                    //Transform event block from string
                    if ([value isKindOfClass:[NSString class]] && root) {
                        [model setValue:^(AZRow *row, UIView *fromView){
                            if (_root.onEvent) {
                                _root.onEvent(value, row, fromView);
                            }
                        } forKey:key];
                    }
                } break;
                case YYEncodingTypeInt64:{
                    //Transform enum number value from string
                    if ([value isKindOfClass:[NSString class]]) {
                        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"enum_%@:", key, nil]);
                        if ([self respondsToSelector:sel]) {
                            id val = convert([self class], sel, value);
                            if (val) {
                                [model setValue:val forKey:key];
                            }
                        }
                    }
                } break;
                default:
                    break;
            }
        }
    }
}

+ (UIColor *)UIColor:(id)json{
    if (!json) {
        return nil;
    }
    if ([json isKindOfClass:[NSString class]]) {
        json = [json stringByReplacingOccurrencesOfString:@"'" withString:@""];
        if ([json hasPrefix:@"#"]) {
            const char *s = [json cStringUsingEncoding:NSASCIIStringEncoding];
            if (*s == '#') {
                ++s;
            }
            unsigned long long value = strtoll(s, nil, 16);
            int r, g, b, a;
            switch (strlen(s)) {
                case 2:
                    // xx
                    r = g = b = (int)value;
                    a = 255;
                    break;
                case 3:
                    // RGB
                    r = ((value & 0xf00) >> 8);
                    g = ((value & 0x0f0) >> 4);
                    b = ((value & 0x00f) >> 0);
                    r = r * 16 + r;
                    g = g * 16 + g;
                    b = b * 16 + b;
                    a = 255;
                    break;
                case 6:
                    // RRGGBB
                    r = (value & 0xff0000) >> 16;
                    g = (value & 0x00ff00) >>  8;
                    b = (value & 0x0000ff) >>  0;
                    a = 255;
                    break;
                default:
                    // RRGGBBAA
                    r = (value & 0xff000000) >> 24;
                    g = (value & 0x00ff0000) >> 16;
                    b = (value & 0x0000ff00) >>  8;
                    a = (value & 0x000000ff) >>  0;
                    break;
            }
            return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
        }
        else
        {
            json = [json stringByAppendingString:@"Color"];
            SEL colorSel = NSSelectorFromString(json);
            if ([UIColor respondsToSelector:colorSel]) {
                return [UIColor performSelector:colorSel];
            }
            return nil;
        }
    } else if([json isKindOfClass:[UIColor class]]){
        return (UIColor *)json;
    } else if ([json isKindOfClass:[NSNumber class]]) {
        NSUInteger argb = [json integerValue];
        CGFloat a = ((argb >> 24) & 0xFF) / 255.0;
        CGFloat r = ((argb >> 16) & 0xFF) / 255.0;
        CGFloat g = ((argb >> 8) & 0xFF) / 255.0;
        CGFloat b = (argb & 0xFF) / 255.0;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    } else {
        return nil;
    }
}

/**
 row style
 */

AZ_ENUM_CONVERTER(style, (@{
                           @"default":       @(UITableViewCellStyleDefault),
                           @"subtitle":      @(UITableViewCellStyleSubtitle),
                           @"value1":        @(UITableViewCellStyleValue1),
                           @"value2":        @(UITableViewCellStyleValue2),
                           }))

AZ_ENUM_CONVERTER(accessoryType, (@{
                                    @"none":                    @(UITableViewCellAccessoryNone),
                                    @"checkmark":               @(UITableViewCellAccessoryCheckmark),
                                    @"detail-disclosure-button":  @(UITableViewCellAccessoryDetailDisclosureButton),
                                    @"disclosure-indicator":     @(UITableViewCellAccessoryDisclosureIndicator),
                                    @"detail-button":            @(UITableViewCellAccessoryDetailButton),
                                    }))

AZ_ENUM_CONVERTER(dateMode, (@{
                               @"time":            @(UIDatePickerModeTime),
                               @"date":            @(UIDatePickerModeDate),
                               @"date-and-time":     @(UIDatePickerModeDateAndTime),
                               @"count-down-timer":  @(UIDatePickerModeCountDownTimer),
                               }))

AZ_ENUM_CONVERTER(autoCapitalize, (@{
                                             @"none":                    @(UITextAutocapitalizationTypeNone),
                                             @"words":                   @(UITextAutocapitalizationTypeWords),
                                             @"sentences":               @(UITextAutocapitalizationTypeSentences),
                                             @"all-characters":           @(UITextAutocapitalizationTypeAllCharacters),
                                             }))



//AZ_ENUM_CONVERTER(autocorrectionType, (@{
//                                         @"default":        @(UITextAutocorrectionTypeDefault),
//                                         @"no":             @(UITextAutocorrectionTypeNo),
//                                         @"yes":            @(UITextAutocorrectionTypeYes),
//                                         }))


AZ_ENUM_CONVERTER(keyboardType, (@{
                                   @"default":                  @(UIKeyboardTypeDefault),
                                   @"ascii-capable":             @(UIKeyboardTypeASCIICapable),
                                   @"numbers-and-punctuation":    @(UIKeyboardTypeNumbersAndPunctuation),
                                   @"url":                      @(UIKeyboardTypeURL),
                                   @"number-pad":                @(UIKeyboardTypeNumberPad),
                                   @"phone-pad":                 @(UIKeyboardTypePhonePad),
                                   @"name-phone-pad":             @(UIKeyboardTypeNamePhonePad),
                                   @"email-address":             @(UIKeyboardTypeEmailAddress),
                                   @"decimal-pad":               @(UIKeyboardTypeDecimalPad),
                                   @"twitter":                  @(UIKeyboardTypeTwitter),
                                   @"web-search":                @(UIKeyboardTypeWebSearch),
                                   }))


AZ_ENUM_CONVERTER(keyboardAppearance, (@{
                                         @"default":          @(UIKeyboardAppearanceDefault),
                                         @"dark":             @(UIKeyboardAppearanceDark),
                                         @"light":            @(UIKeyboardAppearanceLight),
                                         }))

AZ_ENUM_CONVERTER(returnKeyType, (@{
                                    @"default":        @(UIReturnKeyDefault),
                                    @"go":             @(UIReturnKeyGo),
                                    @"google":         @(UIReturnKeyGoogle),
                                    @"join":           @(UIReturnKeyJoin),
                                    @"next":           @(UIReturnKeyNext),
                                    @"route":          @(UIReturnKeyRoute),
                                    @"search":         @(UIReturnKeySearch),
                                    @"send":           @(UIReturnKeySend),
                                    @"yahoo":          @(UIReturnKeyYahoo),
                                    @"done":           @(UIReturnKeyDone),
                                    @"emergency-call":  @(UIReturnKeyEmergencyCall),
                                    }))




@end
