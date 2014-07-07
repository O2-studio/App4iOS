//
//  ETAFHttpRequestClient.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-7-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETAFHttpRequestClient.h"

@implementation ETAFHttpRequestClient

+(ETAFHttpRequestClient*)sharedInstance
{
    static ETAFHttpRequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ETAFHttpRequestClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:__NUM_INT(self.operationQueue.operationCount)];
    [self.samplePoints keepTail:50];
}


@end
