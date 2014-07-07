//
//  ETImageScrollChildView.m
//  etaoshopping
//
//  Created by moxin.xt on 12-12-20.
//
//

#import "ETImageScrollChildView.h"
#import "ETImageView.h"

#define kZoomStep 1.5

@interface ETImageScrollChildView () <UIScrollViewDelegate,ETImageViewDelegate>



@end

@implementation ETImageScrollChildView
{
    CGPoint  _pointToCenterAfterResize;
    CGFloat  _scaleToRestoreAfterResize;
}

@synthesize imageDisplayMode = _imageDisplayMode;
@synthesize imageView = _imageView;
@synthesize childViewDelegate = _childViewDelegate;

- (void)setImageDisplayMode:(UIViewContentMode)imageDisplayMode
{
    _imageDisplayMode = imageDisplayMode;
    
    self.imageView.contentMode = imageDisplayMode;
    self.imageView.clipsToBounds = YES;
    
    [self.imageView setNeedsDisplay];
}

- (void)setIsZoomEnabled:(BOOL)isZoomEnabled
{
    _isZoomEnabled = isZoomEnabled;

    if(!isZoomEnabled)
    {
        //remove gestures
        for(UIGestureRecognizer* gestures in self.imageView.gestureRecognizers)
            [self.imageView removeGestureRecognizer:gestures];
        
        //remove gestures
        for (UIGestureRecognizer* gesture in self.gestureRecognizers)
        {
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]||[gesture isKindOfClass:[UIPinchGestureRecognizer class]])
            {
                [self removeGestureRecognizer:gesture];
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    // scrollview's property
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = TRUE;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    UITapGestureRecognizer *scrollViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewDoubleTap:)];
    [scrollViewDoubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:scrollViewDoubleTap];
    
    UITapGestureRecognizer *scrollViewTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewTwoFingerTap:)];
    [scrollViewTwoFingerTap setNumberOfTouchesRequired:2];
    [self addGestureRecognizer:scrollViewTwoFingerTap];
    
    UITapGestureRecognizer *scrollViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewSingleTap:)];
    [scrollViewSingleTap requireGestureRecognizerToFail:scrollViewDoubleTap];
    [self addGestureRecognizer:scrollViewSingleTap];
        
    // imageview's property
    ETImageView *imageView = [[ETImageView alloc] initWithFrame:self.frame];
    imageView.delegate = self;
    imageView.userInteractionEnabled = TRUE;
    
    //remove old gestures
    for(UIGestureRecognizer* gestures in imageView.gestureRecognizers)
        [imageView removeGestureRecognizer:gestures];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    UITapGestureRecognizer *doubleTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTwoFingerTap:)];
    
    //手势并存
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [twoFingerTap requireGestureRecognizerToFail:doubleTwoFingerTap];
    
    //双击
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    
    //pan
    [twoFingerTap setNumberOfTouchesRequired:2];
    [twoFingerTap setNumberOfTapsRequired:1];
    
    //两指双击
    [doubleTwoFingerTap setNumberOfTapsRequired:2];
    [doubleTwoFingerTap setNumberOfTouchesRequired:2];
    
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    [imageView addGestureRecognizer:doubleTwoFingerTap];
    
    [self addSubview:imageView];
    

    self.imageView = imageView;    
    // set content size of scrollview
    self.contentSize = self.imageView.frame.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setZoomScale:self.minimumZoomScale animated:FALSE];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
    
    CGPoint contentOffset = self.contentOffset;
    
    // ensure horizontal offset is reasonable
    if (frameToCenter.origin.x != 0.0)
        contentOffset.x = 0.0;
    
    // ensure vertical offset is reasonable
    if (frameToCenter.origin.y != 0.0)
        contentOffset.y = 0.0;
    
    self.contentOffset = contentOffset;
    
    // ensure content insert is zeroed out using translucent navigation bars
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}

#pragma mark - Public Implementation
#pragma mark -

- (void)prepareForReuse {
    // start by dropping any views and resetting the key properties
    if (self.imageView != nil) {
        for (UIGestureRecognizer *gestureRecognizer in self.imageView.gestureRecognizers) {
            [self.imageView removeGestureRecognizer:gestureRecognizer];
        }
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.imageView = nil;
}

- (void)displayImage:(UIImage *)image
{
    if (image) {
        
        float scale = self.frame.size.width/image.size.width;
        
        self.contentSize = CGSizeMake(self.frame.size.width, scale*image.size.height);
        
        CGRect rect = self.imageView.frame;
        rect.size = self.contentSize;
        self.imageView.frame = rect;
        self.imageView.image = image;
    }
    
}

- (void)downloadImage:(NSURL *)url CachePolicy:(ETImageDownloadCachePolicy)policy
{
    [self downloadImage:url CachePolicy:policy BackgroundImage:nil];
}

- (void)downloadImage:(NSURL *)url CachePolicy:(ETImageDownloadCachePolicy)policy BackgroundImage:(UIImage*)bkImg
{

    [self.imageView startImageDownloadAutomatically:url cachePolicy:policy];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - imageview

- (void)imageViewLoadedImage:(ETImageView *)imageView
{
    UIImage* image = imageView.image;
    
    if (image) {
        
        float scale = self.frame.size.width/image.size.width;
        
        self.contentSize = CGSizeMake(self.frame.size.width, scale*image.size.height);
        
        CGRect rect = imageView.frame;
        rect.size = self.contentSize;
        imageView.frame = rect;
        
        if ([self.childViewDelegate respondsToSelector:@selector(childView:DidLoadImagewithUrl:)]) {
            [self.childViewDelegate childView:self DidLoadImagewithUrl:imageView.imageURL];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gestures

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.childViewDelegate && [self.childViewDelegate respondsToSelector:@selector(childViewDidSingleTap:)])
        [self.childViewDelegate childViewDidSingleTap:self];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (self.zoomScale == self.maximumZoomScale) {
        // jump back to minimum scale
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:self.minimumZoomScale];
    }
    else {
        // double tap zooms in
        CGFloat newScale = MIN(self.zoomScale * kZoomStep, self.maximumZoomScale);
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    }
    
    if (self.childViewDelegate != nil) {
        [self.childViewDelegate childViewDidDoubleTap:self];
    }
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    CGFloat newScale = MAX([self zoomScale] / kZoomStep, self.minimumZoomScale);
    [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    
    if (self.childViewDelegate != nil) {
        [self.childViewDelegate childViewDidTwoFingerTap:self];
    }
}

- (void)handleDoubleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewDelegate != nil) {
        [self.childViewDelegate childViewDidDoubleTwoFingerTap:self];
    }
}

- (void)handleScrollViewSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewDelegate != nil) {
        [self.childViewDelegate childViewDidSingleTap:self];
    }
}

- (void)handleScrollViewDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image == nil) return;
    CGPoint center =[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale = MIN([self zoomScale] * kZoomStep, self.maximumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
}

- (void)handleScrollViewTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image == nil) return;
    CGPoint center =[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale = MAX([self zoomScale] / kZoomStep, self.minimumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
}

- (CGPoint)adjustPointIntoImageView:(CGPoint)center {
    BOOL contains = CGRectContainsPoint(self.imageView.frame, center);
    
    if (!contains) {
        center.x = center.x / self.zoomScale;
        center.y = center.y / self.zoomScale;
        
        // adjust center with bounds and scale to be a point within the image view bounds
        CGRect imageViewBounds = self.imageView.bounds;
        
        center.x = MAX(center.x, imageViewBounds.origin.x);
        center.x = MIN(center.x, imageViewBounds.origin.x + imageViewBounds.size.height);
        
        center.y = MAX(center.y, imageViewBounds.origin.y);
        center.y = MIN(center.y, imageViewBounds.origin.y + imageViewBounds.size.width);
        
        return center;
    }
    
    return CGPointZero;
}

#pragma mark - Support Methods
#pragma mark -

- (void)updateZoomScale:(CGFloat)newScale {
    CGPoint center = CGPointMake(self.imageView.bounds.size.width/ 2.0, self.imageView.bounds.size.height / 2.0);
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
    assert(newScale >= self.minimumZoomScale);
    assert(newScale <= self.maximumZoomScale);
    
    if (self.zoomScale != newScale) {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    assert(scale >= self.minimumZoomScale);
    assert(scale <= self.maximumZoomScale);
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



- (void)setMaxMinZoomScalesForCurrentBounds {
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    CGSize boundsSize = self.bounds.size;
    
    CGFloat minScale = 0.25;
    
    if (self.imageView.bounds.size.width > 0.0 && self.imageView.bounds.size.height > 0.0) {
        // calculate min/max zoomscale
        CGFloat xScale = boundsSize.width  / self.imageView.bounds.size.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / self.imageView.bounds.size.height;   // the scale needed to perfectly fit the image height-wise
        
        //        xScale = MIN(1, xScale);
        //        yScale = MIN(1, yScale);
        
        minScale = MIN(xScale, yScale);
    }
    
    CGFloat maxScale = minScale * (kZoomStep * 2);
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)prepareToResize {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.imageView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.imageView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    return CGPointZero;
}

#pragma mark - UIScrollViewDelegate Methods
#pragma mark -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


@end