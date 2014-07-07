//
//  ETHttpDataModel.h
//  etaoLocal
//
//  Created by GuanYuhong on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ETBaseModel.h"
#import "ETHttpRequest.h"
#import "ETUrlCacheManager.h"



typedef enum
{
    ETModelParserFinished       = 0,
    ETModelParserFailed         = -1,
    
} ETModelParserStatus;

@interface ETHttpDataModel : ETBaseModel<ETHttpRequstDelegate>

/**
 * cacheKey
 */
@property(nonatomic,strong) NSString* cacheKey;
/*
 * http url cache policy
 */
@property (nonatomic,assign) ETHttpRequestCachePolicy cachePolicy;
/*
 * http url cache time
 */
@property (nonatomic,assign) ETHttpRequestCacheTime cacheTime;
/*
 * http url cache manager
 */
@property (nonatomic,strong) id<ETUrlCacheManager> cacheManager;
/*
 * http request url
 */
@property (nonatomic,strong) NSString *urlString ;
/*
 * http timeout value
 */
@property (nonatomic,assign)NSTimeInterval timeOutInterval;
/*
 */
/*
 * request string params for http
 */
- (NSString*)urlStringForModelToLoad;
/*
 * response <k,v> from model
 */
- (ETModelParserStatus)responseFromModel:(id)response;


@end
