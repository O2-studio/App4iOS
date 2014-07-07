//
//  ETAsyncDrawingCache.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-21.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 for performance issue
 */


typedef void (^ETAsyncDrawingBlock)(CGRect frame);
typedef void (^ETAsyncDrawingCompletionBlock)(UIImage *drawnImage, NSString* cacheKey);

@interface ETAsyncDrawingCache : NSObject

ET_SINGLETON(ETAsyncDrawingCache);


- (void)drawViewAsyncWithCacheKey:(NSString *)cacheKey
                             size:(CGSize)imageSize
                  backgroundColor:(UIColor *)backgroundColor
                        drawBlock:(ETAsyncDrawingBlock)drawBlock
                  completionBlock:(ETAsyncDrawingCompletionBlock)completionBlock;

- (void)drawViewAsyncWithCacheKey:(NSString *)cacheKey
                             size:(CGSize)imageSize
                  backgroundColor:(UIColor *)backgroundColor
                       targetView:(UIView *)targetView
                  completionBlock:(ETAsyncDrawingCompletionBlock)completionBlock;


@end
