//
//  ETBounceViewTransitionAnimation.m
//  iCoupon4Ipad
//
//  Created by moxin.xt on 14-4-25.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "ETBounceViewTransitionAnimation.h"

@interface ETBounceViewTransitionAnimation()<UIDynamicAnimatorDelegate>

@property(nonatomic,strong) id<UIViewControllerContextTransitioning> context;
@property(nonatomic,strong) UIDynamicAnimator* dynamicAnimator;

@end


@implementation ETBounceViewTransitionAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {

    
    UIView* contentView = [transitionContext containerView];
    
    if (!self.dynamicAnimator) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:contentView];
        self.dynamicAnimator.delegate = self;
    }
    
    [contentView addSubview:toView];
    CGRect toRect = CGRectOffset(toView.frame, toView.frame.size.width-1, 0);
    toView.frame = toRect;
    
    UIGravityBehavior* behavior = [[UIGravityBehavior alloc]initWithItems:@[toView]];
    [behavior setGravityDirection:CGVectorMake(-1.0, 0.0)];
    [self.dynamicAnimator addBehavior:behavior];
    
    UICollisionBehavior* collision = [[UICollisionBehavior alloc]initWithItems:@[toView]];
    //[collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [collision addBoundaryWithIdentifier:@"kkk" fromPoint:CGPointMake(0, 100) toPoint:CGPointMake(0, 400)];
    [self.dynamicAnimator addBehavior:collision];
//
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[toView]];
    itemBehavior.elasticity = 0.3;
    [self.dynamicAnimator addBehavior:itemBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    [animator.behaviors enumerateObjectsUsingBlock:^(UIDynamicBehavior* obj, NSUInteger idx, BOOL *stop) {
       
        if ([obj isKindOfClass:[UIDynamicItemBehavior class]]) {
            
            [self.context completeTransition:YES];
           // break;
        }
    }];
}
@end
