//
//  ETTableViewController.h
//  Created by moxin on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//




#include<Foundation/Foundation.h>
#include<UIKit/UIKit.h>


@class ETTableViewListDataModel;
@class ETTableViewDataSource;
@class ETTableViewDelegate;

@interface ETTableViewController : ETModelViewController

/**
 *  tablview
 */
@property(nonatomic,strong) UITableView* tableView;
/**
 *  tablview的delegate和datasource
 */
@property(nonatomic,strong) ETTableViewDataSource* dataSource;
@property(nonatomic,strong) ETTableViewDelegate*   delegate;
/**
 *  keyModel:用来翻页的model，必须不为空
 */
@property(nonatomic,strong) ETTableViewListDataModel* keyModel;
/**
 *  自动翻页的标志位
 */
@property(nonatomic,assign) BOOL loadmoreAutomatically;
/**
 *  是否需要翻页
 */
@property(nonatomic,assign) BOOL bNeedLoadMore;
/**
 *  是否需要下拉刷新
 */
@property(nonatomic,assign) BOOL bNeedPullRefresh;
/**
 * 加载某个section的model
 */
- (void)loadModelForSection:(NSInteger)section;
/**
 * 重新加载某个section的model
 */
- (void)reloadModelForSection:(NSInteger)section;
/**
 * 显示下拉刷新
 */
- (void)beginRefreshing;
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing;

@end



@interface ETTableViewController(Subclassing)
/**
 *  展示没有数据的footerview状态
 *
 *  @param model 请求完成的model
 */
- (void)showNoResult:(ETTableViewListDataModel*)model;
/**
 *  展示model滚动完成的footerview状态
 *
 *  @param model 请求完成的model
 */
- (void)showComplete:(ETTableViewListDataModel*)model;
/**
 *  展示loadmore的footerview状态，如果loadmoreAutomatically则不会显示这个状态
 */
- (void)showLoadMoreFooterView;


@end

@interface ETTableViewController(UIScrollView)

/**
 *  scrollview's datasource
 *
 */
- (void)tableView:(UITableView*)tableView  didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary*)bundle;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 * scrollview's controller delegate
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView ;

@end

