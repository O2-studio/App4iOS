//
//  ETImagePool.m
//  HTTPImageScrollView
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//





#import "ETImagePool.h"
#import "ETMemoryCache.h"

@interface ETImagePool()<ETMemoryCacheDelegate>
{
    // use nscache
    ETMemoryCache*  _memCache;
    ETImageCache*   _diskCache;

}

@end


@implementation ETImagePool

- (NSArray*)keysInDisk
{
    return [_diskCache cachedUrlList];
}

- (NSArray*)keysInMemory
{
    return [_memCache keyArray];
}

- (NSInteger)memroySize
{
   // return _memCache
    size_t size = 0;
    for (id key in _memCache.keyArray ) {
        
        UIImage* img = [_memCache objectForKey:key];
        
        int scale = [UIScreen mainScreen].scale;
        
        //rgba
        size_t img_size = img.size.width*scale * img.size.height*scale * 4;
        
        size += img_size;
    }
    
    size = size /= 1024;
    
    return size;
}

- (NSInteger)diskSize
{
    return _diskCache.currentDiskSize;
}

// for thread safety
+ (ETImagePool*)currentImagePool
{
    static ETImagePool* instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        //memory cache
        _memCache = [[ETMemoryCache alloc]init];
        [_memCache  setName : @"ETImagePool_Memory_Cache"];
        [_memCache  setDelegate : self];
        
        //disk cache
        _diskCache = [ETImageCache currentCache];

    }
    
    return self;
}

- (void)dealloc
{
    _memCache = nil;
    _diskCache = nil;

}

// add

/*
 * store image in memroy and file
 */
- (void)setImage:(UIImage *)image ForKey:(NSURL *)key
{
    if (!image) {
        return;
    }
    
    if (!key) {
        return;
    }
    
    //nscache is thread safe
    [_memCache setObject:image forKey:key];
    
    //put it on disk
    [_diskCache setImage:image forKey:key];

}

// thread safe!
- (void)setImageInMemory:(UIImage *)image ForKey:(NSURL *)key
{
    if (!image) {
        return;
    }
    
    if (!key) {
        return;
    }
    
    //nscache is thread safe
    [_memCache setObject:image forKey:key];
}

- (void)setImageInDisk:(UIImage *)image ForKey:(NSURL *)key
{
    if (!image) {
        return;
    }
    
    if (!key) {
        return;
    }
    
    [_diskCache setImage:image forKey:key];
}

/*
 moxin:
 
 this method reads image in sync way
 should not be called directly from UI thread, unless you ensure the image stores in memeory
 
 */
- (UIImage *)getImageForKey:(NSURL *)key
{
    if(key  == nil)
        return nil;
    
    UIImage* image = nil;

    image = [_memCache objectForKey:key];

    if (image == nil && [self imageExistsInDisk:key])
    {
        image = [_diskCache imageForKey:key];
        
    }
    else if(image == nil && ![self imageExistsInDisk:key])
    {
       // [ETLog printLog:[self class] Text:@"【sync read】: miss memory cache and file cache!"];
    }
    
    else if(image!=nil)
    {
        //[ETLog printLog:[self class] Text:@"【sync read】: hit memory cache"];
    }
    
    return image;
}
/*
 * a quick & sync way to get image in memory
 */
- (UIImage*)getImageFromMemoryForKey:(NSURL*)key
{
    if(key  == nil)
        return nil;
    
    UIImage* image = [_memCache objectForKey:key];
    
    //log
    if (image) {
         // ETLog(@"【read image from memory succeed!】 ---> %@",key);
    }
    else
    {
    }
        //ETLog(@"【read image from memory failed!】 ---> %@",key);
    
    return image;
}
- (UIImage*)getImageFromDiskForKey:(NSURL*)key
{
    if (key == nil) {
        return nil;
    }
    
    UIImage* image = [_diskCache imageForKey:key];
    
    //log
    if (image) {
        //ETLog(@"【read image from file succeed!】 ---> %@",key);
    }
    else
    {}
        //ETLog(@"【read image from file failed!】 ---> %@",key);

    return image;
}

/*
 * a less-quick & async way to get image using block
 */
- (void)getImageForKey:(NSURL*)key success:(imagePoolDidFindImageBlock) successBlock failure:(imagePoolDidNotFindImageBlock) failureBlock;
{
    if(key == nil)
    {
        if(failureBlock)
        {
            [[ETThread sharedInstance]enqueueOnMainThread:^{
                    failureBlock(key);
            }];
        
        }
      
        return;
    }
    
    if([self imageExistsInMemory:key])
    {
        __block UIImage* image = [_memCache objectForKey:key];
        
        // if image exist in memory
        if(image != nil)
        {
            //return immediately
            if(successBlock)
            {
                [[ETThread sharedInstance] enqueueOnMainThread:^{
                    successBlock(image,key);
                }];
              
            }
        }
    }
    else 
    {
        // check file cache
        if([self imageExistsInDisk:key])
        {
            [_diskCache imageForKey:key complete:^(UIImage *image, BOOL cached)
             {
                 //miss cache
                 if(!cached)
                 {
                     if(failureBlock)
                     {
                         [[ETThread sharedInstance]enqueueOnMainThread:^{
                             failureBlock(key);
                         }];
                     }
                 }
                 else
                 {
                     if(successBlock)
                     {
                         ETLog(@"【read image from file】");
                         [[ETThread sharedInstance]enqueueOnMainThread:^{
                            successBlock(image,key);
                         }];
                     }
                 }
             }];
            
        }
        
        else
        {
            [[ETThread sharedInstance]enqueueOnMainThread:^{
                failureBlock(key);
            }];
        }
    }
}

// query
- (BOOL)hasImageWithKey:(NSURL *)key
{
    BOOL exists = [self imageExistsInMemory:key];
    if (!exists)
    {
        exists = [self imageExistsInDisk:key];
    }
    return exists;
}
- (NSUInteger)countImagesInMemory
{
    return _memCache.keyArray.count;
}

- (NSUInteger)countImagesInDisk
{
    return _diskCache.cachedUrlList.count;
}
/*
 * returns the size of image stored in file manager
 */
- (NSInteger)sizeOfImagesInDisk
{
    return [[ETImageCache currentCache]getDiskImageSize];
}
/*
 * returns the size of image stored in memory
 */
- (NSInteger)sizeOfImagesInMemory
{
    return 0;
}

- (BOOL)imageExistsInMemory:(NSURL *)key
{
    
    return ([_memCache objectForKey:key] != nil);
}

- (BOOL)imageExistsInDisk:(NSURL *)key
{
    return [_diskCache isImageInCache:key];
}

/*
 * remove a single image in memory
 */
- (void)removeImageInMemoryWithKey:(NSURL *)key
{
    if ([self imageExistsInMemory:key])
    {
        //remove image ins nscache
        [_memCache removeObjectForKey:key];
    }
}
/*
 * remove a single iamge in disk
 */
- (void)removeImageInDiskWithKey:(NSURL* )key
{
    if([self imageExistsInDisk:key])
    {
        [_diskCache removeCachedImageForKey:key];
    }
}

- (void)removeAllImagesInDisk
{
    [_diskCache clearCache];
}

- (void)removeAllImagesInMemory
{
    [_memCache removeAllObjects];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:__NUM_INT(self.memroySize)];
    [self.samplePoints keepTail:50];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NScache

- (void)memoryCacheWillEvictObject:(id)obj forKey:(id)key
{
    if([obj isKindOfClass:[UIImage class]])
        NSLog(@"[ImagePool]-->evictObject:%@",key);

}



@end
