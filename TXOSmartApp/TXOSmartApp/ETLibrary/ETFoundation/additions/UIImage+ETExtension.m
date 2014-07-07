//
//  UIImage+ETExtension.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "UIImage+ETExtension.h"

@implementation UIImage (ETExtension)

- (UIImage *)alphaImage
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	if ( kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha ||
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha )
	{
		return self;
	}
    
	CGImageRef imageRef = self.CGImage;
	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);
    
	// The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
														  width,
														  height,
														  8,
														  0,
														  CGImageGetColorSpace(imageRef),
														  kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
	// Draw the image into the context and retrieve the new image, which will now have an alpha layer
	CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
	UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
	// Clean up
	CGContextRelease(offscreenContext);
	CGImageRelease(imageRefWithAlpha);
    
	return imageWithAlpha;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextSetShouldAntialias(context, true);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextAddEllipseInRect(context, rect);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)rounded
{
    // If the image does not have an alpha layer, add one
    UIImage * image = [self alphaImage];
	CGSize imageSize = image.size;
	imageSize.width = floorf(imageSize.width);
	imageSize.height = floorf(imageSize.height);
	
	CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
	CGFloat imageHeight = imageWidth;
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
												 imageWidth,
												 imageHeight,
												 CGImageGetBitsPerComponent(image.CGImage),
												 4 * imageWidth,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast);
	
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
	CGRect circleRect;
	circleRect.origin.x = 0; // (imageSize.width - imageWidth) / 2.0f;
	circleRect.origin.y = 0; // (imageSize.height - imageHeight) / 2.0f;
	circleRect.size.width = imageWidth;
	circleRect.size.height = imageHeight;
	//	circleRect = CGRectInset( circleRect, 4.0f, 4.0f );
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = imageWidth;
	drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	
    // Create a UIImage from the CGImage
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
	
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
	// If the image does not have an alpha layer, add one
    UIImage * image = [self alphaImage];
	
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
												 circleRect.size.width,
												 circleRect.size.height,
												 CGImageGetBitsPerComponent(image.CGImage),
												 4 * circleRect.size.width,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast);
	
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = circleRect.size.width;
	drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
	
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
    // Create a UIImage from the CGImage
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (UIImage *)roundedWithBackgroundColor:(UIColor*)bkColor
{
    
    BOOL opaque = [bkColor isEqual:[UIColor clearColor]];
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, opaque, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //
    if (![bkColor isEqual:[UIColor clearColor]]) {
      
        CGContextSaveGState(context);
        {
            CGContextSetFillColorWithColor(context, bkColor.CGColor);
            CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
        }
        CGContextRestoreGState(context);
    }

    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addCircleRectToPath:CGRectMake(0, 0, self.size.width, self.size.height) context:context];
    CGContextClosePath(context);
    CGContextClip(context);
    
    //antialias
    CGContextSetShouldAntialias(context, true);
	CGContextSetAllowsAntialiasing(context, true);
    
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;

}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius backgroundColor:(UIColor*)bkColor
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        CGContextSetFillColorWithColor(context, bkColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    }
    CGContextRestoreGState(context);
    
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;

}

- (UIImage *)stretched
{
	CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, rect, [self CGImage]);
	CGImageRef grayscale = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage * image = [UIImage imageWithCGImage:grayscale];
	CFRelease(grayscale);
	
	return image;	
}

- (UIImage *)imageToFitSize:(CGSize)fitSize method:(ETImageResizingMethod)resizeMethod
{
    if (fitSize.height == 0 || fitSize.width == 0) {
        return nil;
    }
    
	float imageScaleFactor = 1.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	if ([self respondsToSelector:@selector(scale)]) {
		imageScaleFactor = [self scale];
	}
#endif
	
	float sourceWidth = [self size].width * imageScaleFactor;
	float sourceHeight = [self size].height * imageScaleFactor;
	float targetWidth = fitSize.width;
	float targetHeight = fitSize.height;
	BOOL cropping = !(resizeMethod == ETImageResizeScale);
	
	// Calculate aspect ratios
	float sourceRatio = sourceWidth / sourceHeight;
	float targetRatio = targetWidth / targetHeight;
	
	// Determine what side of the source image to use for proportional scaling
	BOOL scaleWidth = (sourceRatio <= targetRatio);
	// Deal with the case of just scaling proportionally to fit, without cropping
	scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
	
	// Proportionally scale source image
	float scalingFactor, scaledWidth, scaledHeight;
	if (scaleWidth) {
		scalingFactor = 1.0 / sourceRatio;
		scaledWidth = targetWidth;
		scaledHeight = round(targetWidth * scalingFactor);
	} else {
		scalingFactor = sourceRatio;
		scaledWidth = round(targetHeight * scalingFactor);
		scaledHeight = targetHeight;
	}
	float scaleFactor = scaledHeight / sourceHeight;
	
	// Calculate compositing rectangles
	CGRect sourceRect, destRect;
	if (cropping) {
		destRect = CGRectMake(0, 0, targetWidth, targetHeight);
		float destX = 0.0f, destY = 0.0f;
		if (resizeMethod == ETImageResizeCrop) {
			// Crop center
			destX = round((scaledWidth - targetWidth) / 2.0);
			destY = round((scaledHeight - targetHeight) / 2.0);
		} else if (resizeMethod == ETImageResizeCropStart) {
			// Crop top or left (prefer top)
			if (scaleWidth) {
				// Crop top
				destX = 0.0;
				destY = 0.0;
			} else {
				// Crop left
				destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
			}
		} else if (resizeMethod == ETImageResizeCropEnd) {
			// Crop bottom or right
			if (scaleWidth) {
				// Crop bottom
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
			} else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
			}
		}
		sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
								targetWidth / scaleFactor, targetHeight / scaleFactor);
	} else {
		sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
		destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
	}
	
	// Create appropriately modified image.
	UIImage *image = nil;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	CGImageRef sourceImg = nil;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.f); // 0.f for scale means "scale for device's main screen".
		sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
		image = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
		
	} else {
		UIGraphicsBeginImageContext(destRect.size);
		sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
		image = [UIImage imageWithCGImage:sourceImg]; // create cropped UIImage.
	}
	
	CGImageRelease(sourceImg);
	[image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
#endif
	
	if (!image) {
		// Try older method.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, scaledWidth, scaledHeight, 8, (scaledWidth * 4),
													 colorSpace, kCGImageAlphaPremultipliedLast);
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect);
		CGContextDrawImage(context, destRect, sourceImg);
		CGImageRelease(sourceImg);
		CGImageRef finalImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		image = [UIImage imageWithCGImage:finalImage];
		CGImageRelease(finalImage);
	}
	
	return image;
}


- (UIImage *)imageCroppedToFitSize:(CGSize)fitSize
{
	return [self imageToFitSize:fitSize method:ETImageResizeCrop];
}


- (UIImage *)imageScaledToFitSize:(CGSize)fitSize
{
	return [self imageToFitSize:fitSize method:ETImageResizeScale];
}

- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;
{
    //calculate rect
    CGRect rect = CGRectZero;
    switch (contentMode)
    {
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect <= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect >= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeCenter:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTop:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottom:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeLeft:
        {
            rect = CGRectMake(0.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeRight:
        {
            rect = CGRectMake(size.width - self.size.width, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopLeft:
        {
            rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopRight:
        {
            rect = CGRectMake(size.width - self.size.width, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomLeft:
        {
            rect = CGRectMake(0.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomRight:
        {
            rect = CGRectMake(size.width - self.size.width, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        default:
        {
            rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            break;
        }
    }
    
    if (!padToFit)
    {
        //remove padding
        if (rect.size.width < size.width)
        {
            size.width = rect.size.width;
            rect.origin.x = 0.0f;
        }
        if (rect.size.height < size.height)
        {
            size.height = rect.size.height;
            rect.origin.y = 0.0f;
        }
    }
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:rect];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (unsigned long long) imageSize
{
    size_t totalBytes = 0;
    
    if(self)
    {
        size_t bpp = CGImageGetBitsPerPixel(self.CGImage);
        size_t bpc = CGImageGetBitsPerComponent(self.CGImage);
        
        if(bpc > 0)
        {
            totalBytes = CGImageGetWidth(self.CGImage) * CGImageGetHeight(self.CGImage) * bpp / bpc;
        }
    }
    
    return totalBytes;
}
@end
