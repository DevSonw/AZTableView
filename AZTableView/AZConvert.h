//
//  AZConvert.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AZRoot;

/**
 Convert the property type which YYModel ignore, like `UIColor`
 
 Create category for extend type by the type name:
 
 + (UIColor *)UIColor:(id)json;
 
 Transform the enum type value from string by create method with the property name:
 
 + (UIColor *)enum_keyboardType:(id)json;
 
 */
@interface AZConvert : NSObject

/**
 
 The base convert method.

 @param model A model instance.
 @param data The property data dictionary for transform.
 @param root The root for receive the event.
 */

+ (void) convertForModel:(id)model data:(NSDictionary *)data root:(AZRoot *)root;

@end

/**
 * This macro is used for creating converters for enum types.
 */
#define AZ_ENUM_CONVERTER(key, values) \
+(NSNumber*)enum_##key:(NSString *)type {\
static NSDictionary<NSString *, NSNumber *> *mapping;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
mapping = values;\
});\
return mapping[type];\
}