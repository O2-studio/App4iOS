//
//  TBCitySBTableViewController.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBViewController.h"

@class TBCitySBTableViewDelegate;
@class TBCitySBTableViewDataSource;
@class TBCitySBListModel;


#define __should_handle_memory_warning__ 1

@interface TBCitySBTableViewController : TBCitySBViewController

/**
 *  tablview
 */
@property(nonatomic,strong) UITableView* tableView;
/**
 *  tablview的delegate和datasource
 */
@property(nonatomic,strong) TBCitySBTableViewDataSource* dataSource;
@property(nonatomic,strong) TBCitySBTableViewDelegate*   delegate;
/**
 *  keyModel:@REQUIRED : 用来翻页的model，必须不为空
 */
@property(nonatomic,strong) TBCitySBListModel* keyModel;
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
 * 加载某个section对应的model
 */
- (void)loadModelForSection:(NSInteger)section;
/**
 * 重新加载某个section对应的model
 */
- (void)reloadModelForSection:(NSInteger)section;
/**
 *  根据model的key来加载model
 *
 *  适用：多个model对应一个section，tab切换的场景
 *
 *  v = SBMVC => 1.1
 *
 *  @param key
 */
- (void)loadModelByKey:(NSString* )key;
/**
 *  根据model的key来重新加载model
 *
 *  适用：多个model对应一个section，tab切换的场景
 *
 *  v = SBMVC => 1.1
 *
 *  @param key
 */
- (void)reloadModelByKey:(NSString*)key;

/**
 * 显示下拉刷新
 */
- (void)beginRefreshing;
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing;

@end


@interface TBCitySBTableViewController(UITableView)

/**
 * tableview cell的点击事件
 */
- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 * tableview cell的UI组件点击，bunlde中存放了自定义的参数
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary*)bundle;
/**
 * tableview cell的编辑事件
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 * scrollview的滚动回调
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
/**
 * scrollview拖拽释放后的回调
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 * scrollview拖拽事件回调
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;
/**
 * scrollview停止滚动回调
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView ;

@end

@interface TBCitySBTableViewController(FooterView)

/**
 *  展示没有数据的footerview状态
 *
 *  @param model 请求完成的model
 */
- (void)showNoResult:(TBCitySBListModel *)model;
/**
 *  展示model滚动完成的footerview状态
 *
 *  @param model 请求完成的model
 */
- (void)showComplete:(TBCitySBListModel *)model;
/**
 *  展示loadmore的footerview状态，如果loadmoreAutomatically则不会显示这个状态
 */
- (void)showLoadMoreFooterView;

@end
