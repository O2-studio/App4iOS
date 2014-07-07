//
//  TBCitySBButton.m
//  sbkit
//
//  Created by fisher on 14-5-7.
//  Copyright (c) 2014年 taobao.com. All rights reserved.
//

#import "TBCitySBButton.h"

@interface TBCitySBButton()

@property (nonatomic,strong) TBCitySBModel                      *sbModel;
@property (nonatomic,copy  ) TBCitySBButtonClickModelCallback   completeCallback;
@property (nonatomic,copy  ) TBCitySBButtonClickEventDidBegin   clickDidBeginCallback;

@end

@implementation TBCitySBButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    if (_completeCallback) {
        _completeCallback = nil;
    }
    
    if (_clickDidBeginCallback) {
        _clickDidBeginCallback = nil;
    }
    _sbModel = nil;
}

#pragma mark - Public Method

- (void)registerModel:(TBCitySBModel *)model {
    _sbModel = model;
}

- (void)unRegisterModel:(TBCitySBModel *)model {
    _sbModel = nil;
}


- (void)listenClickEvents:(TBCitySBButtonClickEventDidBegin)clickDidBeginCallback completeCallback:(TBCitySBButtonClickModelCallback)completeCallback {
    if (completeCallback) {
        _completeCallback = nil;
        _completeCallback = completeCallback;
    }
    
    if (clickDidBeginCallback) {
        _clickDidBeginCallback = nil;
        _clickDidBeginCallback = clickDidBeginCallback;
    }
    
    [self addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - Private Method
- (void)clickEvent:(id)sender {
    if (!_sbModel) {
        return;
    }
    self.enabled = NO;
    
    if (_clickDidBeginCallback) {
        _clickDidBeginCallback(self);
    }
    
    __weak typeof(self) weakSelf = self;
    [_sbModel loadWithCompletion:^(TBCitySBModel *model, NSError *error) {
        weakSelf.enabled = YES;
        if (weakSelf.completeCallback) {
            weakSelf.completeCallback(model,error);
        }
    }];
    
}

@end
