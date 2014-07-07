//
//  ETHTTPNetworkAgent.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHTTPNetworkAgent : NSObject

ET_SINGLETON( ETHTTPNetworkAgent );

@property (nonatomic, strong,readonly) NSThread* runloopThread;
@property (nonatomic, strong,readonly) NSOperationQueue *operationQueue;

@end
