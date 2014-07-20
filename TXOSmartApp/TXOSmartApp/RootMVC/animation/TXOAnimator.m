//
//  TXOAnimator.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXOAnimator.h"
#import "POP.h"


@interface TXOAnimator()<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) CGPoint lastPt;
@property(nonatomic, assign) BOOL bPresenting;
@property(nonatomic,assign) BOOL bInteractiving;
@property(nonatomic,assign) BOOL bInteractive;
@property(nonatomic,assign) BOOL bPresented;

@end


@implementation TXOAnimator

- (BOOL)isPresented
{
    return self.bPresented;
}

-(id)initWithFromViewController:(UIViewController *)frmVC
               ToViewController:(UIViewController* )toVC
                    Interactive:(BOOL)interactive
{
    self = [super init];
    
    if (self) {
        
        self.fromViewController = frmVC;
        self.toViewController = toVC;
        
        //interactive
        if(interactive)
        {
            self.bInteractive = interactive;
//            UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
            //gestureRecognizer.edges = UIRectEdgeLeft;
            UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];

            [frmVC.view addGestureRecognizer:gestureRecognizer];
        }
        
        
    }
    return self;
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerTransitioningDelegate


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                    sourceController:(UIViewController *)source
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    self.bPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.bPresenting = NO;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
   
    if (self.bInteractiving) {
       
        if (!self.bPresented) {
            return self;
        }
        else
            return nil;
        
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.bInteractiving) {
    
        if (self.bPresented) {
            return self;
        }
        else
            return nil;
        
    }
    return nil;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
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
    //set transition context
    _transitionContext = transitionContext;

    if (self.bInteractiving) {
     
        
    }
    else
    {
        if (self.bPresenting && !self.bPresented) {
            [self performPresentAnimation];
            
        }
        
        if (self.bPresented && !self.bPresenting) {
            [self performDismissAnimation];
        }
    }
}
- (void)animationEnded:(BOOL)transitionCompleted {
    // Reset to our default state
    
    if (self.bInteractiving) {
        self->_bInteractiving = NO;
    }

    if (self.bPresenting) {
        self ->_bPresenting = NO;
        
    }
    
    _transitionContext = nil;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - interactive transition delegate

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //2
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    _transitionContext = transitionContext;
    
    UIView* containterView = [transitionContext containerView];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    if (!self.isPresented) {
        
  
        [containterView addSubview:toVC.view];
        [containterView addSubview:fromVC.view];
    }
    else
    {
        [containterView addSubview:fromVC.view];
        [containterView addSubview:toVC.view];
        
        UIView* toView = toVC.view;
       // UIView* fromView = fromVC.view;
        
        toVC.view.frame = CGRectMake(self.lastPt.x, toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
        CGRect targetFrm = CGRectMake(0, toVC.view.frame.origin.y, 320, toVC.view.bounds.size.height);
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        spring.toValue = [NSValue valueWithCGRect:targetFrm];
        spring.springBounciness = 15;
        spring.springSpeed = 50;
        spring.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            [self.transitionContext completeTransition:YES];
            toVC.view.userInteractionEnabled = YES;
            fromVC.view.userInteractionEnabled = YES;
            self.bPresented = NO;
        };
        [toVC.view pop_addAnimation:spring forKey:@"spring"];
    }
    
  

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIPercentDrivenInteractiveTransition methods

- (void)updateInteractiveTransitionPoint:(CGPoint)pt
{

    float delatX = pt.x - self.lastPt.x;
    float delatY = pt.y - self.lastPt.y;

    CGPoint center = self.fromViewController.view.center;
    center.x += delatX;
    //center.y += delatY;
    
    NSLog(@"x:%.2f,y:%.2f",delatX,delatY);
    
    NSLog(@"new center : %@",NSStringFromCGPoint(center));
    
    self.fromViewController.view.center = center;
    
    self.lastPt = pt;
    
}
- (void)cancelInteractiveTransition
{
 
    UIView* contentView = [self.transitionContext containerView];
    UIViewController* fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC  = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    
    toView.userInteractionEnabled = NO;
    fromView.userInteractionEnabled = NO;
    
    [contentView addSubview:toView];
    [contentView addSubview:fromView];
    
    
    CGRect targetFrm = CGRectMake(0, fromView.frame.origin.y, 320, fromView.bounds.size.height);
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.toValue = [NSValue valueWithCGRect:targetFrm];
    spring.springBounciness = 15;
    spring.springSpeed = 50;
    spring.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        toView.userInteractionEnabled = YES;
        fromView.userInteractionEnabled = YES;
        [self.transitionContext completeTransition:NO];
        self.bPresented = NO;
    };
    
    [fromView pop_addAnimation:spring forKey:@"spring"];

}
- (void)finishInteractiveTransition
{
    if (self.isPresented) {
        
        [self performDismissAnimation];
    }
    else
        [self performPresentAnimation];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private methods

- (void)userDidPan:(UIScreenEdgePanGestureRecognizer* )reg
{
    CGPoint pt = [reg locationInView:self.fromViewController.view];
    CGPoint v  = [reg velocityInView:self.fromViewController.view];
    CGPoint g_pt = [self.fromViewController.view convertPoint:pt toView:[UIApplication sharedApplication].keyWindow];
    
    NSLog(@"velocity : %@",NSStringFromCGPoint(v));
    NSLog(@"point : %@",NSStringFromCGPoint(g_pt));
    NSLog(@"state : %d",reg.state);
    
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.lastPt = g_pt;
            
            self->_bInteractiving = YES;
            
            if (self.isPresented) {
                
                //noop
                NSLog(@"");
            }
            else
            {
               self -> _bPresenting = YES;
                [self.fromViewController presentViewController:self.toViewController animated:YES completion:nil];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransitionPoint:g_pt];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (self.isPresented) {
                
                if (g_pt.x < kSlideWidth) {
                    
                    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
                   // [self finishInteractiveTransition];

                }
                else
                {
                    //only pop animation:
                    CGRect targetFrm = CGRectMake(kSlideWidth, self.fromViewController.view.frame.origin.y, 320, self.fromViewController.view.bounds.size.height);
                    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    spring.toValue = [NSValue valueWithCGRect:targetFrm];
                    spring.springBounciness = 15;
                    spring.springSpeed = 50;
                    spring.completionBlock = nil;
                    [self.fromViewController.view pop_addAnimation:spring forKey:@"spring"];
          
                }
                
            }
            else
            {
                if (g_pt.x > kSlideWidth) {
                    [self finishInteractiveTransition];
                }
                else
                {
                    [self cancelInteractiveTransition];
                }
            }
  
           // self.lastPt = CGPointZero;
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)performPresentAnimation
{
    UIView* contentView = [self.transitionContext containerView];
    UIViewController* fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC  = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    
    toView.userInteractionEnabled = NO;
    fromView.userInteractionEnabled = NO;
    
    [contentView addSubview:toView];
    [contentView addSubview:fromView];
    
    
    CGRect targetFrm = CGRectMake(kSlideWidth, fromView.frame.origin.y, 320, fromView.bounds.size.height);
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.toValue = [NSValue valueWithCGRect:targetFrm];
    spring.springBounciness = 15;
    spring.springSpeed = 50;
    spring.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [self.transitionContext completeTransition:YES];
        toView.userInteractionEnabled = YES;
        fromView.userInteractionEnabled = YES;
        self.bPresented=  YES;
    };
    
    [fromView pop_addAnimation:spring forKey:@"spring"];

}
- (void)performDismissAnimation
{
    UIView* contentView = [self.transitionContext containerView];
    UIViewController* fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC  = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    toView.userInteractionEnabled = NO;
    fromView.userInteractionEnabled = NO;
    
    [contentView addSubview:fromView];
    [contentView addSubview:toView];
    
    toView.frame = CGRectMake(kSlideWidth, toView.frame.origin.y, 320, toView.bounds.size.height);
    
    CGRect targetFrm = CGRectMake(0, toView.frame.origin.y, 320, toView.bounds.size.height);
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.toValue = [NSValue valueWithCGRect:targetFrm];
    spring.springBounciness = 15;
    spring.springSpeed = 50;
    spring.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [self.transitionContext completeTransition:YES];
        toView.userInteractionEnabled = YES;
        fromView.userInteractionEnabled = YES;
        self.bPresented = NO;
    };
    [toView pop_addAnimation:spring forKey:@"spring"];
    
}


@end
