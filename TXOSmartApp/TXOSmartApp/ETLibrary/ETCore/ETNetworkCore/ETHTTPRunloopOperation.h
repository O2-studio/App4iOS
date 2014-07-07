//
//  ETHTTPRunloopOperation.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-28.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////////////
// state machine //

typedef NS_ENUM(NSInteger, ETHttpOperationState)
{
    ETHttpOperationPauseState       = -1,
    ETHttpOperationReadyState       = 1,
    ETHttpOperationExecutingState   = 2,
    ETHttpOperationFinishedState    = 3,
};


@interface ETHTTPRunloopOperation : NSOperation

/**
 recursive lock
 */
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
/**
 default : NSRunLoopCommonModes
 */
@property (nonatomic, strong) NSSet *runLoopModes;
/**
 operation状态机
 */
@property(nonatomic,assign,readonly) ETHttpOperationState operationState;
/**
 runloop thread
 */
@property(nonatomic,strong,readwrite) NSThread* runLoopThread;
/**
 actual runloop thread, in case the current run loop thread has been killed
 */
@property(nonatomic,strong,readonly) NSThread* actualRunLoopThread;
/**
 pause the current operation
 */
- (void)pause;

- (void)resume;

@end


@interface ETHTTPRunloopOperation(SubclassingOverride)

- (void)operationDidStart;
- (void)operationDidFinish;
- (void)operationDidCancel;


@end
