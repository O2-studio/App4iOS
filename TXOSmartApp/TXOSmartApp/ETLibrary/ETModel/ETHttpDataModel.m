//
//  ETHttpDataModel.m
//  etaoLocal
//
//  Created by GuanYuhong on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETHttpDataModel.h"
#import "ETSystemUtil.h"
#import "ETAFHttpRequest.h"

@interface ETHttpDataModel ()
{
    //解析数据状态
    ETModelParserStatus _parserStatus;
}

//added by rongjuan in 12.11
@property (nonatomic,strong) ETHttpRequest *etRequest;

@end

@implementation ETHttpDataModel

@synthesize etRequest     = _etRequest;
@synthesize cachePolicy   = _cachePolicy;
@synthesize cacheTime     = _cacheTime;
@synthesize cacheManager  = _cacheManager;


//////////////////////////////////////////////////////////////////////////////
#pragma mark -getter methods

- (ETHttpRequest *)etRequest
{
    if (_etRequest == nil){
        _etRequest = [[ETAFHttpRequest alloc]init];
        _etRequest.delegate = self;
        _etRequest.cacheManager = self.cacheManager;
    }
    return _etRequest;
}

- (void)setTimeOutInterval:(NSTimeInterval)timeOutInterval{
    self.etRequest.timeoutValue = timeOutInterval;
}

- (NSTimeInterval)timeOutInterval{
    return self.etRequest.timeoutValue;
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark -- life cycle


- (id)init
{
    if (self = [super init])
    {
        _cacheKey = [NSString stringWithFormat:@"%@",self.class];
        _cachePolicy = ETHttpRequestCachePolicyNone;
        _cacheTime = ETHttpRequestCacheNone;
        self.timeOutInterval = 10;
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - etbasemodel


- (void)load
{
    [super load];

    _urlString = [self urlStringForModelToLoad];
    
    
    if(_urlString != nil && ![_urlString isEqualToString:@""])
    {
        //notify outside
        [self didStartLoading];
        
        [self load:_urlString cachePolicy:_cachePolicy cacheTime:_cacheTime];
    }
    else
    {
        //notify outside
        [self didFailWithError:[NSError errorWithDomain:kETGlobleErrorDomain code:modelRequestInvalid userInfo:nil]];
       // [self didFailedLoadWithError:[NSError errorWithDomain:kETGlobleErrorDomain code:modelRequestInvalid userInfo:nil]];
    }
}




- (void)cancel
{
    [super cancel];
    [self.etRequest cancel];

}

- (void)reset
{
    [super reset];
    
    self.cacheKey = [NSString stringWithFormat:@"%@",self.class];
    self.timeOutInterval = 10.0f;
    self.cacheManager = nil;
    self.cachePolicy = ETHttpRequestCachePolicyNone;
    self.cacheTime   = ETHttpRequestCacheNone;
    
}



/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - afnetwork's delegate

//added by rongjuan in 12.10


- (void) requestFinished:(ETHttpRequest *)request withResponse:(id)responseObject
{

    /*
     * moxin: parse response on mainThread
     */
    __weak ETHttpDataModel* weakSelf = self;
    [[ETThread sharedInstance] enqueueInBackground:^{
        
        _parserStatus = [weakSelf responseFromModel:responseObject];
        
        [[ETThread sharedInstance] enqueueOnMainThread:^{
            
            if (ETModelParserFinished != _parserStatus)
            {
                NSError* error = nil;
                //可划分为不同的业务错误
                if(self.modelError)
                    error = self.modelError;
                else
                    error = [NSError errorWithDomain:kETGlobleErrorDomain code:modelParseInvalid userInfo:nil];
   
                [weakSelf didFailWithError:error];
                                return;
            }

            //请求成功
            [weakSelf didFinishLoading];
        }];
    
    }];

}

- (void) requestFailed:(ETHttpRequest *)request Error:(NSError *)error
{
    //网络错误
    [self didFailWithError:error];
}




////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

/*
 * request <k,v> params for http
 */
- (NSString*)urlStringForModelToLoad
{
    return @"";
}
/*
 * response <k,v> from model
 */
- (ETModelParserStatus)responseFromModel:(id)response
{
    return ETModelParserFailed;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (void)load:(NSString*) url
{
    [self load:url cachePolicy:_cachePolicy cacheTime:_cacheTime];
}
- (void)load:(NSString*) url cachePolicy:(ETHttpRequestCachePolicy)cachePolicy cacheTime:(ETHttpRequestCacheTime) cacheTime
{
    [self.etRequest load:url cacheTime:cacheTime cachePolicy:cachePolicy];

}


@end
