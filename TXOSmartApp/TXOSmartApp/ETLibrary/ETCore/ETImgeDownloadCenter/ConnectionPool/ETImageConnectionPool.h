//
//  ETImageConnectionPool.h
//  ETImageDownloaderDemo
//
//  Created by moxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * moxin:@2012-12-14
 * connectionPool内部接AFNetwork的image operation
 * 回调改为block方式
 */


#define ETImageConnectionPool_Default_TimeoutValue  15.0f


@interface ETImageConnectionPool : NSObject

//global read only queue
@property(nonatomic,strong,readonly) NSOperationQueue* operationQueue;

+(ETImageConnectionPool*)currentPool;

- (void)startSingleConnection:(NSURL*)aURL
                     userInfo:(NSString*)key
                     progress:(void (^)(float progress))downloadProgress
                      success:(void (^)(NSString* key, UIImage *image))success
                      failure:(void (^)(NSString* key, NSError *error))failure;

// cancel a single request
- (void)cancelSingleConncetion:(NSURL*)aURL;
// cancel multiple requests
- (void)cancelAllConnections;
// clean black-name list
- (void)cleanBlackUrlList;
//clean pending-name list
- (void)cleanPendingUrlList;







@end
