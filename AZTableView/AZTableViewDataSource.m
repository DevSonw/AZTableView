//
//  AZTableViewDataSource.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewDataSource.h"
#import "AZTableView.h"

@implementation AZTableViewDataSource


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(AZTableView *)tableView
{
    // Return the number of sections.
    return [tableView.root numberOfVisibleSections];
}

- (NSInteger)tableView:(AZTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[tableView.root visibleSectionAtIndex:section] numberOfVisibleRows];
}

- (NSArray *)sectionIndexTitlesForTableView:(AZTableView *)tableView{
    if (!tableView.root.showIndexTitle) {
        return nil;
    }
    NSArray *sections = tableView.root.sections;
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[sections count]];
    for (AZSection *sec in sections) {
        if (!sec.hidden && (sec.indexTitle || sec.header)) {
            [titles addObject:sec.indexTitle ? sec.indexTitle : sec.header];
        }
    }
    return [titles count] ? titles : nil;
}

- (UITableViewCell *)tableView:(AZTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    return [row cellForTableView:tableView indexPath:indexPath];
}

- (NSString *)tableView:(AZTableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[tableView.root visibleSectionAtIndex:section] header];
}

- (NSString *)tableView:(AZTableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [[tableView.root visibleSectionAtIndex:section] footer];
}

- (BOOL)tableView:(AZTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    return (row.deletable || row.sortable) && row.enabled;
}

- (void)tableView:(AZTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
        if (row.onDelete) {
            row.onDelete(row, [tableView cellForRowAtIndexPath:indexPath]);
        } else{
            [tableView deleteRow:row indexPath:indexPath];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void)tableView:(AZTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    AZSection *section = [tableView.root visibleSectionAtIndex:fromIndexPath.section];
    AZRow *row = [section visibleRowAtIndex:fromIndexPath.row];
    
    [tableView.root moveVisibleRowFromIndex:fromIndexPath toIndexPath:toIndexPath];

    if (row.onMove) {
        row.onMove(row, [tableView cellForRowAtIndexPath:fromIndexPath]);
    }
}

- (BOOL)tableView:(AZTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    return row.sortable && row.enabled;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
