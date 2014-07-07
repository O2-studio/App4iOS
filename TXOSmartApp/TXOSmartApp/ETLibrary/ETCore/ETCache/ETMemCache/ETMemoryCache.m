//
//  ETMemoryCache.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-29.
//  Copyright (c) 2013年 etao. All rights reserved.
//


#include <objc/runtime.h>
#include <malloc/malloc.h>
#import "ETMemoryCache.h"



@interface NSObject(key)

@property(nonatomic,strong) id key;

@end

@implementation NSObject(key)

@dynamic key;

- (void)setKey:(id)key
{
    objc_setAssociatedObject(self, "key", key, OBJC_ASSOCIATION_RETAIN);
}

- (id)key
{
    return objc_getAssociatedObject(self, "key");
}

@end


static const size_t defaultMemoryCacheSize  = 10 * 1024 * 1024;
static const size_t defaultMemoryCacheCount = 100;

@interface ETMemoryCache()<NSCacheDelegate>
{
    //mutable keyset
    NSMutableSet* _keySet;
    
    //internal memory cache
    NSCache* _memCache;
    
    // an async write-only-lock
    dispatch_queue_t _lockQueue;
}

@end

@implementation ETMemoryCache


- (void)setName:(NSString *)name
{
    _name = name;
    _memCache.name = name;
}

- (void)setLimitCount:(NSInteger)limitCount
{
    _limitCount = limitCount;
    _memCache.countLimit = limitCount;
}

- (void)setLimitSize:(NSInteger)limitSize
{
    _limitSize = limitSize;
    _memCache.totalCostLimit = limitSize;
}


- (NSArray*)keyArray
{
    return [_keySet allObjects];
}

- (size_t) memoryAvailable
{
    size_t t = _limitSize - [self memoryUsed];
    return t;
}

- (size_t)memoryUsed
{
    __block size_t t = 0;
    
    dispatch_sync(_lockQueue, ^{
       
        for (id key in _keySet) {
            
            id obj = [_memCache objectForKey:key];
            t += malloc_size((__bridge const void *)(obj));
        }
    });
    return t;


}
- (id)init
{
    self = [super init];
    
    if(self)
    {

        //nscache
        _memCache = [[NSCache alloc]init];
        [_memCache  setDelegate : self];
        [_memCache  setEvictsObjectsWithDiscardedContent:YES];
        
        //100
        _limitCount = defaultMemoryCacheCount;
        [_memCache  setCountLimit:defaultMemoryCacheCount];
        
        //10mb
        _limitSize = defaultMemoryCacheSize;
        [_memCache  setTotalCostLimit:defaultMemoryCacheSize];
        
        // lru cache list
        _keySet = [NSMutableSet new];

        // create a lock
        _lockQueue = dispatch_queue_create("moc.ehcaCYROMEMTE.www", 0);

        
        //memory warning observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

    }
    
    return self;
}


- (void)dealloc
{
    _memCache = nil;
    _memCache.delegate = nil;
    [_keySet removeAllObjects];
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_lockQueue);
#endif
}


//////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods


- (id)objectForKey:(id)key
{
    if (!key) {
        return nil;
    }
    else
        return [_memCache objectForKey:key];

    
 
}
- (void)setObject:(id)obj forKey:(id)key
{
    //nscache itself is thread-safe, don't need to put this in block
    [_memCache setObject:obj forKey:key];

    if ([obj isKindOfClass:[NSObject class]]) {
        NSObject* cacheObj =(NSObject*) obj;
        cacheObj.key = key;
    }
    
    if( obj != nil && key != nil)
    {
        // need a lock
        dispatch_async(_lockQueue,
                       ^{
                           [_keySet addObject:key];}
                       );
    }
}
- (void)removeObjectForKey:(id)key
{
    [_memCache removeObjectForKey:key];

    dispatch_async(_lockQueue,
                   ^{[_keySet removeObject:key];});
    
 

}
- (void)removeAllObjects
{
    [_memCache removeAllObjects];
    [_keySet removeAllObjects];
}


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - memory warning

- (void)onReceiveMemoryWarning:(id)sender
{
    //[_memCache removeAllObjects];
    [self removeAllObjects];
}


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - nscache delegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    if ([obj isKindOfClass:[NSObject class]]) {
        id key = ((NSObject*)obj).key;
        
        if ([self.delegate respondsToSelector:@selector(memoryCacheWillEvictObject:forKey:)])
        {
            [self.delegate memoryCacheWillEvictObject:obj forKey:key];
        }
        //sync with keyArray
        dispatch_async(_lockQueue, ^{
            
            [_keySet removeObject:key];
        });
    }
}

@end
