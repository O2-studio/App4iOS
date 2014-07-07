//
//  ETHttpRequest.m
//  testASIhttp
//
//  Created by GuanYuhong on 11-11-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ETHttpRequest.h"
#import "ETUrlCache.h"


@interface ETHttpRequest ()




@end

@implementation ETHttpRequest

@synthesize delegate = _delegate;
@synthesize urlString = _urlString;
@synthesize cachePolicy = _cachePolicy;
@synthesize cacheTime = _cacheTime;
@synthesize timeoutValue = _timeoutValue;
@synthesize cacheManager = _cacheManager;



///////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setCacheManager:(id<ETUrlCacheManager>)cacheManager
{
    _cacheManager = cacheManager;
    
    [ETUrlCache setUrlCacheManager:cacheManager];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.cacheTime    = ETHttpRequestCacheNone;                        //初始状态，缓存时间为0
        self.cachePolicy  = ETHttpRequestCachePolicyNone;                //初始状态，缓存策略为无缓存
        self.cacheManager = [ETUrlCacheManagerDefault sharedManager];
     
		return self;  
    }
	return nil;
}


- (void)dealloc
{  
    NSLog(@"[%@]-->dealloc:%@",self.class,self.urlString);
    [self cancel];
    
    _cacheManager = nil;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

//modified by rongjuan in 12.12
//through getter and setter methods so that it's no problem with inherit.
- (void) load:(NSString *)url cacheTime:(ETHttpRequestCacheTime)cacheTime cachePolicy:(ETHttpRequestCachePolicy)cachePolicy
{
    self.cachePolicy = cachePolicy;
    self.cacheTime = cacheTime;
    self.urlString = url;
    
    //if ([ETSystemUtil getNetworkEnabled])
    if (YES)
    {
        // first check cache
        if(cachePolicy == ETHttpRequestCachePolicyDefault ||
           cachePolicy == ETHttpRequestCachePolicyLoadUsingCacheFinishWithoutCaching)
        {
            id response = [ETUrlCache cachedResponseForUrlString:url];
            
            if(response)
            {
                self.response = response;
                [self notifyOutSide:YES];
            }
            else
                [self load:url];
        }
        else
        {
            [self load:url];
        }
    }
    else
    {
        self.response = nil;
        //-1005: connection lost
        [self requestFailedWithError:[NSError errorWithDomain:@"NSURLErrorDomain" code:-1005 userInfo:nil]];
    }
    
   
}

- (void)cancel
{
    
}

- (void)upLoadWithUrlString:(NSString *)urlString withParams:(NSMutableDictionary *)params withPrepare:(UpLoadPrepareBlock)prepareBlock withProgress:(UploadProgressBlock)progressBlock
{

}

- (void)requestSuccessWithResponse:(id)responseObject
{
    //get response object
    self.response = responseObject;
    
    //save cache if possible
    if(self.cachePolicy == ETHttpRequestCachePolicyDefault ||
       self.cachePolicy == ETHttpRequestCachePolicyLoadWithoutCachingFinishSavingCache)
    {
        [ETUrlCache saveResponse:responseObject WithUrlString:self.urlString ExpireTime:self.cacheTime];
    }


    //notify delegate
    [self notifyOutSide:YES];

}
- (void)requestFailedWithError:(NSError *)error{
    
    _requestError = error;
    
    // if has cache
    id response = [ETUrlCache cachedResponseForUrlString:self.urlString];
    
    if (response)
    {
        self.response = response;
        [self notifyOutSide:YES];
    }
    else
    {
        [self notifyOutSide:NO];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - private methods

- (void) load:(NSString*)url
{
    
    
}



- (void)notifyOutSide:(BOOL)result
{
    if (result)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFinished:withResponse:)]){
            [self.delegate performSelector:@selector(requestFinished:withResponse:) withObject:self withObject:self.response];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:Error:)]) {
            [self.delegate requestFailed:self Error:_requestError];
        }
    }

    
}


@end
