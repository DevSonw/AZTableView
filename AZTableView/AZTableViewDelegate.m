//
//  AZTableViewDelegate.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZTableViewDelegate.h"
#import "AZTableView.h"
@class AZTableViewCell;

@implementation AZTableViewDelegate

- (void)tableView:(AZTableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    [row selectedAccessory:tableView indexPath:indexPath];
}

- (void)tableView:(AZTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    [row selected:tableView indexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(AZTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    return row.deletable && row.enabled ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(AZTableView *)tableView heightForHeaderInSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    return [sec headerHeightForTableView:tableView];
}

- (UIView *)tableView:(AZTableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    return [sec headerForTableView:tableView];
}

- (CGFloat)tableView:(AZTableView *)tableView heightForFooterInSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    return [sec footerHeightForTableView:tableView];
}

- (UIView *)tableView:(AZTableView *)tableView viewForFooterInSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    return [sec footerForTableView:tableView];
}

- (void)tableView:(AZTableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    [sec willDisplayHeaderView:view forTableView:tableView];
}

- (void)tableView:(AZTableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    [sec willDisplayFooterView:view forTableView:tableView];
}

-(void)tableView:(AZTableView *)tableView willDisplayCell:(AZTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    [row willDisplayCell:cell forTableView:tableView];
}

- (void)tableView:(AZTableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    [sec didEndDisplayingHeaderView:view forTableView:tableView];
}

- (void)tableView:(AZTableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    AZSection *sec = [tableView.root visibleSectionAtIndex:section];
    [sec didEndDisplayingFooterView:view forTableView:tableView];
}

- (void)tableView:(AZTableView *)tableView didEndDisplayingCell:(AZTableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    AZRow *row = [tableView.root visibleRowAtIndexPath:indexPath];
    [row didEndDisplayingCell:cell forTableView:tableView];
}

- (NSIndexPath *)tableView:(AZTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{

    AZSection *fromSection = [tableView.root visibleSectionAtIndex:sourceIndexPath.section];
    AZSection *toSection = [tableView.root visibleSectionAtIndex:proposedDestinationIndexPath.section];
    if( !(fromSection.ref == toSection.ref || [fromSection.ref isEqualToString:toSection.ref]) )
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
}

@end
