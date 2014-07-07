//
//  TXOAnimator.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXOAnimator.h"
#import "POP.h"


@implementation TXOAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    //get container view
    UIView* contentView = [transitionContext containerView];

    if (self.bPresenting) {
        
        toView.userInteractionEnabled = NO;
        fromView.userInteractionEnabled = NO;
        
        [contentView addSubview:toView];
        [contentView addSubview:fromView];
  
        
        
        
        [UIView animateWithDuration:self.duration animations:^{
            
            fromView.frame = CGRectMake(100, fromView.frame.origin.y, 320, fromView.bounds.size.height);
            
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            toView.userInteractionEnabled = YES;
            fromView.userInteractionEnabled = YES;
        }];
        
    }
    else
    {
        toView.userInteractionEnabled = NO;
        fromView.userInteractionEnabled = NO;
        
        [contentView addSubview:fromView];
        [contentView addSubview:toView];
        
        toView.frame = CGRectMake(100, toView.frame.origin.y, 320, toView.bounds.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            
            toView.frame = CGRectMake(0, toView.frame.origin.y, 320, toView.bounds.size.height);
            
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            toView.userInteractionEnabled = YES;
            fromView.userInteractionEnabled = YES;
        }];
    }
    
}

@end
