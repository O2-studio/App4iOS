//
//  ETFlipViewTransitionAnimation.m
//  iCoupon4Ipad
//
//  Created by moxin.xt on 14-4-25.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "ETFlipViewTransitionAnimation.h"

@implementation ETFlipViewTransitionAnimation
{

}
- (void)dealloc
{
    NSLog(@"[%@-->dealloc]",self.class);
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {

    //add toView to container
    UIView* container = [transitionContext containerView];
    [container addSubview:toView];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame =  initialFrame;
    toView.frame = initialFrame;
    
    //add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? -0.0005 : -0.002;
    [container.layer setSublayerTransform:transform];
 
    
    
    UIView* leftHalfToView    = nil;
    UIView* rightHalfToView   = nil;
    UIView* leftHalfFromView  = nil;
    UIView* rightHalfFromView = nil;

    NSArray* toViewSnapshots = [self createSnapshots:toView afterScreenUpdates:NO];
    NSArray* fromViewSnapshots = [self createSnapshots:fromView afterScreenUpdates:NO];
    
    leftHalfToView = toViewSnapshots[0];
    rightHalfToView = toViewSnapshots[1];
    
    leftHalfFromView = fromViewSnapshots[0];
    rightHalfFromView = fromViewSnapshots[1];
    
    if (self.isAppearing) {

        //add 1/2 left <-> fromview --> (0,0)
        leftHalfFromView.frame = (CGRect){.origin = {0,0}, .size = leftHalfFromView.frame.size};
        [container addSubview:leftHalfFromView];

        //add 1/2 right <-> tovView --> (1/2w,0)
        rightHalfToView.frame =  (CGRect){.origin = {0.5*initialFrame.size.width,0} ,.size = rightHalfToView.frame.size};
        [container addSubview:rightHalfToView];

        //add 2/2 right <->fromview --> (1/2w,0)
        rightHalfFromView.frame = (CGRect){.origin = {0.5*initialFrame.size.width,0} ,.size = rightHalfFromView.frame.size};
        rightHalfFromView.layer.anchorPoint = CGPointMake(0.0, 0.5);
        rightHalfFromView.frame = CGRectOffset(rightHalfFromView.frame, (rightHalfFromView.layer.anchorPoint.x-0.5)*CGRectGetWidth(rightHalfFromView.frame), 0);
        //add shadow
        [container addSubview:rightHalfFromView];
        
        
        //rotate right half to-view to 90 degree
        //add 1/2 left <-> toview --> (0,0)
        leftHalfToView.frame = (CGRect){.origin = {0,0} ,.size =leftHalfToView.frame.size};
        leftHalfToView.layer.anchorPoint = CGPointMake(1.0, 0.5);
        leftHalfToView.frame = CGRectOffset(leftHalfToView.frame, (leftHalfToView.layer.anchorPoint.x-0.5)*CGRectGetWidth(leftHalfToView.frame), 0);
        [container addSubview:leftHalfToView];
        leftHalfToView.layer.transform = CATransform3DMakeRotation(90.0f * M_PI / 180.0f, 0, 1, 0.0);


    }
    else
    {
        //add 1/2 right <-> fromview --> (1/2,0)(1/2w,h)
        rightHalfFromView.frame =  (CGRect){.origin = {0.5*initialFrame.size.width,0} ,.size = rightHalfFromView.frame.size};
        [container addSubview:rightHalfFromView];
        
        //add 1/2 left <->toView --> （0,0）(1/2w,h)
        leftHalfToView.frame = (CGRect){.origin = {0,0}, .size = leftHalfToView.frame.size};
        [container addSubview:leftHalfToView];

        //add 2/2 left <->fromview --> (0,0)(1/2w,h)
        leftHalfFromView.frame = (CGRect){.origin = {0,0}, .size = leftHalfFromView.frame.size};
        leftHalfFromView.layer.anchorPoint = CGPointMake(1.0, 0.5);
        leftHalfFromView.frame = CGRectOffset(leftHalfFromView.frame, (leftHalfFromView.layer.anchorPoint.x-0.5)*CGRectGetWidth(leftHalfFromView.frame), 0);
        [container addSubview:leftHalfFromView];
        
        rightHalfToView.frame = (CGRect){.origin = {0.5*initialFrame.size.width,0}, .size = rightHalfToView.frame.size};
        rightHalfToView.layer.anchorPoint = CGPointMake(0.0, 0.5);
        rightHalfToView.frame = CGRectOffset(rightHalfToView.frame, (rightHalfToView.layer.anchorPoint.x-0.5)*CGRectGetWidth(rightHalfToView.frame), 0);
        [container addSubview:rightHalfToView];
        
        //rotate right half to-view to 90 degree
        rightHalfToView.layer.transform = CATransform3DMakeRotation(-90.0f * M_PI / 180.0f, 0, 1, 0.0);

    }
    
    //start keyframe animation
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
        
        if (self.appearing) {
            
            //right-fromview rotate from 0 to -90 degree
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
               
                rightHalfFromView.layer.transform = CATransform3DMakeRotation(-90.0f * M_PI / 180.0f, 0, 1, 0.0);
            }];
            
            //left-toview rotate from -90 to -180 degree
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                
                leftHalfToView.layer.transform = CATransform3DMakeRotation(0.01, 0, 1, 0.0);
            }];
            
        }
        else
        {
            //left-fromview rotate from 0 to 90 degree
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                
                leftHalfFromView.layer.transform = CATransform3DMakeRotation(90.0f * M_PI / 180.0f, 0, 1, 0.0);
            }];

            //left-toview rotate from 90 to 180 degree
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                
                rightHalfToView.layer.transform = CATransform3DMakeRotation(-0.01, 0, 1, 0.0);
            }];
            
        }
        
        
    } completion:^(BOOL finished) {
        
//        if(finished )
//        {
//        
            [leftHalfFromView removeFromSuperview];
            [rightHalfFromView removeFromSuperview];
            [leftHalfToView removeFromSuperview];
            [rightHalfToView removeFromSuperview];
            
            [transitionContext completeTransition:YES];
//        }
     
    }];
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
-  (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{

    UIView *leftHandView = nil;
    UIView* rightHandView = nil;

//    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
//    leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
//    leftHandView.frame = snapshotRegion;
//    
//    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
//    rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
//    rightHandView.frame = snapshotRegion;
//    
    
    UIImage* rightImage = [self renderRightSnapShot:view];
    UIImage* leftImage = [self renderLeftSnapShots:view];
    leftHandView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    leftHandView.layer.contents = (__bridge id)(leftImage.CGImage);
    
    rightHandView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    rightHandView.layer.contents = (__bridge id)(rightImage.CGImage);
        

    return @[leftHandView, rightHandView];
}



@end
