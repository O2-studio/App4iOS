//
//  ETTableViewDataSource.h
//  Created by moxin on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ETTableViewItem.h"

@class ETTableViewListDataModel,ETTableViewController;

@protocol ETTableViewDataSource <UITableViewDataSource>
/* 
 * 指定cell的类型 
 */
- (Class)cellClassForItem:(ETTableViewItem*)item AtIndex:(NSIndexPath *)indexPath;
/**
  指定返回的item
 */
- (ETTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath;
/**
 绑定items和model
 */
- (void)tableViewControllerDidLoadModel:(ETTableViewListDataModel*)model ForSection:(NSInteger)section;

@end


@interface ETTableViewDataSource : NSObject<ETTableViewDataSource>

/**
 remote controller
 */
@property(nonatomic,weak)  ETTableViewController*  controller;
/**
 <k:NSArray v:section>
 section到列表数据的映射
 */
@property(nonatomic,strong)  NSDictionary* itemsForSection;
/**
 <k:NSInterger v:section>
 section到列表数据总数的映射
 */
@property(nonatomic,strong)  NSDictionary* totalCountForSection;

/**
 给datasource赋值
 */
- (void)setItems:(NSArray*)items ForSection:(NSInteger)n;
/**
 clear datasource中的数据
 */
- (void)removeItemsForSection:(NSInteger)n;
- (void)removeAllItems;

@end
