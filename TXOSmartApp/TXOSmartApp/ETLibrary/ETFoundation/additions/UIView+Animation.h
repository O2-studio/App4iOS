//
//  UIView+Animation.h
//  UIAnimationSamples
//
//  Created by moxin on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//所有view的animation动画都在这，逐渐补充各种各样的动画

//moxin:

/*
 这个控件继承于view，那么如果想要“这个”控件实现一些动画，
 我可以将自己的方法封装到view中，其中^{}中的对象永远是self
 
 */
typedef enum  
{
	kSEAnimationTop = 0,
	kSEAnimationRight,
	kSEAnimationBottom,
	kSEAnimationLeft,
	kSEAnimationTopLeft,
	kSEAnimationTopRight,
	kSEAnimationBottomLeft,
	kSEAnimationBottomRight
}
ETAnimationDirection;

/**
 
 */
typedef enum _SEAnimationSpinDirection
{
	kSEAnimationSpinClockwise,
	kSEAnimationSpinCounterClockwise
}
ETAnimationSpinDirection;

@interface UIView (Animation)

@property(nonatomic,strong) UIWindow* windowLayer;

/*
 * move 
 */
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option;

/*
 * add subview
 */

- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option AutoDisappear:(BOOL)disappear;
- (void) addWindowWithZoomInSubView:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option AutoDisappear:(BOOL)disappear finish:(void (^)(BOOL finished))finish;

/*
 * remove subview
 */
- (void) removeSubviewWithFadeAnimation:(UIView*)view  duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithSinkAnimation:(int)steps;
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer;
- (void) removeWindow;

/*
 * bounce effect
 */
-(void) animationBounceInWithDirection:(ETAnimationDirection)direction boundaryView:(UIView*)boundaryView duration:(NSTimeInterval)duration;


@end
