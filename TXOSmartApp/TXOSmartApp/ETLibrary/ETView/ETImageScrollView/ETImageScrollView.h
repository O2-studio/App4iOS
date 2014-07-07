//
//  ETImageScrollView.h
//  etaoLocal
//
//  Created by moxin on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETImageDownLoadCenter.h"

typedef NSInteger ETImageScrollViewType;

enum
{
    ETImageScroll_ViewPaged = 0,
    ETImageScroll_ViewPeekPaged,
    ETIMageScroll_ViewFadeInOut,
};



@class ETImageScrollView;

@protocol ETImageScrollViewDelegate <NSObject>

@optional

-(void)onScrollImageLoaded:(ETImageScrollView*)sender IndexNumber:(NSInteger)index;
-(void)onScrollImageClicked:(ETImageScrollView*)sender IndexNumber:(NSInteger)index;
-(void)onScrollBeginScroll:(ETImageScrollView*)sender;
-(void)onScrollDidScroll:(ETImageScrollView*)sender;
-(void)onScrollEndScroll:(ETImageScrollView*)sender;

@end


@interface ETImageScrollView : UIView

// scrollview's property
@property(nonatomic,strong)UIColor* backgroundColor;
@property(nonatomic,strong)UIImage* backgroundImage;


// scrollview's datasource
@property(nonatomic,strong)NSArray* pageImages;
@property(nonatomic,strong)NSArray* pageUrls;


// image cache policy
@property(nonatomic)ETImageDownloadCachePolicy imageCachePolicy;
// imageview contentmode
@property(nonatomic)UIViewContentMode imageDisplayMode;

// scrollview's delegate
@property(nonatomic,assign) id<ETImageScrollViewDelegate> delegate;

// enable the pageControl
@property(nonatomic)BOOL isPageControlEnabled;

// enable timer paged
@property(nonatomic)BOOL isTimerControlEnabled;

// enable scrolling
@property(nonatomic)BOOL isScrollEnabled;

// enable zoom
@property(nonatomic) BOOL isZoomEnabled;

// current index
@property(nonatomic)int currentPageIndex;

// image count
@property(nonatomic,readonly) int imageCount;

// public api

// default initializer
- (id)initWithFrame:(CGRect)frame;

// initializer with style
- (id)initWithFrame:(CGRect)frame withStyle : (ETImageScrollViewType) style;

// initializer with index and style
- (id)initWithFrame:(CGRect)frame withStyle : (ETImageScrollViewType) style DefaultSelected:(NSInteger)index ;

// scrollToFirstPage
- (void)scrollToFirstPage;

// scrollToLastPage
- (void)scrollToLastPage;

// scroll to certain page
- (void)scrollToPage:(NSInteger)index Animate:(BOOL)animate;

// clear the array
- (void)clearImageArray;

//get image
- (UIImage*)imageAtIndexPage:(NSInteger)index;

//get imageView
- (ETImageView*)imageViewAtIndexPage:(NSInteger)index;






@end
