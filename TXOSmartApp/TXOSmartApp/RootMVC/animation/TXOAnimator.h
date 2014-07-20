//
//  TXOAnimator.h
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kSlideWidth 100
@interface TXOAnimator : UIPercentDrivenInteractiveTransition<UIViewControllerTransitioningDelegate>

//non-interactive transition
@property(nonatomic, assign) BOOL transitionDuration;
@property(nonatomic,assign,readonly,getter = isPresented) BOOL presented;
@property(nonatomic,weak) UIViewController* fromViewController;
@property(nonatomic,weak) UIViewController* toViewController;
@property(nonatomic,strong,readonly) id<UIViewControllerContextTransitioning> transitionContext;




-(id)initWithFromViewController:(UIViewController *)frmVC
               ToViewController:(UIViewController* )toVC
                    Interactive:(BOOL)interactive;

//non-interactive hooks
- (void)performPresentAnimation;
- (void)performDismissAnimation;

@end
