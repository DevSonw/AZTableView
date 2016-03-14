//
//  AZAccessoryView.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZAccessoryView.h"
#import "AZRow.h"

@implementation AZAccessoryView

+ (id)accessoryViewWithType:(NSString *)type{
    return [AZRow createFromType:type defaultClass:self suffix:@"AccessoryView" validate:NO];
}

@end
