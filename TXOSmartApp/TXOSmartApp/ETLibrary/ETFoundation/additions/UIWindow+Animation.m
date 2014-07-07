//
//  UIWindow+Animation.m
//  etaoshopping
//
//  Created by moxin.xt on 12-11-26.
//
//

#import "UIWindow+Animation.h"

@implementation UIWindow (Animation)

- (void) addSubviewWithZoomInFadeOutAnimation:(UIView *)view duration:(float)secs option:(UIViewAnimationOptions)option AutoDisappear:(BOOL)disappear centerPt:(CGPoint)pt
{
    view.transform = view.transform;	// do it instantly, no animation
    view.alpha = 1.0f;
    view.center = pt;
    
    //这个self指的就是当前的view
    [self addSubview:view];
    
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.1 options:option
                     animations:^{
                         
                         //[[UIApplication sharedApplication] setStatusBarHidden:YES];
                         view.transform = CGAffineTransformScale(view.transform, 4, 4);
                         view.center = self.center;
                         view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished)
     {
         
         if(disappear)
         {
             [UIView animateWithDuration:0.6 delay:0.8f options:option animations:^
              {
                  view.alpha = 0.0f;
              }
            completion:^(BOOL finished)
              {
                  if (finished)
                  {
                      [view removeFromSuperview];
                  }
              }];
         }
         
     }];

}

- (void) addSubviewWithZoomInAnimation:(UIView *)view
                              duration:(float)secs option:(UIViewAnimationOptions)option
                         AutoDisappear:(BOOL)disappear
                              centerPt:(CGPoint)pt
                         hideStatusBar:(BOOL)hide
                            Completion:(void (^)(BOOL finished))finish
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    view.alpha = 0.0f;
    view.center = pt;
    
    //这个self指的就是当前的view
    [self addSubview:view];
    
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         
                         if(hide)
                             [[UIApplication sharedApplication] setStatusBarHidden:YES];
                         
                         view.transform = CGAffineTransformScale(view.transform, 100, 100);
                         view.alpha = 1.0f;
                         view.center = self.center;
                     }
                     completion:^(BOOL finished)
     {
         
         if(disappear)
         {
             [UIView animateWithDuration:0.6 delay:0.8f options:option animations:^
              {
                  view.alpha = 0.0f;
              }
              completion:^(BOOL finished)
              {
                  if (finished)
                  {
                      [view removeFromSuperview];
                      
                      if(finished)
                          finish(YES);
                  }
              }];
         }
         
    }];
}

- (void)removeSubviewWithFadeAnimation:(UIView*)view  duration:(float)secs option:(UIViewAnimationOptions)option
{
    view.alpha = 1.0f;
    
    [UIView animateWithDuration:secs delay:0.0 options:option animations:^{view.alpha = 0.0f ;
             [[UIApplication sharedApplication] setStatusBarHidden:NO];}
     
                     completion:^(BOOL finished)
     {

         [view removeFromSuperview];


     }];
}

@end
