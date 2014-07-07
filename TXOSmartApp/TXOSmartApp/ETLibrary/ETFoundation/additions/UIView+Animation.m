//
//  UIView+Animation.m
//  UIAnimationSamples
//
//  Created by moxin on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Animation.h"
#import "UIWindow+Animation.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>



@implementation UIView (Animation)

@dynamic windowLayer;

- (void)setWindowLayer:(UIWindow *)windowLayer
{
    objc_setAssociatedObject(self, "windowLayer", windowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow*)windowLayer
{
    return objc_getAssociatedObject(self, "windowLayer");
}

//对view的扩展方法

//通过改变自身的frame实现平移
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs 
                          delay:0.0 
                        options:option
                     animations:^
                     {
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

//改变自身的matirx矩阵，实现转动
- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs 
                          delay:0.0 
                        options:option
                     animations:^
                     {
                         // 转动180度
                         self.transform = CGAffineTransformRotate(self.transform, M_PI);
                     }
                     completion:nil];
}


// 通过放缩来实现view的出入
- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option AutoDisappear:(BOOL)disappear
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    view.alpha = 1.0f;
    
    //这个self指的就是当前的view
    [self addSubview:view];
   
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
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

// add a window
- (void) addWindowWithZoomInSubView:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option AutoDisappear:(BOOL)disappear finish:(void (^)(BOOL finished))finish
{
    if(self.windowLayer == nil)
    {
        self.windowLayer = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.windowLayer.windowLevel = UIWindowLevelAlert+1;
        [self.windowLayer makeKeyAndVisible];
    }
    
    [self.windowLayer addSubviewWithZoomInAnimation:view
                                           duration:secs
                                             option:option
                                      AutoDisappear:disappear
                                           centerPt:self.windowLayer.center
                                      hideStatusBar:NO
                                            Completion:^(BOOL finished) {
                                                
                                                if(finished)
                                                {
                                                    if(finish)
                                                        finish(YES);
                                                }
                                            }];
    
}

// 通过放缩来实现view的出入
- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) { 
                         [self removeFromSuperview]; 
                     }];
}


// 通过改变透明度来实现view的出入
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    view.alpha = 0.0;	// make the view transparent
    [self addSubview:view];	// add it
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible 
}

- (void)removeSubviewWithFadeAnimation:(UIView*)view  duration:(float)secs option:(UIViewAnimationOptions)option
{
    view.alpha = 1.0f;
    
    [UIView animateWithDuration:secs delay:0.0 options:option animations:^{view.alpha = 0.0f ;} 

    completion:^(BOOL finished) 
    { 
        [view removeFromSuperview]; 
    }];
}

- (void) removeWithSinkAnimation:(int)steps
{
	NSTimer *timer;
	if (steps > 0 && steps < 100)	// just to avoid too much steps
		self.tag = steps;
	else
		self.tag = 50;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeWithSinkAnimationRotateTimer:) userInfo:nil repeats:YES];
}
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer
{
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0)
	{
		[timer invalidate];
		[self removeFromSuperview];
	}
}
- (void) removeWindow
{
    [self.windowLayer removeFromSuperview];
    self.windowLayer = nil;
}

//弹性效果

-(void) animationBounceInWithDirection:(ETAnimationDirection)direction boundaryView:(UIView*)boundaryView duration:(NSTimeInterval)duration
{
   
    
}

#pragma mark - tool




@end
