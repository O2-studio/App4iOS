//
//  ETUrlCacheManager.h
//  ETShopping
//
//  Created by moxin.xt on 13-1-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

// you can use a custom cache manager, the default one uses the NSCache
@protocol ETUrlCacheManager <NSObject>

@optional
/*
 * save
 */
- (void)cacheData:(id)data forUrlString:(NSString*)identifier;
/*
 * load
 */
- (id)fetchCachedDataForUrlString:(NSString*)identifier;
/*
 * remvoe
 */
- (void)removeCachedDataForKey:(NSString*)identifier;
/**
 * clean memory
 */
- (void)cleanCachedDataInMemory;
/**
 * clean disk
 */
- (void)cleanCachedDataOnDisk;
/**
 * count of cached url response in memory
 */
- (NSInteger)countCachedUrlInMemory;
/**
 * count of cached url response in memory
 */
- (NSInteger)countCachedUrlOnDisk;

@end
