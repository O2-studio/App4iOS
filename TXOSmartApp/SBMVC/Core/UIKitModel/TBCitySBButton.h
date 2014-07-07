//
//  TBCitySBButton.h
//  sbkit
//
//  Created by fisher on 14-5-7.
//  Copyright (c) 2014年 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBCitySBModel;
typedef void(^TBCitySBButtonClickEventDidBegin)(id sender);
typedef void(^TBCitySBButtonClickModelCallback) (TBCitySBModel* model, NSError* error);

@interface TBCitySBButton : UIButton


/**
 *  注册model，用于model和UIButton绑定
 *
 *  SBMVC => 1.1
 *
 *  @param model
 */
- (void)registerModel:(TBCitySBModel *)model;

/**
 *  解除model的绑定
 *
 *  SBMVC => 1.1
 *
 *  @param model
 */
- (void)unRegisterModel:(TBCitySBModel *)model;

/**
 *  监听UIButton点击
 *
 *  SBMVC => 1.1
 *
 *  @param clickDidBegin 按钮点击开始响应回调
 *  @param callback      model请求成功回调
 */
- (void)listenClickEvents:(TBCitySBButtonClickEventDidBegin)clickDidBeginCallback completeCallback:(TBCitySBButtonClickModelCallback)completeCallback;

@end
