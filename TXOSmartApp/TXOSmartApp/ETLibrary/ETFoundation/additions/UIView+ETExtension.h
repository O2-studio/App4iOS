//
//  UIView+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef	SAFE_RELEASE_SUBVIEW
#define SAFE_RELEASE_SUBVIEW( __x ) \
{ \
[__x removeFromSuperview]; \
__x = nil; \
}

@interface UIView (ETExtension)

- (void)setMarginTop:(CGFloat)top;
- (void)setMarginBottom:(CGFloat)bottom;
- (void)setMarginLeft:(CGFloat)left;
- (void)setMarginRight:(CGFloat)right;


@end
