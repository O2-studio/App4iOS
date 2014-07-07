//
//  ETImageView.h
//  etaoLocal
//
//  Created by moxin on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETImageDownloadCenterHeader.h"


@class ETImageView;

@protocol ETImageViewDelegate<NSObject>
@optional

- (void)imageViewClicked:(ETImageView*)imageView;
- (void)imageViewLoadedImage:(ETImageView*)imageView;
- (void)imageViewFailedToLoadImage:(ETImageView*)imageView error:(NSError*)error;
@end

typedef enum
{
    ETImageViewProgressStyle_Circle = 0,
    ETImageViewProgressStyle_Bar,
    ETImageViewProgressStyle_Indicator

}ETImageViewProgressStyle;

@interface ETImageView : UIImageView

/**
 * id标识，用于cell上的imageview
 */
@property(nonatomic,strong) NSString* identifier;
/*
 * 进度条样式，默认为indicator
 */
@property(nonatomic) ETImageViewProgressStyle progressStyle;
/*
 * 图片上是否显示进度条，默认为1
 */
@property(nonatomic) BOOL enableProgress;
/**
 * 图片process
 */
@property(nonatomic) BOOL enablePicProcess;
/*
 * 图片加载完成的淡入效果，默认为1
 */
@property(nonatomic) BOOL enableFadeInAnimation;
/*
 * 图片上触摸的点
 */
@property(nonatomic,readonly) CGPoint clickPt;
/*
 * 图片的imageUrl
 */
@property(nonatomic,strong) NSURL* imageURL;
/*
 * 图片展示的静态image
 */
@property(nonatomic,strong) UIImage* placeholderImage;
/*
 * 图片的默认图
 */
@property(nonatomic,strong) UIImage* backgroundImage;
/*
 * 图片错误背景图
 */
@property(nonatomic,strong) UIImage* errorBackgroudImage;
/*
 * 图片的delegate
 */
@property(nonatomic,weak) id<ETImageViewDelegate> delegate;
/*
 * 图片的遮罩，默认尺寸和图片尺寸相同
 */
@property(nonatomic,strong) UIImageView* imageFrame;
/*
 * 同步在内存中加载图片，
 */
- (BOOL)startImageDownloadSynchronously:(NSURL*)imageURL;
/*
 * 异步下载图片，默认的cache策略为：ETImageDownloadWithoutCachingImage
 */
- (void)startImageDownloadAutomatically : (NSURL*)imageURL;
/*
 * 异步下载图片，指定cache策略
 */
- (void)startImageDownloadAutomatically:(NSURL *)imageURL
                            cachePolicy:(ETImageDownloadCachePolicy) policy;
/*
 * 异步下载图片，指定cache策略
 */
- (void)startImageDownloadAutomatically:(NSURL *)imageURL
                            cachePolicy:(ETImageDownloadCachePolicy) policy
                                process:(ETImageProcessingBlock) processBlock;

/*
 * 取消下载图片
 */
- (void)cancelImageLoad;
/**
 * 释放图片
 */
- (void)releaseImage;

@end



