//
//  ETUIPagingScrollView.h
//  ETLibSDK
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ETUIPagingChildView;
@class ETUIPagingScrollView;

@protocol ETUIPagingScrollViewDelegate <UIScrollViewDelegate>

/**
 * scrollview滚动回调
 */
- (void)pagingScrollViewDidScroll:(ETUIPagingScrollView *)pagingScrollView;
/**
 * 当前页的index将要改变
 */
- (void)pagingScrollViewWillChangePages:(ETUIPagingScrollView *)pagingScrollView;

/**
 * 当前页的index已经改变
 */
- (void)pagingScrollViewDidChangePages:(ETUIPagingScrollView *)pagingScrollView;
@end

@protocol ETUIPagingScrollViewDataSource <NSObject>

@required
/**
 * 返回scrollview中childview的个数
 */
- (NSInteger)numberOfPagesInPagingScrollView:(ETUIPagingScrollView *)pagingScrollView;

/**
 * 根据index获取childview
 */
- (ETUIPagingChildView *)pagingScrollView:(ETUIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex;

@end


/**
 * default value of page margin is 0 pixel
 */
extern const CGFloat kETUIPagingScrollViewDefaultPageMargin;
/**
 * default value of page number is -1
 */
extern const NSInteger kETUIPagingScrollViewDefaultNumberOfPage;
/**
 *  适用于需要不断回收subview的场景
 */
@interface ETUIPagingScrollView : UIView<UIScrollViewDelegate>
/**
 *  dataSource
 */
@property(nonatomic,assign) id<ETUIPagingScrollViewDataSource> dataSource;
/**
 *  delegate
 */
@property(nonatomic,assign) id<ETUIPagingScrollViewDelegate> delegate;

/**
 *  内部scrollview
 */
@property (nonatomic, readonly, strong) UIScrollView* scrollView;
/**
 *  通过datasource获取的page数量
 */
@property (nonatomic, readonly, assign) NSInteger numberOfPages;
/**
 *  当前可见的pages
 */
@property (nonatomic, readonly, strong) NSMutableSet* visiblePages;

/**
 *  当前childview的index
 */
@property(nonatomic,assign,readonly) NSInteger centerPageIndex;
/**
 *  page margin
 */
@property(nonatomic,assign) CGFloat pageMargin;
/**
 * has next page
 */
@property(nonatomic,assign) BOOL hasNextPage;
/**
 *  has previous page
 */
@property(nonatomic,assign) BOOL hasPreviousPage;

/**
 *  load pages on screen
 */
- (void)reloadData;
/**
 *  获取重用的child view
 *
 *  @param identifier 重用view的identifier
 *
 *  @return 重用的childview
 */
- (ETUIPagingChildView*)dequeueReusablePageWithIdentifier:(NSString *)identifier;
/**
 *  获取当前显示的childview
 *
 *  @return 当前显示的childview
 */
- (ETUIPagingChildView*)centerPageView;
/**
 *  滚动到下一页
 *
 *  @param animated 是否需要动画效果
 */
- (void)showNextPage:(BOOL)animated;
/**
 *  滚动到前一页
 *
 *  @param animated 是否需要动画效果
 */
- (void)showPrevioutsPage:(BOOL)animated;
/**
 *  滚到某一页
 *
 *  @param pageIndex 页数
 *  @param b         是否需要动画效果
 */
- (void)centerPageAtIndex:(NSInteger)pageIndex animated:(BOOL)b;


@end

@interface ETUIPagingScrollView(SubclassingOverride)

/**
 *  某一页将被显示的回调
 *
 *  @param index 待显示view的index
 */
- (void)willDisplayPageAtIndex:(NSInteger)index;
/**
 *  某一页已经被显示出来
 *
 *  @param index 被显示view的index
 */
- (void)didDisplayPageAtIndex:(NSInteger)index;
/**
 *  center page被展示出来
 */
- (void)centerPageDidAppear;

@end
