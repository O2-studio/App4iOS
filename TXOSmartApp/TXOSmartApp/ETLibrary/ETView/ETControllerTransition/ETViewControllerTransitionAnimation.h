//
//  ETViewControllerTransitionAnimation.h
//  iCoupon4Ipad
//
//  Created by moxin.xt on 14-4-24.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETViewControllerTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign, getter = isAppearing) BOOL appearing;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;




@end
