//
//  AZButtonGroup.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZButtonGroup.h"
#import "AZTableView.h"

@interface AZButtonGroup()

@property(nonatomic, retain) NSMutableArray *elements;

@end


@implementation AZButtonGroup


@synthesize buttons = _buttons, elements = _elements, separatorColor;

- (id) init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]) {
        //Default size.
    }
    return self;
}

-(void)setButtons:(NSArray *)buttons{
    if (!_elements) {
        self.elements = [NSMutableArray array];
    }
    if (buttons != _buttons) {
        CGRect oldFrame = self.frame;
        NSUInteger count = [buttons count];
        CGRect frame = CGRectMake(0, 0, count * 100, 100);
        self.frame = frame;
        for (int i = 0; i < [_elements count]; i++) {
            [[_elements objectAtIndex:i] removeFromSuperview];
        }
        for (int i = 0; i < count; i++) {
            AZButton *button = nil;
            if ([[buttons objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                button = [AZButton buttonWithTypeName:[buttons objectAtIndex:i][@"type"]];
                [button yy_modelSetWithJSON:[buttons objectAtIndex:i]];
            } else {
                button = [buttons objectAtIndex:i];
            }
            [_elements addObject:button];
            button.frame = CGRectMake(i * 100, 0, 100, 100);
            button.tag = i;
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            if (i && self.separatorColor && self.separatorColor != [UIColor clearColor]) {
                UIView *border = [UIView new];
                border.backgroundColor = self.separatorColor;
                border.frame = CGRectMake(0, 0, 0.5f, 100);
                border.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
                [button addSubview:border];
            }
            button.clickHandler = ^(AZButton *button){
                if (self.clickHandler) {
                    self.clickHandler(button.tag, button);
                }
            };
            [self addSubview:button];
        }
        _buttons = buttons;
        self.frame = oldFrame;
    }
}


@end
