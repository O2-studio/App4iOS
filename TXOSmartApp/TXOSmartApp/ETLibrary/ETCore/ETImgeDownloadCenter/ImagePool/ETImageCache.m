//
//  ETImageCache.m
//  HTTPImageScrollView
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 moxin :
 
(1) image file cache
 
 */

#import "ETImageCache.h"

static NSString* _ETCacheDirectory;

static inline NSString* ETImageCacheDirectory()
{
	if(!_ETCacheDirectory)
        _ETCacheDirectory = [[[ETSandBox libCachePath] stringByAppendingPathComponent:@"ETImageCache"] copy];
	
	return _ETCacheDirectory;
}

static inline NSString* cachePathForKey(NSString* key) 
{
    NSString* path = [ETImageCacheDirectory() stringByAppendingPathComponent:key];
	return path;
}

// inline function
// generate the key of the image
inline static NSString* keyForURL(NSURL* url)
{
    //return [NSString stringWithFormat:@"ETImageCache-%@", [url.description sha1]];
    NSString* str = url.description;
    return [NSString stringWithFormat:@"%@",[str sha1]];
}


@interface ETImageCache()
{
    // plist
    NSMutableDictionary* _cacheDictionary;
    // a synchronized custom queue
    // uses it as lock
    dispatch_queue_t _lockQueue; 
}

@end

@implementation ETImageCache


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSArray*)cachedUrlList
{
    return [_cacheDictionary allKeys];
}

- (NSInteger)currentDiskSize
{
    int size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:ETImageCacheDirectory()];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [ETImageCacheDirectory() stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


// fast way to ensure the thread safety
+ (ETImageCache*)currentCache
{
    static ETImageCache* instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}


- (id)init 
{
	if((self = [super init])) 
    {
        // hashmap of the ".plist"
        // key is the url's hash
        // value is the date
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(@"ETImageCache.plist")];
		
        //if the plist exist
		if([dict isKindOfClass:[NSDictionary class]]) 
        {
			_cacheDictionary = [dict mutableCopy];
  
            //needs discussion!
            
            NSMutableArray *removeList = [NSMutableArray array];
            
            /*
             * 清理掉过期的图片
             */
            for(NSString* key in _cacheDictionary)
            {
                NSDate* date = [_cacheDictionary objectForKey:key];
                                             
                if(abs([date timeIntervalSinceNow]) > IMAGE_FILE_LIFETIME)
                {
                    [removeList addObject:key];
        
                    //remove the cache image
                    [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(key) error:NULL];
                }
            }
            
            //clear the plist
            if ([removeList count] > 0)
            {
                [_cacheDictionary removeObjectsForKeys:removeList];
            }
        
		}
       
        else 
        {
            //create an empty new one 
			_cacheDictionary = [[NSMutableDictionary alloc] init];
            
            // create a cache directory
            // Cache/ETImageCache
            [[NSFileManager defaultManager] createDirectoryAtPath:ETImageCacheDirectory() 
                                      withIntermediateDirectories:YES 
                                                       attributes:nil 
                                                            error:NULL];
             
            // create a plist file in Cache/ETImageCache/ETImageCache.plist
            // [cacheDictionary writeToFile:cachePathForKey(@"ETImageCache.plist") atomically:YES];
		}
		
        // create a lock
        _lockQueue = dispatch_queue_create("moc.ehcaCegamITE.www", nil);

    }

	return self;
}


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",[self class]);
    _cacheDictionary = nil;
 #if !OS_OBJECT_USE_OBJC
    dispatch_release(_lockQueue);
#endif
    _lockQueue = nil;
    
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method

// use block
- (void)clearCache
{
    dispatch_async(_lockQueue, ^{
        
        for(NSString* key in [_cacheDictionary allKeys])
        {
            NSString* cachePath = cachePathForKey(key);
            
            [self deleteDataAtPath:cachePath];
            [self removeCacheDictionary:key];
        }

    });

}

// remove a single image
- (void)removeCachedImageForKey:(NSURL*)key
{
    NSString* strKey = keyForURL(key);
    [self removeItemFromCache2:strKey];
}

// check to see if the image is in cache
- (BOOL)isImageInCache:(NSURL*)key
{
    NSString* strKey = keyForURL(key);
    return [_cacheDictionary objectForKey:strKey] != nil ? YES : NO;
}


// get image from cache
- (UIImage*)imageForKey:(NSURL*)key
{
    NSString* strKey = keyForURL(key);
    NSData* data = [NSData dataWithContentsOfFile:cachePathForKey(strKey)];
    UIImage* image = [[UIImage alloc]initWithData:data];
    return image;
   // return [UIImage imageWithContentsOfFile:cachePathForKey(strKey)];
}


// get image from cache in async way
- (void)imageForKey:(NSURL *)key complete:(ETImageCacheFindImageCompleteBlock)completBlock;
{
    [[ETThread sharedInstance]enqueueInBackground:^{
        
        if (!key)
            return;
        
        NSString* strKey = keyForURL(key);
        
        NSData* data = [NSData dataWithContentsOfFile:cachePathForKey(strKey)];
        UIImage* image = [[UIImage alloc]initWithData:data];
        //UIImage* image = [UIImage imageWithContentsOfFile:cachePathForKey(strKey)];
        if(image)
        {
            [[ETThread sharedInstance] enqueueOnMainThread:^{
                completBlock(image,YES);
            }];
            
        }
        else
        {
            [[ETThread sharedInstance] enqueueOnMainThread:^{
                completBlock(nil,NO);  
            }];
       
        }
    }];
}


// set image in cache
- (void)setImage:(UIImage*)anImage forKey:(NSURL*)key
{
    dispatch_async(_lockQueue, ^{
        
        NSString* strKey = keyForURL(key);
        NSString* cachePath = cachePathForKey(strKey);
        
        NSData* data = UIImagePNGRepresentation(anImage);
        
        if ([data writeToFile:cachePath atomically:YES])
        {
            [_cacheDictionary setObject:[NSDate date] forKey:strKey];
            [_cacheDictionary writeToFile:cachePathForKey(@"ETImageCache.plist") atomically:YES];
        };
        
    });
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private api

// enable Parallelism in two blocks
// both I/O operation 
- (void)removeItemFromCache2:(NSString *)key
{
    dispatch_async(_lockQueue, ^{
        
        NSString* cachePath = cachePathForKey(key);
        
        [self deleteDataAtPath:cachePath];
        [self removeCacheDictionary:key];
    });
}

//call NSFileManager
//this is thread safe, gcd ensures it's been executed in different threads  
- (void)deleteDataAtPath:(NSString *)path 
{
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}


// these async calls costs time so do these in background
// put these in sync block to ensure thread safety
- (void)removeCacheDictionary : (NSString*)key 
{
    [_cacheDictionary removeObjectForKey:key];
    [_cacheDictionary writeToFile:cachePathForKey(@"ETImageCache.plist") atomically:YES];
}

- (void)addCacheDictionary:(NSString*)key
{
    [_cacheDictionary setObject:[NSDate date] forKey:key];
    [_cacheDictionary writeToFile:cachePathForKey(@"ETImageCache.plist") atomically:YES];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:__NUM_INT([_cacheDictionary count])];
    [self.samplePoints keepTail:50];
}
@end
