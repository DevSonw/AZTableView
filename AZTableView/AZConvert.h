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

@interface AZConvert : NSObject

+ (void) convertForModel:(id)model data:(NSDictionary *)data root:(AZRoot *)root;

@end
