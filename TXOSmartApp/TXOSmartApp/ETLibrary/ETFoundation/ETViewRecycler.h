//
//  ETViewRecycler.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-11-29.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETRecycableView;
/**
 * 回收ETRecycableView对象，用于需要大量复用view的场景
 */
@interface ETViewRecycler : NSObject
/**
 *  根据重用的identifier获取ETRecycableView对象
 *
 *  @param reuseIdentifier 复用字符串
 *
 *  @return ETRecycableView对象
 */
- (ETRecycableView *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier;
/**
 *  回收ETRecycableView对象
 *
 *  @param view ETRecycableView对象
 */
- (void)recycleView:(ETRecycableView *)view;
/**
 *  释放所有cache的view
 */
- (void)removeAllViews;

@end


/**
 *  需要回收使用的view都应该继承ETRecycableView
 *
 *  @IMPORTANT ：如果不指定view的bound，那么默认view的大小和superview大小相同
 *               如果指定view的frame，需要使用view.frame来赋值。initWithFrame无效。
 *
 */
@interface ETRecycableView : UIView

@property (nonatomic, readwrite, copy) NSString* reuseIdentifier;

/**
 *  默认的构造方法
 *
 *  @param reuseIdentifier 复用串
 *
 *  @return ETRecycableView对象
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
/**
 * 当view被重用时调用
 */
- (void)prepareForReuse;
@end
