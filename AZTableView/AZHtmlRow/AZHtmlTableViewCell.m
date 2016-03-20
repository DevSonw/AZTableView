//
//  AZHtmlTableViewCell.m
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/15.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZHtmlTableViewCell.h"
#import "AZRow.h"

@implementation AZHtmlTableViewCell
@synthesize htmlLabel,clickHandler;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
        htmlLabel = [[MDHTMLLabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 100.0f)];
        htmlLabel.font = [UIFont systemFontOfSize:14.0f];
        htmlLabel.backgroundColor = [UIColor clearColor];
        htmlLabel.delegate = self;
        htmlLabel.numberOfLines = 1;
        htmlLabel.linkAttributes = @{NSForegroundColorAttributeName:[AZRow tintColor],
                                     NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        htmlLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[[AZRow tintColor]colorWithAlphaComponent:0.8],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        [self.contentView addSubview:htmlLabel];
        
        //add notification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    return self;
}

//notification method
- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    self.htmlLabel.htmlText = self.htmlLabel.htmlText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect tFrame = self.textLabel.frame;
    CGRect frame = self.contentView.bounds;
    CGFloat tHeight = tFrame.size.height;
    CGRect dFrame = self.detailTextLabel.frame;
    CGFloat dHeight = dFrame.size.height;
    CGFloat pad = 4;
    CGFloat x = tFrame.origin.x;
    if (!x) {
        x = self.imageView.frame.size.width;
        x = x ? (x + 30.0f):15.0f;
    }
    
    CGFloat width = frame.size.width - x;
    CGFloat hHeight = [htmlLabel sizeThatFits:CGSizeMake(width, 10000)].height;
    
    CGFloat top = (frame.size.height - tFrame.size.height - dFrame.size.height - hHeight - (tHeight ? pad : 0) - (dHeight ? pad : 0)) / 2;
    
    if (tHeight > 0) {
        tFrame.origin.y = top;
        top += tHeight + pad;
        self.textLabel.frame = tFrame;
    }
    
    if (dHeight > 0) {
        dFrame.origin.y = top;
        top += dHeight + pad;
        self.detailTextLabel.frame = dFrame;
    }
    
    self.htmlLabel.frame = CGRectMake(x, top, width, hHeight);
}

#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL *)URL
{
    
}
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL
{
    if (clickHandler) {
        clickHandler(URL);
    }
}

@end
