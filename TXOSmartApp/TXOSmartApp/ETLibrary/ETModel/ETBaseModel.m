//
//  ETBaseModel.m
//  etaoLocal
//
//  Created by 稳 张 on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETBaseModel.h"


@implementation ETBaseModel


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)init
{
    self = [super init];
    
    if (self)
    {
        _tagName = @"";
        _modelState = kModelStateIsIdle;
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)load
{
    if (_modelState == kModelStateIsLoading) {
        [self cancel];
    }
    
    
    if (_modelAction != kModelActionReload &&
        _modelAction != kModelActionLoadMore) {
        _modelAction = kModelActionLoad;
    }
 
}

- (void)reload
{
    if (_modelState == kModelStateIsLoading) {
        [self cancel];
    }
    
    [self reset];
   
    _modelAction = kModelActionReload;
    
    [self load];
   
}
- (void)loadMore
{
    if (_modelState == kModelStateIsLoading) {
        [self cancel];
    }
    _modelAction = kModelActionLoadMore;
    
    [self load];
}

- (void) cancel
{
    _modelAction = kModelActionCancel;

    
}

- (void)reset;
{
    [self cancel];
    
    _modelState = kModelStateIsIdle;

}

- (void)didStartLoading
{
    [self _didStartLoading];
}
/*
 * model 请求完成
 */
- (void)didFinishLoading
{
    [self _didFinishLoading];
}
/*
 * model 请求失败
 */
- (void)didFailWithError:(NSError *)error
{
    [self _didFailWithError:error];
}
/*
 * model 请求取消
 */
- (void)didCancelLoading
{
    [self _didCancelLoading];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

/*
 * model 开始请求
 */
- (void)_didStartLoading
{
    _modelState = kModelStateIsLoading;
    
    if (self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(modelRequestDidStartToLoad:)])
    {
        [self.modelDelegate modelRequestDidStartToLoad:self];
    }

}
/*
 * model 请求完成
 */
- (void)_didFinishLoading
{
    _modelState = kModelStateIsSuccess;
    
    if (self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(modelRequestDidFinish:)])
    {
        [self.modelDelegate modelRequestDidFinish:self];
    }
}
/*
 * model 请求失败
 */
- (void)_didFailWithError:(NSError *)error
{
    _modelState = kModelStateIsError;
    
    if (self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(model:RequestDidFailWithError:)])
    {
        [self.modelDelegate model:self RequestDidFailWithError:error];
    }

}
/*
 * model 请求取消
 */
- (void)_didCancelLoading
{
    _modelState = kModelStateIsIdle;
    
    if (self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(modelRequestCancelLoding:)]){
        
        [self.modelDelegate modelRequestDidCancel:self];
    }

}


@end
