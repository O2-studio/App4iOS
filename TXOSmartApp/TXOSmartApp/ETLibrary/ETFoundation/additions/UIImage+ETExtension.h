//
//  UIImage+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef	__IMAGE
#define __IMAGE( __name )	[UIImage imageNamed:__name]

typedef enum {
    ETImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    ETImageResizeCropStart,
    ETImageResizeCropEnd,
    ETImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} ETImageResizingMethod;

@interface UIImage (ETExtension)



- (UIImage *)imageToFitSize:(CGSize)size method:(ETImageResizingMethod)resizeMethod;
- (UIImage *)imageCroppedToFitSize:(CGSize)size; // uses MGImageResizeCrop
- (UIImage *)imageScaledToFitSize:(CGSize)size; // uses MGImageResizeScale
- (UIImage *)rounded;
- (UIImage *)rounded:(CGRect)rect;
- (UIImage *)roundedWithBackgroundColor:(UIColor*)bkColor;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius backgroundColor:(UIColor*)bkColor;
- (UIImage *)stretched;
- (UIImage *)grayscale;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;
- (unsigned long long) imageSize;


@end
