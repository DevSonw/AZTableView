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

-(id)init{
    if (self = [super init]) {
        self.borderWidth = 1.f;
        self.cornerRadius = 4.f;
    }
    return self;
}

@end
