//
//  UIWindow+Animation.h
//  etaoshopping
//
//  Created by moxin.xt on 12-11-26.
//
//

#import <UIKit/UIKit.h>

@interface UIWindow (Animation)


- (void) addSubviewWithZoomInAnimation:(UIView *)view
                              duration:(float)secs option:(UIViewAnimationOptions)option
                         AutoDisappear:(BOOL)disappear
                              centerPt:(CGPoint)pt
                         hideStatusBar:(BOOL)hide
                            Completion:(void (^)(BOOL finished))finish;

- (void) removeSubviewWithFadeAnimation:(UIView*)view  duration:(float)secs option:(UIViewAnimationOptions)option;

@end
