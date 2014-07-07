//
//  ETImageDownLoadCenter.h
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




typedef UIImage *(^ETImageProcessingBlock)(UIImage *rawImage);
typedef void(^imageDownloadCenterDidLoadBlock)(UIImage* image, NSURL* url,NSString* key) ;
typedef void(^imageDownloadCenterDidFailBlock)(UIImage* image, NSURL* url, NSError* error,NSString* key);
typedef void(^imageDownloadCenterReportProgressBlock)(NSNumber* progress, NSURL* url, NSString* key) ;


enum
{
    //without caching image
    ETImageDownloadWithoutCachingImage      = 0,
    //cache image in memory
    ETImageDownloadCacheInMemroy            = 1,
    //cache image in file
    ETImageDownloadCacheInFile              = 2,
     
};
typedef NSUInteger ETImageDownloadCachePolicy;



@interface ETImageDownLoadCenter : NSObject


+ (id)defaultCenter;
/*
 * 异步下载请求
 */
- (void)load:(NSURL *)requestUrl
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress;
/*
 * 异步下载请求,指定图片cache策略
 */
- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress;
/*
 * 异步下载请求，指定图片cache策略，携带userinfo
 */
- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
 extraBundle:(NSString*)key
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress;


- (void)load:(NSURL *)requestUrl
 cachePolicy:(ETImageDownloadCachePolicy)policy
 extraBundle:(NSString*)key
     Success:(imageDownloadCenterDidLoadBlock)success
     Failure:(imageDownloadCenterDidFailBlock)failure
    Progress:(imageDownloadCenterReportProgressBlock)progress
ProcessImage:(ETImageProcessingBlock)processImage;
/*
 * 同步下载请求，从imagePool中拿图片
 */
- (UIImage*)loadSynchronously: (NSURL*)requestURL;
/*
 * 同步下载请求，从imagePool的memcache中拿图片
 */
- (UIImage*)loadSynchronouslyFromMemory:(NSURL *)requestURL;
/*
 * 取消下载中的operation
 */
- (void)cancelLoadingSingleImage:(NSURL*)aURL;
/*
 * 取消所有下载中的图片
 */
- (void)cancelAllLoadingImages;


@end
