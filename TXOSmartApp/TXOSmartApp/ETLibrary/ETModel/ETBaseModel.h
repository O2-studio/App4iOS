//
//  ETBaseModel.h
//  etaoLocal
//
//  Created by moxin.xt on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//   Modified by Moxin on 12-16-8
//
//

#import <Foundation/Foundation.h>




@class ETBaseModel;

@protocol ETModelDelegate<NSObject> 

@optional
/*
 * start
 */
- (void)  modelRequestDidStartToLoad    :(ETBaseModel*)model;
/*
 * finish
 */
- (void)  modelRequestDidFinish         :(ETBaseModel*)model;
/*
 * cancel
 */
- (void)  modelRequestDidCancel         :(ETBaseModel *)model;
/*
 * error
 */
- (void)  model:(ETBaseModel*)model RequestDidFailWithError:(NSError*)error;

@end


//model state-machine
typedef NS_ENUM(int, ModelState)
{
	kModelStateIsIdle=0,
	kModelStateIsLoading,
    kModelStateIsSuccess,
	kModelStateIsError
};

//model action
typedef NS_ENUM (int,ModelAction)
{
    kModelActionLoad=0,
    kModelActionReload,
    kModelActionLoadMore,
    kModelActionCancel
};


@interface ETBaseModel : NSObject 
/**
 key of model
 */
@property (nonatomic,strong) NSString* tagName;
/**
 delegate
 */
@property (nonatomic, weak) id<ETModelDelegate> modelDelegate;
/**
 state of model
 */
@property(nonatomic,assign,readonly) ModelState modelState;
/**
 current action of model
 */
@property(nonatomic,assign,readonly) ModelAction modelAction;
/**
error of model
 */
@property (nonatomic, strong,readonly,getter = isModelError) NSError* modelError;

/////////////////////////child should override these method/////////////////////

/* 
 * model load请求 
 */
- (void)load;
/* 
 * model 取消loading 
 */
- (void)cancel;
/* 
 * model 重新load 
 */
- (void)reload;
/* 
 * mode的翻页请求
 */
- (void)loadMore;
/*
 * model reset
 */
- (void)reset;
/*
 * model 开始请求
 */
- (void)didStartLoading;
/*
 * model 请求完成
 */
- (void)didFinishLoading;
/*
 * model 请求失败
 */
- (void)didFailWithError:(NSError *)error;
/*
 * model 请求取消
 */
- (void)didCancelLoading;


@end
