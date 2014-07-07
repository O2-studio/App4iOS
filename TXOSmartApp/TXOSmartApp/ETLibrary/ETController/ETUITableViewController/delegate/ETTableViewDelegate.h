//
//  ETTableViewDelegate.h
//  Created by moxin on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>


@protocol ETTableViewCellDelegate;
@protocol ETTableViewDelegate <UITableViewDelegate>
@end

/**
 第三方下拉刷新的view实现这四个方法
 */
@protocol ETTableViewPullRefreshControllerDelegate <NSObject>

@required
- (void)scrollviewDidScroll:(UIScrollView*)scrollview;
- (void)scrollviewDidEndDragging:(UIScrollView*)scrollview;
- (void)startRefreshing;
- (void)stopRefreshing;
@end

@interface ETTableViewDelegate : NSObject<ETTableViewDelegate,ETTableViewCellDelegate>

/**
 a weak reference to view controller
 */
@property (nonatomic, weak) ETTableViewController* controller;
/**
 custom pull-refresh view
 */
@property(nonatomic,strong) id<ETTableViewPullRefreshControllerDelegate> pullRefreshView;
/**
 begin & end pull refresh
 */
- (void)beginRefreshing;
- (void)endRefreshing;



@end
