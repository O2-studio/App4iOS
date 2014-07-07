//
//  ETImageDownLoadCenter.m
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ETImageDownloadCenterHeader.h"


@interface ETImageDownLoadCenter()
{
    ETImagePool* _imgPool;
    ETImageConnectionPool* _connectionPool;
}



@end


@implementation ETImageDownLoadCenter

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class method

// inline function 
inline static NSNumber* generateTimeStamp()
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStamp = [NSNumber numberWithDouble: timeInterval];
    
    return timeStamp;
}

// get unique key
+ (NSString*) getMyUniqueKey:(NSURL*) url
{
    if(!url)
        return @"";
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString* strTimeInterval = [NSString stringWithFormat:@"%f",timeInterval];
    
    return strTimeInterval;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

+(id)defaultCenter
{
    static ETImageDownLoadCenter* instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public interface

/*
 * 异步下载请求
 */
- (void)load:(NSURL *)requestUrl
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress
{
    [self load:requestUrl
   cachePolicy:ETImageDownloadWithoutCachingImage
       Success:success
       Failure:failure
      Progress:progress];
}

/*
 * 异步下载请求,指定图片cache策略
 */
- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress
{
    [self load:requestUrl
   cachePolicy:policy
   extraBundle:nil
       Success:success
       Failure:failure
      Progress:progress];
}

/*
 * 异步下载请求，指定图片cache策略，携带userinfo
 */
- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
 extraBundle:(NSString*)key
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress;
{
    [self load:requestUrl
   cachePolicy:policy
   extraBundle:key
       Success:success
       Failure:failure
      Progress:progress
  ProcessImage:nil];
}

- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
 extraBundle:(NSString*)key
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress
ProcessImage:(ETImageProcessingBlock)processImage
{
    if (!requestUrl)
    {
        failure(nil,nil,nil,key);
        return;
    }
    
    //0, do some protection
    if ([requestUrl isKindOfClass:NSString.class])
    {
        requestUrl = [NSURL URLWithString:(NSString *)requestUrl];
    }
    
    //1, get processed url
    //requestUrl = [ETImageUrlPreprocessTool getProcessedUrl:requestUrl];
    
    //keep these local variable on heap
    __block NSURL* blockURL = requestUrl;
    __block ETImageDownloadCachePolicy blockCachePolicy = policy;
    __block NSString* blockKey = key;
    
    //2,check memory
    if ([[ETImagePool currentImagePool] imageExistsInMemory:blockURL]) {
        
        if (success) {
            
            [[ETThread sharedInstance] enqueueOnMainThread:^{
               
                success([[ETImagePool currentImagePool] getImageFromMemoryForKey:blockURL],blockURL,blockKey);
            }];
        }
    }
    
    //3, check disk
    else if([[ETImagePool currentImagePool] imageExistsInDisk:requestUrl])
    {
        [[ETThread sharedInstance]enqueueInBackground:^{
            
            UIImage* image = [[ETImagePool currentImagePool] getImageFromDiskForKey:blockURL];
            
            if (image) {
                
                if(success)
                {
                    [[ETThread sharedInstance] enqueueOnMainThread:^{
                        
                        success(image,blockURL,key);
                        //success([NSDictionary dictionaryWithObjectsAndKeys:image,@"image",blockURL,@"imageURL",blockDict,@"bundle",nil]);
                    }];
                    
                }
            }
            else
            {
                [[ETThread sharedInstance] enqueueInBackground:^{
                   
                    failure(image,blockURL,nil,key);
                }];
            }
        }];
        
    }
    //3, start downloading
    else
    {
        [[ETImageConnectionPool currentPool] startSingleConnection:requestUrl
                                                          userInfo:blockKey
                                                          progress:^(float _progress) {
                                                              
                                                              if(progress)
                                                              {
                                                                  [[ETThread sharedInstance]enqueueOnMainThread:^{
                                                                      progress([NSNumber numberWithDouble:_progress],blockURL,blockKey);
                                                                  }];
                                                                 
                                                              }
                                                              
                                                          }
         success:^(NSString *key, UIImage *image)
         {
             if(success)
             {
                 //process image
                 if (processImage)
                 {
                     [[ETThread sharedInstance] enqueueInBackground:^{
                         
                         UIImage* processedImage =  processImage(image);
                         
                         //dispatch on main thread
                         [[ETThread sharedInstance]enqueueOnMainThread:^{
                             
                             success(processedImage,blockURL,blockKey);
                             //success([NSDictionary dictionaryWithObjectsAndKeys:processedImage,@"image",blockURL,@"imageURL",blockDict,@"bundle",nil]);
                         }];
                         
                         //save caches
                         switch (blockCachePolicy)
                         {
                             case ETImageDownloadCacheInMemroy:
                             {
                                 [[ETImagePool currentImagePool]setImageInMemory:processedImage ForKey:blockURL];
                                 break;
                             }
                             case ETImageDownloadCacheInFile:
                             {
                                 //[[ETImagePool currentImagePool] setImage:processedImage ForKey:blockURL];
                                 [[ETImagePool currentImagePool] setImageInDisk:processedImage ForKey:blockURL];
                                 break;
                             }
                             default:
                                 break;
                         }

                     }];
                 }
                 else
                 {
                     //dispatch on main thread
                     [[ETThread sharedInstance]enqueueOnMainThread:^{
                         
                         success(image,blockURL,blockKey);
                         //success([NSDictionary dictionaryWithObjectsAndKeys:image,@"image",blockURL,@"imageURL",blockDict,@"bundle",nil]);
                     }];
                     
                     //save caches
                     switch (blockCachePolicy)
                     {
                         case ETImageDownloadCacheInMemroy:
                         {
                             [[ETImagePool currentImagePool]setImageInMemory:image ForKey:blockURL];
                             break;
                         }
                         case ETImageDownloadCacheInFile:
                         {
                             [[ETImagePool currentImagePool] setImage:image ForKey:blockURL];
                             //[[ETImagePool currentImagePool] setImageInDisk:image ForKey:blockURL];
                             break;
                         }
                         default:
                             break;
                     }
                 }
                 
             
             }
             
         }
         failure:^(NSString *key, NSError *error)
         {
             if(failure)
             {
                 [[ETThread sharedInstance] enqueueOnMainThread:^{
                     
                     failure(nil,blockURL,error,blockKey);
                 }];
             }
         }];
        
    }
}




// load a cached single image in a sync way
- (UIImage*)loadSynchronously: (NSURL*)requestURL
{
    if(!requestURL)
        return nil;
    if(![requestURL isKindOfClass:[NSURL class]])
        return nil;
    
    return [[ETImagePool currentImagePool] getImageForKey:requestURL];
}

/*
 * 同步下载请求，从imagePool的memcache中拿图片
 */
- (UIImage*)loadSynchronouslyFromMemory:(NSURL *)requestURL
{
    if(!requestURL)
        return nil;
    if(![requestURL isKindOfClass:[NSURL class]])
        return nil;
    
    
    
    return [[ETImagePool currentImagePool] getImageFromMemoryForKey:requestURL];
    
}


// cancel single loading image
- (void)cancelLoadingSingleImage:(NSURL*)aURL
{
    if(!aURL)
        return;
    
    [[ETImageConnectionPool currentPool] cancelSingleConncetion:aURL];
}

// cancel all loading images
- (void)cancelAllLoadingImages
{
    [[ETImageConnectionPool currentPool] cancelAllConnections];
}


@end






