//
//  ETUIPagingChildView.h
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETViewRecycler.h"

/**
 *  ETUIPagingScrollView的subview需要继承这个类
 */
@interface ETUIPagingChildView : ETRecycableView
/**
 *  view的index
 */
@property(nonatomic,assign) NSInteger pageIndex;
/**
 *  这个方法在childview被add到scrollview之前执行
 */
- (void)childViewWillAppear;
/**
 *  这个方法在childView被add到scrollview之后执行
 */
- (void)childViewDidAppear;
/**
 *  这个方法在view将被回收时调用，用来保存当前状态的时机
 */
- (void)childViewWillBeRecycled;
/**
 *  这个方法在view被回收后调用
 */
- (void)childViewDidBeRecycled;
@end
