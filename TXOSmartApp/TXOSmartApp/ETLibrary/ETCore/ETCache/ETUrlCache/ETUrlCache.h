//
//  ETUrlCache.h
//  ETShopping
//
//  Created by moxin.xt on 13-1-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETUrlCacheManager.h"

@interface ETUrlCache : NSObject

/*
 * set cache manager if you want to change the default one
 */
+ (void)setUrlCacheManager:(id<ETUrlCacheManager>)urlCacheManager;

+ (id<ETUrlCacheManager>)cacheManager;
/*
 * get cached response by url string
 */
+ (id)cachedResponseForUrlString:(NSString*)identifier;
/*
 * save cached response by url string
 */
+ (void)saveResponse:(id)data WithUrlString:(NSString*)identifier ExpireTime:(NSTimeInterval)timeInterval;

@end


// ETUrlCacheManagerDefault class 
@interface ETUrlCacheManagerDefault : NSObject <ETUrlCacheManager>

+ (id)sharedManager;

@end
