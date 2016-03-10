//
//  AZRoot.h
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZSection.h"
#import "AZRow.h"

typedef void (^AZRootEvent)(NSString *eventName, AZRow *row, UIView *fromView);

/**
 The root config for the tableView
 */

@class AZTableView;
@class AZCollectionView;


@interface AZRoot : NSObject

@property(nonatomic, weak) AZTableView *tableView; ///< Week reference the tableView
@property(nonatomic, weak) AZCollectionView *collectionView; ///< Week reference the collectionView

@property (assign) BOOL grouped;
@property (assign, nonatomic) BOOL highPerformance;
@property (assign) BOOL showIndexTitle;

@property (retain, nonatomic) NSMutableArray<AZSection *> *sections;


- (void)addSection:(AZSection *)section;
- (AZSection *)sectionAtIndex:(NSInteger)index;
- (NSInteger)numberOfSections;

- (AZSection *)visibleSectionAtIndex:(NSInteger)index;
- (NSInteger)numberOfVisibleSections;
- (NSUInteger)indexForVisibleSection: (AZSection*)section;
- (AZRow *)visibleRowAtIndexPath:(NSIndexPath *)indexPath;

- (AZRow *)firstFocusableRow;
- (AZRow *)lastFocusableRow;
- (AZRow *)nextSiblingFocusableRow:(AZRow *)row;
- (AZRow *)prevSiblingFocusableRow:(AZRow *)row;
- (AZRow *)focusedRow;

- (void)moveVisibleRowFromIndex:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;


/**
 The property and method extend for create model by YYModel
 */

@property (retain, nonatomic) NSDictionary *bindData;
@property (copy, nonatomic) AZRootEvent onEvent;

+(NSDictionary *)dataFromBind:(NSDictionary *)bind source:(NSDictionary *)source;
+(void)transformTemplate:(NSString *)key data:(NSMutableDictionary *)data;

@end
