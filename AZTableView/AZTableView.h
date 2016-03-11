//
//  AZTableView.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYImage/YYImage.h>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"
#endif

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

@property (assign) BOOL bounce; ///< If always bounce vertical.
@property (assign) float offsetTop;

@property (assign) BOOL shouldCheckKeyboard; ///< Fix tableView content inset when input row focus.

-(id)initWithRoot:(AZRoot *)root;

/**
 Deselect the cell.
 */
-(void)deselect;


/**
 Scroll at the top of tableView.
 */
-(void)scrollToTop;


/**
 Scroll to the cell.
 */

- (void)focusCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 Delete thw row from the section, Delete the row display cell from the table.
 
 @param row The row for delete.
 @param indexPath The indexPath of the cell.
 */
- (void)deleteRow:(AZRow *)row indexPath:(NSIndexPath *)indexPath;

/**
 Update the row display cell.
 
 @param row The row for update.
 @param indexPath The indexPath of the cell.
 @return false when the cell is not show.
 */
- (BOOL)updateCellForRow:(AZRow *)row indexPath:(NSIndexPath *)indexPath;


@end
