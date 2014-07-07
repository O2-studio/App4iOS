//
//  ETAsyncDrawingCache.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-21.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETAsyncDrawingCache.h"

@interface ETAsyncDrawingCache()<NSCacheDelegate>
{
    NSCache* _memCache;
    dispatch_queue_t _backgroundQueue;
}

@end

@implementation ETAsyncDrawingCache

DEF_SINGLETON(ETAsyncDrawingCache);

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _memCache = [NSCache new];
        _memCache.evictsObjectsWithDiscardedContent = YES;
        _memCache.name = @"ETAsyncDrawingCache.com";
        _memCache.delegate = self;
        
        _backgroundQueue = dispatch_queue_create("com.ETAsyncDrawingCache.www", 0);
    }
    
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_backgroundQueue);
#endif

}

- (void)drawViewAsyncWithCacheKey:(NSString *)cacheKey
                             size:(CGSize)imageSize
                  backgroundColor:(UIColor *)backgroundColor
                        drawBlock:(ETAsyncDrawingBlock)drawBlock
                  completionBlock:(ETAsyncDrawingCompletionBlock)completionBlock
{
    __block NSString* _cacheKey = cacheKey;
    UIImage *cachedImage = [_memCache objectForKey:cacheKey];
    
    if (cachedImage)
    {
        completionBlock(cachedImage,_cacheKey);
        return;
    }
    
 
    drawBlock = [drawBlock copy];
    completionBlock = [completionBlock copy];
    
    dispatch_block_t loadImageBlock = ^{
        BOOL opaque = [self colorIsOpaque:backgroundColor];
        
        UIImage *resultImage = nil;
        
        UIGraphicsBeginImageContextWithOptions(imageSize, opaque, 0);
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGRect rectToDraw = (CGRect){.origin = CGPointZero, .size = imageSize};
            
            BOOL shouldDrawBackgroundColor = ![backgroundColor isEqual:[UIColor clearColor]];
            
            if (shouldDrawBackgroundColor)
            {
                CGContextSaveGState(context);
                {
                    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
                    CGContextFillRect(context, rectToDraw);
                }
                CGContextRestoreGState(context);
            }
            
            drawBlock(rectToDraw);

            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            
            if (resultImage) {
                [_memCache setObject:resultImage forKey:cacheKey];  
            }
        
        }
        UIGraphicsEndImageContext();
        
        //notify
        [[ETThread sharedInstance] enqueueOnMainThread:^{
            completionBlock(resultImage,_cacheKey);
        }];
        
    };
    
   //background drawing
    dispatch_async(_backgroundQueue, loadImageBlock);
    
}

- (void)drawViewAsyncWithCacheKey:(NSString *)cacheKey
                             size:(CGSize)imageSize
                  backgroundColor:(UIColor *)backgroundColor
                       targetView:(UIView *)targetView
                  completionBlock:(ETAsyncDrawingCompletionBlock)completionBlock
{
    __block NSString* _cacheKey = cacheKey;
    UIImage *cachedImage = [_memCache objectForKey:cacheKey];
    
    if (cachedImage)
    {
        completionBlock(cachedImage,_cacheKey);
        return;
    }
    
    completionBlock = [completionBlock copy];
    
    dispatch_block_t loadImageBlock = ^{
        BOOL opaque = [self colorIsOpaque:backgroundColor];
        
        UIImage *resultImage = nil;
        
        UIGraphicsBeginImageContextWithOptions(imageSize, opaque, 0);
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGRect rectToDraw = (CGRect){.origin = CGPointZero, .size = imageSize};
            
            BOOL shouldDrawBackgroundColor = ![backgroundColor isEqual:[UIColor clearColor]];
            
            if (shouldDrawBackgroundColor)
            {
                CGContextSaveGState(context);
                {
                    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
                    CGContextFillRect(context, rectToDraw);
                }
                CGContextRestoreGState(context);
            }
            
            [targetView.layer renderInContext:context];
            
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            
            if (resultImage) {
                [_memCache setObject:resultImage forKey:cacheKey];
            }
            
        }
        UIGraphicsEndImageContext();
        
        //notify
        [[ETThread sharedInstance] enqueueOnMainThread:^{
            completionBlock(resultImage,_cacheKey);
        }];
        
    };
    
    //background drawing
    dispatch_async(_backgroundQueue, loadImageBlock);
    
}
- (BOOL)colorIsOpaque:(UIColor *)color
{
    CGFloat alpha = -1.0f;
    [color getRed:NULL green:NULL blue:NULL alpha:&alpha];
    
    BOOL wrongColorSpace = (alpha == -1.0f);
    if (wrongColorSpace)
    {
        [color getWhite:NULL alpha:&alpha];
    }
    
    return (alpha == 1.0f);
}


@end
