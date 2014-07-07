//
//  ETThread.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETSingleton.h"

@interface ETThread : NSObject

ET_SINGLETON(ETThread);

- (dispatch_queue_t)mainQueue;
- (dispatch_queue_t)backgroundQueue;

/**
 FIFO:dispatch_on_main_thread
 */
- (void)enqueueOnMainThread:(dispatch_block_t)block;
- (void)enqueueOnMainThread:(dispatch_block_t)block afterDelay:(NSTimeInterval)s;

/**
 FIFO:dispatch_on_self_defined_queue
 */
- (void)enqueueInBackground:(dispatch_block_t)block;
- (void)enqueueInBackground:(dispatch_block_t)block afterDelay:(NSTimeInterval)s;

/**
 Concurrent:dispatch_on_system_global_queue
 */
- (void)concurrentInBackground:(dispatch_block_t)block;
- (void)concurrentInBackground:(dispatch_block_t)block afterDelay:(NSTimeInterval)s;


@end
