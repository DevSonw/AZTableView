//
//  AZLoadingAccessoryView.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZLoadingAccessoryView.h"

@implementation AZLoadingAccessoryView

-(id)init{
    if (self = [super init]) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self startAnimating];
        [self sizeToFit];
    }
    return self;
}

@end
