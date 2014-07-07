//
//  ETMemoryCache.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-29.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETMemoryCacheDelegate <NSObject>

- (void)memoryCacheWillEvictObject:(id)obj forKey:(id)key;

@end

@interface ETMemoryCache : NSObject

/**
 cache name
 */
@property(nonatomic,strong) NSString* name;
/**
 cache size
*/
@property(nonatomic,assign) NSInteger limitSize;
/**
 cache objects count
 */
@property(nonatomic,assign) NSInteger limitCount;
/**
 cache objects key array
 */
@property(nonatomic,strong,readonly) NSArray* keyArray;
/**
 cache delegate
 */
@property(nonatomic,weak) id<ETMemoryCacheDelegate> delegate;


- (id)objectForKey:(id)key;
- (void)setObject:(id)obj forKey:(id)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
@end
