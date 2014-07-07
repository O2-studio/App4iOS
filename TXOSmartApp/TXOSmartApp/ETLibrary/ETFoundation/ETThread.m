//
//  ETThread.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETThread.h"

@interface ETThread()
{
    dispatch_queue_t _mainQueue;
    dispatch_queue_t _backgroundQueue;
}


@end

@implementation ETThread

DEF_SINGLETON( ETThread )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_mainQueue = dispatch_get_main_queue();
		_backgroundQueue = dispatch_queue_create( "com.ETLibrary.taskQueue", nil );
	}
	
	return self;
}

- (dispatch_queue_t)mainQueue
{
	return _mainQueue;
}

- (dispatch_queue_t)backgroundQueue
{
	return _backgroundQueue;

}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
	dispatch_release(_mainQueue);
    dispatch_release(_backgroundQueue);
#endif
}

- (void)enqueueOnMainThread:(dispatch_block_t)block
{
	dispatch_async( _mainQueue, block );
}

- (void)enqueueInBackground:(dispatch_block_t)block
{
	dispatch_async( _backgroundQueue, block );
}

- (void)enqueueOnMainThread:(dispatch_block_t)block afterDelay:(NSTimeInterval)s
{
    
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, s * NSEC_PER_SEC);
	dispatch_after( time, _mainQueue, block );
}

- (void)enqueueInBackground:(dispatch_block_t)block afterDelay:(NSTimeInterval)s
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, s * NSEC_PER_SEC);
	dispatch_after( time, _backgroundQueue, block );
}
- (void)concurrentInBackground:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}
- (void)concurrentInBackground:(dispatch_block_t)block afterDelay:(NSTimeInterval)s
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, s * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    
}



@end
