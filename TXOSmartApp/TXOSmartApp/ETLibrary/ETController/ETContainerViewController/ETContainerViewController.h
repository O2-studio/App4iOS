//
//  ETContainerViewController.h
//  etaoshopping
//
//  Created by moxin.xt on 12-11-2.
//
//

#import "ETUIViewController.h"

@class ETContainerViewController;

@protocol ETContainerViewController <NSObject>

@optional

- (BOOL)ETContainerViewController:(ETContainerViewController *)viewController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)ETContainerViewController:(ETContainerViewController *)viewController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;

@end


typedef void (^TransitionBlock)();

@interface ETContainerViewController : ETUIViewController
{
    @protected
    NSUInteger _selectedIndex;
}

/*
 * container view
 */
@property (nonatomic,strong)UIView* contentContainerView;
/*
 * child controllers
 */
@property (nonatomic, copy) NSArray *viewControllers;
/*
 * 选中的controller
 */
@property (nonatomic, weak,readonly) UIViewController *selectedViewController;
/*
 * transition from “fromViewController” to "toViewController"
 */
@property (nonatomic, weak,readonly) UIViewController *fromViewController;
@property (nonatomic, weak,readonly) UIViewController *toViewController;
/*
 * transition from "oldSelectedIndex" to "selectedIndex"
 */
@property (nonatomic, assign,readonly) NSUInteger oldSelectedIndex;
@property (nonatomic, assign) NSUInteger selectedIndex;
/*
 * delegate
 */
@property (nonatomic, weak) id <ETContainerViewController> delegate;

#pragma mark - public interface

/**
 根据目标index 切换当前controller
 */
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
/**
 根据目标controller 切换当前controller
 */
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 无效选中状态
 */
- (void)selectedIndexInvalid;

/**
 index will change
 */
- (void)selectedIndexWillChange;

/**
 index did change
 */
- (void)selectedIndexDidChange;
/**
 切换动画开始前
 */
- (void)transitionAnimationBegin;
/**
 切换动画完成
 */
- (void)transitionAnimationEnd;
/**
 切换动画
 */
- (void)transitionAnimationProceeding;






@end
