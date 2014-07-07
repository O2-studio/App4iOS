//
//  ETHTTPRunloopOperation.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-28.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETHTTPRunloopOperation.h"




static  NSString* const kETHttpOperationLockName      = @"com.ethttpOperation.lock.www";
NSString * const kETHttpNetworkErrorDomain            = @"ETHttpNetworkingErrorDomain";
NSString * const kETHttpNetworkRequestFailedErrorKey  = @"ETHttpNetworkRequestFailedErrorKey";
NSString * const kETHttpNetworkResponseFailedErrorKey = @"ETHttpNetworkResponseFailedErrorKey";

//////////////////////////////////////////////////////////////////////////////////////////
// global static method
// the state machine is borrowed from afnetworking
// http://afnetworking.com/
//////////////////////////////////////////////////////////////////////////////////////////
static inline NSString * keyForOperationState(ETHttpOperationState state) {
    switch (state) {
        case ETHttpOperationReadyState:
            return @"isReady";
        case ETHttpOperationExecutingState:
            return @"isExecuting";
        case ETHttpOperationFinishedState:
            return @"isFinished";
        case ETHttpOperationPauseState:
            return @"isPaused";
        default:
            return @"state";
    }
}

static inline BOOL isOperationStateTransationValid(ETHttpOperationState fromState, ETHttpOperationState toState, BOOL isCancelled) {
    
    NSString* f = keyForOperationState(fromState);
    NSString* t = keyForOperationState(toState);
    
    switch (fromState) {
           
        case ETHttpOperationReadyState:
            switch (toState) {
                case ETHttpOperationPauseState:
                case ETHttpOperationExecutingState:
                {
                    NSLog(@"[ETHTTPRunloopOperation]-->[valid state trans: %@-->%@]",f,t);
                    return YES;
                }
                case ETHttpOperationFinishedState:
                    return isCancelled;
                default:
                {
                    NSLog(@"[ETHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        case ETHttpOperationExecutingState:
            switch (toState) {
                case ETHttpOperationPauseState:
                case ETHttpOperationFinishedState:
                {
                     NSLog(@"[ETHTTPRunloopOperation]-->[valid state trans: %@-->%@]",f,t);
                    return YES;
                }
                default:
                {
                    NSLog(@"[ETHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        case ETHttpOperationFinishedState:
        {
             NSLog(@"[ETHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
            return NO;
        }
        case ETHttpOperationPauseState:
        {
            
            return toState == ETHttpOperationReadyState;
        }
        default:
            return YES;
    }
}


@interface ETHTTPRunloopOperation()
{

}   

@property (readwrite, nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (readwrite, nonatomic, assign) ETHttpOperationState state;



@end



@implementation ETHTTPRunloopOperation


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter

/**
 the state machine is borrowed from afnetworking
 http://afnetworking.com/
 */
- (void)setState:(ETHttpOperationState)state
{
    [self.lock lock];
    
    if (isOperationStateTransationValid(self.state, state, [self isCancelled]))
    {
        NSString *oldStateKey = keyForOperationState(self.state);
        NSString *newStateKey = keyForOperationState(state);
        
        [self willChangeValueForKey:newStateKey];
        [self willChangeValueForKey:oldStateKey];
        _state = state;
        [self didChangeValueForKey:oldStateKey];
        [self didChangeValueForKey:newStateKey];
        
    }
    [self.lock unlock];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getter

- (NSThread*)actualRunLoopThread
{
    if(_runLoopThread)
        return _runLoopThread;
    else
        return [NSThread mainThread];
}

- (BOOL)isPaused
{
    return self.state == ETHttpOperationPauseState;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - constructor


- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.state = ETHttpOperationReadyState;
        self.lock = [[NSRecursiveLock alloc] init];
        self.lock.name = kETHttpOperationLockName;
        self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[ETHTTPRunloopOperation]-->dealloc");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSOperation


- (BOOL)isReady {
    return self.state == ETHttpOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == ETHttpOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == ETHttpOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}



- (void)start
{
    [self.lock lock];
    
    if ([self isReady]) {
        self.state = ETHttpOperationReadyState;
        
        [self performSelector:@selector(operationWillStart) onThread:self.actualRunLoopThread withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    
    [self.lock unlock];
}

- (void)cancel
{
    [self.lock lock];
    
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = YES;
        [super cancel];
        [self didChangeValueForKey:@"isCancelled"];
        
        [self performSelector:@selector(operationWillBeCancelled) onThread:self.actualRunLoopThread withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    [self.lock unlock];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method

- (void)pause {
   
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }
    
    [self.lock lock];
    
    if ([self isExecuting]) {

        [self cancel];
    }
    
    self.state = ETHttpOperationPauseState;
    
    [self.lock unlock];
}

- (void)resume {
    if (![self isPaused]) {
        return;
    }
    
    [self.lock lock];
    self.state = ETHttpOperationReadyState;
    
    [self start];
    [self.lock unlock];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method


- (void)operationWillStart
{
    [self.lock lock];
    
    if (![self isCancelled]) {
        
        [self operationDidStart];
        
    }
    
    [self.lock unlock];
    
    if ([self isCancelled]) {
    
        [self operationDidFinish];
    }

}

- (void)operationWillBeCancelled
{
    [self operationDidCancel];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclassing method

- (void)operationDidStart
{
    self.state = ETHttpOperationExecutingState;
}

- (void)operationDidFinish
{
    self.state = ETHttpOperationFinishedState;
}

- (void)operationDidCancel
{
    self.state = ETHttpOperationReadyState;
}


@end
