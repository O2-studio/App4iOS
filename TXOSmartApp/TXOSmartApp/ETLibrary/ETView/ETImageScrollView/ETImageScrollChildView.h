//
//  ETImageScrollChildView.h
//  etaoshopping
//
//  Created by moxin.xt on 12-12-20.
//
//

#import <UIKit/UIKit.h>
#import "ETImageDownloadCenterHeader.h"

@class ETImageScrollChildView;

@protocol ETImageScrollChildView <NSObject>

@optional

- (void)childViewDidSingleTap:(ETImageScrollChildView *)childView;
- (void)childViewDidDoubleTap:(ETImageScrollChildView *)childView;
- (void)childViewDidTwoFingerTap:(ETImageScrollChildView *)childView;
- (void)childViewDidDoubleTwoFingerTap:(ETImageScrollChildView *)childView;
- (void)childView:(ETImageScrollChildView*)childView DidLoadImagewithUrl:(NSURL*)url;

@end

@interface ETImageScrollChildView : UIScrollView

@property (weak, nonatomic) ETImageView *imageView;
@property(nonatomic,weak) id<ETImageScrollChildView> childViewDelegate;
@property(nonatomic) UIViewContentMode imageDisplayMode;
@property(nonatomic) BOOL isZoomEnabled;

- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;
- (void)downloadImage:(NSURL *)url CachePolicy:(ETImageDownloadCachePolicy)policy;
- (void)downloadImage:(NSURL *)url CachePolicy:(ETImageDownloadCachePolicy)policy BackgroundImage:(UIImage*)bkImg;

- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;



@end
