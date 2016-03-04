//
//  AZFieldTableViewCell.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/4.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewCell.h"
#import "AZTableView.h"

@protocol  AZFieldTableViewCellDelegate;

@interface AZFieldTableViewCell : AZTableViewCell

@property (nonatomic, assign) id<AZFieldTableViewCellDelegate> delegate;// default is nil. weak reference

@end

@protocol AZFieldTableViewCellDelegate <NSObject>

@optional

- (void)tableViewCell:(AZFieldTableViewCell *)tableViewCell valueChanged:(id)value;


@end
