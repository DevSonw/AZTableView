//
//  AZHtmlRow.m
//  AZTableViewExample
//
//  Created by ctrip-zxl on 16/3/14.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZHtmlRow.h"
#import "AZTableView.h"
#import "MDHTMLLabel.h"
#import "AZHtmlTableViewCell.h"

@interface AZHtmlRow()

@end

@implementation AZHtmlRow
@synthesize html,htmlTextLine,onLink;

- (id)init
{
    if (self = [super init]) {
        self.htmlTextLine = 1;
        self.cellStyle = UITableViewCellStyleSubtitle;
    }
    return self;
}

- (CGFloat)heightForTableView:(AZTableView *)tableView
{
    if (self.height >= 0) {
        return self.height;
    }
    CGFloat height = 0;
    float imageWidth = -1.0f;
    CGSize constraint;
    UIFont *font;
    BOOL IOS7 = [[UIDevice currentDevice]systemVersion];
    
    if (self.text) {
        height = height + 20;
    }
    
    if (self.detailTextLine == 0) {
        if (self.image) {
            imageWidth = [UIImage imageNamed:self.image].size.width + (IOS7 ?15.0f:20.0f);
        }else{
            imageWidth = 0.0f;
        }
        
        float padding = IOS7 ? 30.0f:(tableView.root.grouped ? 40.0f:20.0f);
        float fontSize = IOS7 ? 12.0f:14.0f;
        
        constraint = CGSizeMake(tableView.frame.size.width - imageWidth - padding, 20000);
        font = self.detailTextFont ? [UIFont fontWithName:self.detailTextFont size:self.detailTextFontSize > 0?self.detailTextFontSize:fontSize]:[UIFont systemFontOfSize:fontSize];
        CGSize size = [self.detail sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByTruncatingTail];
        height = height + size.height + 10.0f;
        
    }else{
        if (self.detail) {
            height += 24.0f;
        }
    }
    
    if (self.htmlTextLine == 0) {
        if (imageWidth < 0) {
            if (self.image) {
                imageWidth = [UIImage imageNamed:self.image].size.width + (IOS7 ? 15.0f:20.0f);
            }else{
                imageWidth = 0.0f;
            }
            float fontSize = IOS7 ? 12.0f :14.0f;
            float padding = IOS7 ? 30.0f : (tableView.root.grouped ? 40.0f : 20.0f);
            font = self.detailTextFont ? [UIFont fontWithName:self.detailTextFont size:self.detailTextFontSize > 0 ? self.detailTextFontSize:fontSize]:[UIFont systemFontOfSize:fontSize];
            constraint = CGSizeMake(tableView.frame.size.width - imageWidth - padding, 20000);
        }
        CGFloat ssHeight = [MDHTMLLabel sizeThatFitsHTMLString:self.html withFont:font constraints:constraint limitedToNumberOfLines:0 autoDetectUrls:YES];
        height = height + ssHeight + 30.0f;
    }else{
        if (self.html) {
            height += 30.0f;
        }
    }
    
    if (height < 44) {
        height = 44.0f;
    }
    
    return height;
}

- (void)updateCell:(AZHtmlTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    [super updateCell:cell tableView:tableView indexPath:indexPath];
    cell.htmlLabel.htmlText = html;
    cell.htmlLabel.numberOfLines = htmlTextLine;
    cell.selectionStyle = self.enabled && self.onLink ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    __weak AZHtmlRow* row = self;
    __weak AZHtmlTableViewCell *weakCell  = cell;
    cell.clickHandler = self.onLink ? ^(NSURL *URL){
        row.value = URL.absoluteString;
        row.onLink(row,weakCell);
    }:nil;
}


- (Class)cellClass
{
    return [AZHtmlTableViewCell class];
}

@end
