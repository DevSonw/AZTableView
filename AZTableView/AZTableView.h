//
//  AZTableView.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZRoot.h"
#import "AZSection.h"
#import "AZRow.h"


@interface AZTableView : UITableView{
@private
id <UITableViewDataSource> bbDataSource;
id <UITableViewDelegate> bbDelegate;
}

//editing, separatorColor, backgroundColor, rowHeight

@property (nonatomic, retain) AZRoot *root; ///< The root setting
@property (strong, nonatomic) NSString *refreshAction;

-(id)initWithRoot:(AZRoot *)root;

-(void)deselect;

-(void)action:(id)action data:(id)data extra:(id)extra;

-(BOOL)deleteRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)stopRefresh;
- (void)refresh;

- (void)focusRow:(AZRow *)row;
- (void)focusRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)updateRow:(id)setting indexPath:(NSIndexPath *)indexPath;


@end
