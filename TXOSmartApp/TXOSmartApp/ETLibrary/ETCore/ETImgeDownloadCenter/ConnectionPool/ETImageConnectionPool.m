//
//  ETImageConnectionPool.m
//  ETImageDownloaderDemo
//
//  Created by moxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETImageConnectionPool.h"
#import "ETImageDownloadOperation.h"
#import "AFNetworkActivityIndicatorManager.h"



@interface ETImageConnectionPool()
{
    //thread pool
    NSOperationQueue*       _operationQueue;
    //a lock queue
    dispatch_queue_t        _lockQueue;
    //a fast lock
    NSLock*                 _lock;
    //a black name list
    NSMutableArray*         _blackUrlList;
    //a pending url list
    NSMutableArray*         _pendingUrlList;
    //indicator manager
    AFNetworkActivityIndicatorManager* _afIndicatorManager;
}


- (void)performOperation:(NSOperation*) operation;

@end

@implementation ETImageConnectionPool

// ensure thread safe
+(id)currentPool
{
    static ETImageConnectionPool* instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}


- (id)init
{
    self = [super init];
    
    if(self)
    {
        // our main concurrent queue
        _operationQueue = [[NSOperationQueue alloc]init];
        [_operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
     
        // concurrent lock
        _lockQueue = dispatch_queue_create("com.ETImageConnectionPool.www", nil);
        // a fast lock
        _lock = [[NSLock alloc]init];
        
        // set network indicator
        _afIndicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
        _afIndicatorManager.enabled = YES;
        
        // set black name list
        _blackUrlList = [NSMutableArray new];
        
        //pending list
        _pendingUrlList = [NSMutableArray new];
        
    
        
        //memory warning observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(recvMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
    }
    
    return self;
}


- (void)dealloc
{
    _operationQueue = nil;
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_lockQueue);
#endif
    _lockQueue = nil;
    _lock = nil;
    
    _afIndicatorManager.enabled = NO;
    _afIndicatorManager = nil;
    _blackUrlList = nil;
}

#pragma mark - public methods


- (void)startSingleConnection:(NSURL*)aURL
                     userInfo:(NSString*)key
                     progress:(void (^)(float))downloadProgress
                      success:(void (^)(NSString *, UIImage *))success
                      failure:(void (^)(NSString *, NSError *))failure

{
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:aURL];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:ETImageConnectionPool_Default_TimeoutValue];
    
    
    ETImageDownloadOperation *requestOperation = [[ETImageDownloadOperation alloc] initWithRequest:request];
    requestOperation.key = key;

    //add to pending list
    [self addToPendingUrlList:aURL.description];
    

    //set complete block
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        [self removeFromBlackList:operation.request.URL.description];
        [self removeFromPendingUrlList:operation.request.URL.description];
        if (success)
        {
            success(((ETImageDownloadOperation*)operation).key,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
        [self removeFromPendingUrlList:operation.request.URL.description];
        //不是超时引起的错误
        //add to black url list
        if(error.code != -1001)
            [self addToBalckUrlList:operation.request.URL.description];

        
        if (failure)
        {
            failure(((ETImageDownloadOperation*)operation).key, error);
        }
    }];
    
    // set progress block
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        if(downloadProgress)
        {
            downloadProgress((float)totalBytesRead/(float)totalBytesExpectedToRead);
        }
        
    }];
    
    
    [self performOperation:requestOperation];
}

- (void)cancelSingleConncetion:(NSURL*)aURL
{
    if( !aURL )
        return;
    for (NSOperation *operation in [_operationQueue operations])
    {
        if (![operation isKindOfClass:[AFImageRequestOperation class]])
        {
            continue;
        }
        
        else
        {
            AFImageRequestOperation* imageOperation = (AFImageRequestOperation*)operation;
            
            if([imageOperation.request.URL isEqual:aURL])
            {
                
                [operation cancel];
            }
        }
    }
    
}


- (void)cancelAllConnections
{
    NSLog(@"[%@]-->cancelAllConnections",self.class);
    
    [_operationQueue cancelAllOperations];
}

// clean black-name list
- (void)cleanBlackUrlList
{
    [_blackUrlList removeAllObjects];
}
//clean pending-name list
- (void)cleanPendingUrlList
{
    [_pendingUrlList removeAllObjects];
}


#pragma mark - KVO


//@deprecated
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context 
{
    // oberving for finish
//    if ([keyPath isEqualToString:@"isFinished"]) 
//    {
//        [operation removeObserver:self forKeyPath:@"isFinished"];
//
//        //NSLog(@"[Connection Pool]-->receive observation");
//        
//        ETImageDownloadOperation* downloadOperation = (ETImageDownloadOperation*)operation;
//        
//        NSError* error = downloadOperation.error;
//        
//        // handle error
//        if(error != nil)
//        {
//            if([downloadOperation.remoteDelegate respondsToSelector:@selector(imageDidFailLoading:Error:)])
//                [downloadOperation.remoteDelegate imageDidFailLoading:downloadOperation.aURL Error:downloadOperation.error];
//        }
//        
//        // 
//        else 
//        {
//            if( [downloadOperation.remoteDelegate respondsToSelector:@selector(imageDidFinishLoading:Url:)])
//                [downloadOperation.remoteDelegate imageDidFinishLoading:[UIImage imageWithData:downloadOperation.rawData]
//                                                                    Url:downloadOperation.aURL];
//        }
//        
//        // releaes the operation 
//        [_operationPool removeObjectForKey:((ETImageDownloadOperation*)operation).aURL.description];
//        operation = nil;
//    }
//    
//    // observing for progress
//    if([keyPath isEqualToString:@"isExecuting"])
//    {
//        //test:
//        //NSLog(@"[connection pool]-->report progress");
//        
//         ETImageDownloadOperation* downloadOperation = (ETImageDownloadOperation*)operation;
//        
//        if([downloadOperation.remoteDelegate respondsToSelector:@selector(imageDidLoadWithProgress:Url:)])
//            [downloadOperation.remoteDelegate imageDidLoadWithProgress:downloadOperation.progress
//                                                                   Url:downloadOperation.aURL];
//            
//    }
//    
//    if ([keyPath isEqualToString:@"isError"])
//    {
//        ETImageDownloadOperation* downloadOperation = (ETImageDownloadOperation*)operation;
//        
//        NSError* error = downloadOperation.error;
//        
//        // handle error
//        if(error != nil)
//        {
//            if([downloadOperation.remoteDelegate respondsToSelector:@selector(imageDidFailLoading:Error:)])
//                [downloadOperation.remoteDelegate imageDidFailLoading:downloadOperation.aURL Error:downloadOperation.error];
//        }
//        
//        // releaes the operation
//        [_operationPool removeObjectForKey:((ETImageDownloadOperation*)operation).aURL.description];
//        operation = nil;
//
//    }
}





#pragma mark - private methods


- (void)performOperation:(NSOperation*) operation
{
    [_operationQueue setSuspended:YES];
    
    //check for existing operations
    if ([operation isKindOfClass:[AFImageRequestOperation class]]) {
        for (AFImageRequestOperation *op in _operationQueue.operations)
        {
            if ([op isKindOfClass:[AFImageRequestOperation class]])
            {
                AFImageRequestOperation *oper = (AFImageRequestOperation *)operation;
                if ([op.request isEqual:oper.request])
                {
                    //already queued
                    [_operationQueue setSuspended:NO];
                    return;
                }
            }
        }
    }
    
    //make op a dependency of all queued ops
    NSInteger maxOperations = ([_operationQueue maxConcurrentOperationCount] > 0) ? [_operationQueue maxConcurrentOperationCount]: INT_MAX;
    NSInteger index = [_operationQueue operationCount] - maxOperations;
    if (index >= 0)
    {
        NSOperation *op = [[_operationQueue operations] objectAtIndex:index];
        if (![op isExecuting])
        {
            [operation removeDependency:op];
            [op addDependency:operation];
        }
    }
    
    //add operation to queue
    [_operationQueue addOperation:operation];
    
    //resume queue
    [_operationQueue setSuspended:NO];
}

- (void)recvMemoryWarning:(id)sender
{
    NSLog(@"[%@]-->memory warning",[self class]);
    
    [[ETImageConnectionPool currentPool] cancelAllConnections];
}

- (BOOL)isUrlInBlackNameList:(NSString*)urlString
{
    if (!urlString) {
        return NO;
    }
    
    @synchronized(self)
    {
        return [_blackUrlList containsObject:urlString];
    }
}

- (void)addToBalckUrlList:(NSString*)urlString
{
    if (!urlString) {
        return;
    }
    
    @synchronized(self)
    {
        [_blackUrlList addObject:urlString];
        
    };
}

- (void)removeFromBlackList:(NSString*)urlString
{
    if (!urlString) {
        return;
    }
    @synchronized(self)
    {
        [_blackUrlList removeObject:urlString];
        
    };
}

- (BOOL)isUrlInPendingUrlList:(NSString*)urlString
{
    if (!urlString) {
        return NO;
    }
    
    @synchronized(self)
    {
        return [_pendingUrlList containsObject:urlString];
    }
}

- (void)addToPendingUrlList:(NSString*)urlString
{
    if (!urlString) {
        return;
    }
    
    @synchronized(self)
    {
        [_pendingUrlList addObject:urlString];
        
    };
}

- (void)removeFromPendingUrlList:(NSString*)urlString
{
    if (!urlString) {
        return;
    }
    
    @synchronized(self)
    {
        [_pendingUrlList removeObject:urlString];
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:__NUM_INT(_operationQueue.operationCount)];
    [self.samplePoints keepTail:50];
}

@end
