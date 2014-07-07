//
//  ETUrlCache.m
//  ETShopping
//
//  Created by moxin.xt on 13-1-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

@interface ETUrlCacheItem : NSObject<NSCoding>

@property(nonatomic,strong) NSDate*        triggerDate;
@property(nonatomic,assign) NSTimeInterval expireInterval;
@property(nonatomic,strong) NSString*      identifier;
@property(nonatomic,strong) id             response;

@end

@implementation ETUrlCacheItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.triggerDate forKey:@"triggerDate"];
    [aCoder encodeObject:__NUM_DOUBLE(self.expireInterval) forKey:@"expireInterval"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.response forKey:@"response"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.triggerDate    = [aDecoder decodeObjectForKey:@"triggerDate"];
        self.expireInterval = ((NSNumber*)[aDecoder decodeObjectForKey:@"expireInterval"]).doubleValue;
        self.identifier     = [aDecoder decodeObjectForKey:@"identifier"];
        self.response       = [aDecoder decodeObjectForKey:@"response"];
    }
    
    return self;
}

- (NSString*)description
{
    return self.identifier;
}

@end

#import "ETUrlCache.h"

@class ETUrlCacheTimeout;

@interface ETUrlCache()



@end

@implementation ETUrlCache


static id<ETUrlCacheManager> cacheManager = nil;


+ (void)setUrlCacheManager:(id<ETUrlCacheManager>)urlCacheManager
{
    cacheManager = urlCacheManager;
}

+ (id<ETUrlCacheManager>)cacheManager
{
    return cacheManager;
}

// returns the available cache for the service
+ (id)cachedResponseForUrlString:(NSString*)identifier
{
    if (cacheManager == nil) {
        cacheManager = [ETUrlCacheManagerDefault sharedManager];
    }

    ETUrlCacheItem* cacheUrlItem = [cacheManager fetchCachedDataForUrlString:identifier];

    
    if (!cacheUrlItem)
    {
        return nil;
    }
    
    id response = nil;
    
    // check if the timeout
    if(cacheUrlItem)
    {
        //校验时间，如果cache的时间策略为none，则不校验
        
        if (cacheUrlItem.expireInterval == 0) {
            
            ETLog(@"read from cache:%@",identifier);
            
            response =  cacheUrlItem.response;
        }
        else
        {
            //get current date
            NSDate* currdate = [NSDate dateWithTimeIntervalSinceNow:0];
            
            //last date in seconds
            NSTimeInterval last =[cacheUrlItem.triggerDate timeIntervalSince1970]*1;
            
            // now date in seconds
            NSTimeInterval now=[currdate timeIntervalSince1970]*1;
            
            NSTimeInterval cha=now-last;
            
            
            //not timeout
            if(cha < cacheUrlItem.expireInterval)
            {
                ETLog(@"read from cache:%@",identifier);
                
                response =  cacheUrlItem.response;
            }
        }
    }
    
    return response;
    
}

// saves the cache with the identifier
+ (void)saveResponse:(id)data WithUrlString:(NSString*)identifier ExpireTime:(NSTimeInterval)timeInterval
{
    ETLog(@"enter cache:%@",identifier);
    
    
    if (cacheManager == nil) {
        cacheManager = [ETUrlCacheManagerDefault sharedManager];
    }
    
    //save cache item
    ETUrlCacheItem* cacheItem = [[ETUrlCacheItem alloc]init];
    cacheItem.expireInterval = timeInterval;
    cacheItem.identifier     = identifier;
    cacheItem.response       = data;
    cacheItem.triggerDate    = [NSDate date];
    
    //序列化
    [cacheManager cacheData:cacheItem forUrlString:identifier];
}

- (void)dealloc
{
    cacheManager = nil;
}


@end




////////////////////////////////////
// ETUrlCacheManagerDefault class //
////////////////////////////////////

//moxin：
// clear file cache after 3 days
#define kURL_FILE_LIFETIME  259200.0
#define kURL_FILE_MAX_COUNT 200

// generate the key
inline static NSString* keyForURLString(NSString* urlStr)
{
    return [NSString stringWithFormat:@"ETUrlCache-%@", [urlStr sha1]];
}

@interface ETUrlCacheManagerDefault()<ETMemoryCacheDelegate>
{
    NSString* _cachePath;
    NSMutableDictionary* _cachePlist;
    
}
@property(nonatomic,strong) NSMutableArray* keys;
@property(nonatomic,strong) ETMemoryCache* memCache;

@end

@implementation ETUrlCacheManagerDefault

@synthesize memCache = _memCache;

+ (id)sharedManager
{

    static ETUrlCacheManagerDefault* instance = nil;
    
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
        //create memory cache
        _memCache = [ETMemoryCache new];
        _memCache.name = @"ETMemoryCache-UrlCache";
        _memCache.delegate = self;
        
        //create file cache
        _cachePath = [[ETSandBox libCachePath] stringByAppendingPathComponent:@"ETUrlCache"];
        
        // hashmap of the ".plist"
        // key is the url's hash
        // value is the date
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[_cachePath stringByAppendingPathComponent:@"ETUrlCache.plist"]];
		
        //if the plist exist
		if([dict isKindOfClass:[NSDictionary class]])
        {
            _cachePlist = [dict mutableCopy];

            __block NSMutableArray *removeList = [NSMutableArray array];
            
            //clean expired url
            [_cachePlist enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                NSDate* date = [_cachePlist objectForKey:key];
                
                if(abs([date timeIntervalSinceNow]) > kURL_FILE_LIFETIME)
                {
                    [removeList addObject:key];
                    
                    //remove the cache image
                    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:NULL];
                }
                
            }];
            
            //clear the plist
            if ([removeList count] > 0)
            {
                [_cachePlist removeObjectsForKeys:removeList];
                
            }
		}
        
        else
        {
            //create an empty new one
			_cachePlist = [NSMutableDictionary new];
            
            // create a cache directory
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
    }
    
    return self;
}

- (void)dealloc
{
    _memCache = nil;
}

- (void)cacheData:(id)data forUrlString:(NSString*)identifier
{
    NSString* key = keyForURLString(identifier);
    
    //thread safe
    [[ETThread sharedInstance] enqueueInBackground:^{
        
        [_memCache setObject:data
                      forKey:key];
        
         NSData* rawUrlList = [NSKeyedArchiver archivedDataWithRootObject:data];
        [self saveResponse:rawUrlList forKey:key];
        
    }];
}
- (id)fetchCachedDataForUrlString:(NSString*)identifier
{
    if (identifier == nil)
        return nil;
    
    NSString* key = keyForURLString(identifier);
    
    ETUrlCacheItem* response = [_memCache objectForKey:key];
    
    if (!response)
    {
        //check plist
        if ([_cachePlist objectForKey:key])
        {
            NSData* rawData = [self responseForKey:key];
            response = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
        }
 
    }
   
    return response;
}

/*
 * remove
 */
- (void)removeCachedDataForKey:(NSString*)identifier
{
    if (identifier == nil)
        return ;
    
    NSString* key = keyForURLString(identifier);
    
    [[ETThread sharedInstance] enqueueInBackground:^{
        
        if ([_cachePlist objectForKey:key]) {
            
            [self deleteResponseForKey:key];
        }
    }];
}
/**
 * clean memory
 */
- (void)cleanCachedDataInMemory
{
    [[ETThread sharedInstance] enqueueInBackground:^{
       
        [_memCache removeAllObjects];
        
    }];
}
/**
 * clean disk
 */
- (void)cleanCachedDataOnDisk
{
    [[ETThread sharedInstance] enqueueInBackground:^{
        
        for (NSString* key in _cachePlist) {
            
            [self deleteResponseForKey:key];
        }
    }];
}
/**
* count of cached url response in memory
*/
- (NSInteger)countCachedUrlInMemory
{
    return 0;
}
/**
 * count of cached url response in memory
 */
- (NSInteger)countCachedUrlOnDisk
{
    return _cachePlist.count;
}

/**
 * memory cache's delegate
 */
- (void)memoryCacheWillEvictObject:(id)obj forKey:(id)key
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - file method


- (NSString*)cachePathForKey:(NSString*)key
{
    NSString* path = [_cachePath stringByAppendingPathComponent:key];
	return path;
}

//thread safe
- (void)saveResponse:(NSData *)data forKey:(NSString *)key
{
   
    //wirte to file
    NSString *filePath = [ _cachePath stringByAppendingPathComponent:key];

    if ([data writeToFile:filePath atomically:YES]){
        ETLog(@"【cache response succeed】");
    }
    else{
        ETLog(@"【cache response failed】");
    }
    
    //update plist
    [_cachePlist setObject:[NSDate date] forKey:key];
    [_cachePlist writeToFile:[self cachePathForKey:@"ETUrlCache.plist"] atomically:YES];
    
}
- (NSData *)responseForKey:(NSString *)key
{
    NSString *filePath = [ _cachePath stringByAppendingPathComponent:key];

    if (filePath)
    {
        return [NSData dataWithContentsOfFile:filePath];
    }
    else{
        return nil;
    }
}

- (void)deleteResponseForKey:(NSString*)key
{
    [_cachePlist removeObjectForKey:key];
    [_cachePlist writeToFile:[self cachePathForKey:@"ETUrlCache.plist"] atomically:YES];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
}


//////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:__NUM_INT([_cachePlist count])];
    [self.samplePoints keepTail:50];
}

@end
