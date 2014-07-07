//
//  HttpRequest.h
//  testASIhttp
//
//  Created by GuanYuhong on 11-11-21.
//  Modified by rongjuan on 12-12-26
//  Modified by moxin.xt on 13-01-20
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETHttpRequest;
@protocol ETUrlCacheManager;

@protocol ETHttpRequstDelegate <NSObject>

@optional
- (void) requestFinished:(ETHttpRequest *)request withResponse:(id)responseObject;
- (void) requestFailed:(ETHttpRequest *)request Error:(NSError*)error;
- (void) requestProgress:(NSNumber *)progress ;

@end

typedef void (^UpLoadPrepareBlock)(NSOperation *operation);
typedef void (^UploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);


typedef enum {
    ETHttpRequestCacheNone = 0,
    ETHttpRequestCache15secs = 15,
    ETHttpRequestCache30Secs = 30,
    ETHttpRequestCacheOneMinite = 60,
    ETHttpRequestCacheFiveMinite = 60*5,
    ETHttpRequestCacheOneHour = 60 * 60,
    ETHttpRequestCacheOneDay = 60*60*24,
    ETHttpRequestCacheOneWeek = 60*60*24*7
} ETHttpRequestCacheTime;


/**
 单次http
*/
typedef enum
{
    //无缓存
    ETHttpRequestCachePolicyNone = 0,
    
    //请求前检测缓存，请求后缓存内容
    ETHttpRequestCachePolicyDefault = 1,
    
    //请求前检测缓存，请求后不缓存
    ETHttpRequestCachePolicyLoadUsingCacheFinishWithoutCaching = 2,
    
    //请求前不检测缓存，请求后缓存内容
    ETHttpRequestCachePolicyLoadWithoutCachingFinishSavingCache = 3

}ETHttpRequestCachePolicy;

@interface ETHttpRequest : NSObject

/*
 * request url string
 */
@property (nonatomic,strong) NSString* urlString;
/*
 * request response string
 */
@property(nonatomic,strong) NSString* urlResponseString;
/*
 * request response data
 */
@property(nonatomic,strong) NSData* urlResponseData;
/*
 * request response object
 */
@property(nonatomic,strong) id response;
/*
 * request delegate
 */
@property (nonatomic,weak)id <ETHttpRequstDelegate> delegate;
/*
 * request cached time
 */
@property (nonatomic,assign) ETHttpRequestCacheTime cacheTime;
/*
 * request cached policy
 */
@property (nonatomic,assign) ETHttpRequestCachePolicy cachePolicy;
/*
 * request cached manager
 */
@property (nonatomic,strong) id<ETUrlCacheManager> cacheManager;
/*
 * request timeour value
 */
@property (nonatomic,assign) NSTimeInterval timeoutValue;
/**
 * request error
 */
@property(nonatomic,strong,readonly) NSError* requestError;

/*
 * download
 */
- (void) load:(NSString *)url
    cacheTime:(ETHttpRequestCacheTime)cacheTime
  cachePolicy:(ETHttpRequestCachePolicy) cachePolicy;
/*
 * cancel
 */
- (void) cancel;

/*
 * upload
 */
- (void)upLoadWithUrlString:(NSString *)urlString withParams:(NSMutableDictionary *)params withPrepare:(UpLoadPrepareBlock)prepareBlock withProgress:(UploadProgressBlock)progressBlock;
/*
 *request fininish
 */
- (void)requestSuccessWithResponse:(id)responseObject;
/**
 * request failed
 */
- (void)requestFailedWithError:(NSError *)error;

@end
