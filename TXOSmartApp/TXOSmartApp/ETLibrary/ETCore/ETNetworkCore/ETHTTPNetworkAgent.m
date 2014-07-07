//
//  ETHTTPNetworkAgent.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETHTTPNetworkAgent.h"

//////////////////////////////////////////////////////////////////////////////////////////
// global constants
NSString* const kETHTTPNetworkAgentThreadRunLoopName = @"ETHttpNetworkAgentRunloopThread";
NSString* const kETHTTPNetworkAgentOperationQueueName= @"ETHttpNetworkAgentOperationQueue";
float const kETHTTPNetworkAgentThreadRunLoopPriority = 0.3;

@interface ETHTTPNetworkAgent()
{
}

@end


@implementation ETHTTPNetworkAgent

DEF_SINGLETON(ETHTTPNetworkAgent);

- (id)init
{
    self = [super init];
    
    if (self) {
        
        //create a runloop thread for each operation
        _runloopThread = [[NSThread alloc]initWithTarget:self selector:@selector(networkRunloopThreadEntry) object:nil];
        assert(_runloopThread);
        _runloopThread.name = kETHTTPNetworkAgentThreadRunLoopName;
        _runloopThread.threadPriority = kETHTTPNetworkAgentThreadRunLoopPriority;
        [_runloopThread start];
        
        _operationQueue = [NSOperationQueue new];
        _operationQueue.name = kETHTTPNetworkAgentOperationQueueName;
        
        
    }
    return  self;
}

- (void)networkRunloopThreadEntry
{
    @autoreleasepool {
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
 
    }
}





@end
