//
//  ETGateViewTransitionAnimation.m
//  iCoupon4Ipad
//
//  Created by moxin.xt on 14-5-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "ETGateViewTransitionAnimation.h"

@implementation ETGateViewTransitionAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //add toView to container
    UIView* container = [transitionContext containerView];

    //toView.hidden = YES;
    
//    UIView* toViewSnapShot = [toView snapshotViewAfterScreenUpdates:YES];
//    [container addSubview:toViewSnapShot];
//    toViewSnapShot.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    //cut view
    NSArray* snapShots = nil;

    
    if (self.appearing) {
        
        [container addSubview:toView];
        
        snapShots = [self createSnapshots:fromView afterScreenUpdates:NO];
        UIView* left = snapShots[0];
        UIView* right = snapShots[1];

        [container addSubview:left];
        [container addSubview:right];
        
        [UIView animateWithDuration:self.duration animations:^{
            
            left.center = CGPointMake(-0.5*left.bounds.size.width,left.center.y);
            right.center = CGPointMake(CGRectGetWidth(container.bounds) + 0.5*right.bounds.size.width,right.center.y);
            //toViewSnapShot.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        } completion:^(BOOL finished) {
            

            [left removeFromSuperview];
            [right removeFromSuperview];

            //[toViewSnapShot removeFromSuperview];
            //toView.hidden = NO;
            [transitionContext completeTransition:YES];
        
            
        }];
    }
    else
    {

        snapShots = [self createSnapShotsOldWay:toView];

        UIView* left = snapShots[0];
        UIView* right = snapShots[1];

        left.center = CGPointMake(-0.5*left.bounds.size.width,left.center.y);
        right.center = CGPointMake(CGRectGetWidth(container.bounds) + 0.5*right.bounds.size.width,right.center.y);

        [container addSubview:left];
        [container addSubview:right];
        
        [UIView animateWithDuration:self.duration animations:^{
            
            left.center = CGPointMake(left.center.x + CGRectGetWidth(left.bounds), left.center.y);
            right.center = CGPointMake(right.center.x - CGRectGetWidth(right.bounds), right.center.y);
            
        } completion:^(BOOL finished) {
            
            [left removeFromSuperview];
            [right removeFromSuperview];
            
            [container addSubview:toView];
            [transitionContext completeTransition:YES];
        }];

    }
    
    
    

    

    
    
}



-  (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    
    UIView *leftHandView = nil;
    UIView* rightHandView = nil;
    
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
        leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        leftHandView.frame = snapshotRegion;
    
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
        rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;

    return @[leftHandView, rightHandView];
}

- (UIView*)createRightSnapShot:(UIView* )view afterScreenUpdates:(BOOL) afterUpdates
{
   
    UIView* rightHandView = nil;
    
    
    CGRect snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    
    return rightHandView;
}

- (UIView* )createLeftSnapShot:(UIView* )view afterScreenUpdates:(BOOL) afterUpdates
{
    UIView *leftHandView = nil;
    
    
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;

    
    return leftHandView;
}
             
- (NSArray* )createSnapShotsOldWay:(UIView*)view
{
    UIView *leftHandView = nil;
    UIView* rightHandView = nil;
    
    UIImage* rightImage = [self renderRightSnapShot:view];
    UIImage* leftImage = [self renderLeftSnapShots:view];
    leftHandView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    leftHandView.layer.contents = (__bridge id)(leftImage.CGImage);
    
    rightHandView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height)];
    rightHandView.layer.contents = (__bridge id)(rightImage.CGImage);
    
    return @[leftHandView, rightHandView];
}

// creates a pair of snapshots from the given view
- (UIImage* )renderLeftSnapShots:(UIView* )view
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(0.5*view.bounds.size.width, view.bounds.size.height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage* )renderRightSnapShot:(UIView* )view
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(0.5*view.bounds.size.width, view.bounds.size.height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, -0.5*view.bounds.size.width, 0);
    [view.layer renderInContext:context];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
