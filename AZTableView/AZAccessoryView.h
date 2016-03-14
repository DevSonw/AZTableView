//
//  AZAccessoryView.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZButton.h"


@protocol AZAccessoryViewDelegate <NSObject>

@optional
@property(nonatomic, copy) void (^clickHandler)(AZButton *button);

@end


@interface AZAccessoryView : AZButton<AZAccessoryViewDelegate>

+ (id)accessoryViewWithType:(NSString *)type;

@end
