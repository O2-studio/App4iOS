//
//  ETImageView.m
//  etaoLocal
//
//  Created by moxin on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#define kETImageDefaultProgressBarLenght 200


@class ETImageLoadingView;

#define kETImageProgressBarDefaultHeight                    15.0f
#define kETImageProgressBarDefaultWidth                     200.0f
#define kETImageProgressCircleDefaultWidth                  75.0f
#define kETImageProgressIndicatorDefaultWidth               25.0f

@interface ETImageLoadingView : UIView
{
    float _progress;
}

//ETImageViewProgressStyle
@property(nonatomic) ETImageViewProgressStyle style;

//ETImageViewProgressBar:
@property (nonatomic,strong) UIColor *innerColor ;
@property (nonatomic,strong) UIColor *outerColor ;
@property (nonatomic,strong) UIColor *emptyColor ;

//ETImageViewProgressIndicator:
@property (nonatomic,strong) UIActivityIndicatorView* indicator;

//ETImageViewProgressCircle:
@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *circleBkColor;

//showProgress
- (void)showProgress: (float) progress Style:(ETImageViewProgressStyle)style;


@end

@interface ETImageView()
{
    float _imgProgress;
}

@property(nonatomic,strong)ETImageLoadingView*  loadingProgressView;


@end



@interface ETImageView()



@end


@implementation ETImageView

@synthesize progressStyle           = _progressStyle;
@synthesize imageURL                = _imageURL;
@synthesize placeholderImage        = _placeholderImage;
@synthesize backgroundImage         = _backgroundImage;
@synthesize delegate                = _delegate;
@synthesize enableProgress          = _enableProgress;
@synthesize clickPt                 = _clickPt;
@synthesize enableFadeInAnimation   = _enableFadeInAnimation;
@synthesize errorBackgroudImage     = _errorBackgroudImage;


///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSURL*)imageURL
{
    return _imageURL;
}
-(UIImageView*)imageFrame
{
    if(!_imageFrame)
    {
        _imageFrame = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageFrame.backgroundColor = [UIColor clearColor];
        _imageFrame.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_imageFrame];
    }
    
    return _imageFrame;
}


///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters


- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if(_backgroundImage != backgroundImage)
    {
        _backgroundImage = nil;
        _backgroundImage = backgroundImage;
    }
}

- (void)setErrorBackgroudImage:(UIImage *)errorBackgroudImage
{
    if(_errorBackgroudImage != errorBackgroudImage)
    {
        _errorBackgroudImage = nil;
        _errorBackgroudImage = errorBackgroudImage;
    }
}

- (void)setProgressStyle:(ETImageViewProgressStyle)progressStyle
{
    _progressStyle = progressStyle;
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //动画效果
    self.enableFadeInAnimation = NO;
    self.enableProgress = NO;
    self.enablePicProcess = NO;
    
    //点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImgClickedListener:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    
    [self addGestureRecognizer:singleTap];
    [self setUserInteractionEnabled:YES];
    


    //progress view
    _loadingProgressView = [[ETImageLoadingView alloc]initWithFrame:CGRectZero];
    _loadingProgressView.hidden = YES;
    _loadingProgressView.style = ETImageViewProgressStyle_Indicator;
    [self addSubview:_loadingProgressView];
}


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.enableProgress) {
        
        if (!self.loadingProgressView.hidden)
        {            
            if (self.loadingProgressView.style == ETImageViewProgressStyle_Bar)
            {
                if(CGRectGetHeight(self.frame) < kETImageProgressBarDefaultHeight
                   || CGRectGetWidth(self.frame) < kETImageProgressBarDefaultWidth)
                {
                    self.loadingProgressView.frame = CGRectZero;
                }
                else
                {
                    CGRect frame = self.loadingProgressView.frame;
                    frame.size.width  = kETImageProgressBarDefaultWidth;
                    frame.size.height = kETImageProgressBarDefaultHeight;
                    self.loadingProgressView.frame = frame;
                    self.loadingProgressView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
                    //[self.loadingProgressView showProgress:_imgProgress Style:ETImageViewProgressStyle_Bar];
                }
            }
            
            if (self.loadingProgressView.style == ETImageViewProgressStyle_Circle) {
                
                if (CGRectGetHeight(self.frame) < kETImageProgressCircleDefaultWidth
                    || CGRectGetWidth(self.frame) < kETImageProgressCircleDefaultWidth) {
                    
                    self.loadingProgressView.frame = CGRectZero;
                }
                else
                {
                    CGRect frame = self.loadingProgressView.frame;
                    frame.size.width  = kETImageProgressCircleDefaultWidth;
                    frame.size.height = kETImageProgressCircleDefaultWidth;
                    self.loadingProgressView.frame = frame;
                    self.loadingProgressView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
                
                    //[self.loadingProgressView showProgress:_imgProgress Style:ETImageViewProgressStyle_Bar];
                }
            }
            
            if (self.loadingProgressView.style == ETImageViewProgressStyle_Indicator) {
                
                if (CGRectGetHeight(self.frame) < kETImageProgressIndicatorDefaultWidth
                    || CGRectGetWidth(self.frame) < kETImageProgressIndicatorDefaultWidth) {
                    
                    self.loadingProgressView.frame = CGRectZero;
                }
                else
                {
                    CGRect frame = self.loadingProgressView.frame;
                    frame.size.width  = kETImageProgressIndicatorDefaultWidth;
                    frame.size.height = kETImageProgressIndicatorDefaultWidth;
                     self.loadingProgressView.frame = frame;
                    self.loadingProgressView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
                   
                    //[self.loadingProgressView showProgress:_imgProgress Style:ETImageViewProgressStyle_Indicator];
                }
            }
        }
    }    
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)startImageDownloadAutomatically : (NSURL*)imageURL
{
    [self startImageDownloadAutomatically:imageURL cachePolicy:ETImageDownloadWithoutCachingImage];
}

- (void)startImageDownloadAutomatically:(NSURL *)imageURL cachePolicy:(ETImageDownloadCachePolicy)policy
{
    [self startImageDownloadAutomatically:imageURL cachePolicy:policy process:nil];
}
- (void)startImageDownloadAutomatically:(NSURL *)imageURL
                            cachePolicy:(ETImageDownloadCachePolicy) policy
                                process:(ETImageProcessingBlock) processBlock
{

	if(!imageURL)
		return;
    
    if([imageURL isEqual:self.imageURL])
        return;
    
    self.imageURL = imageURL;
    
    //1, hide loading progress
    [self.loadingProgressView setHidden:YES];
    
    //2, check memory cache
    if ([self startImageDownloadSynchronously:self.imageURL])
        return;

    //3, download from network
    if (self.enableProgress) {
       
        if (![[ETImagePool currentImagePool] imageExistsInDisk:imageURL]) {

            [self.loadingProgressView showProgress:0.0f Style:self.progressStyle];
            [self.loadingProgressView setHidden:NO];
        }
    }
    
    NSString* key = self.identifier.length > 0? self.identifier : imageURL.description;

    __weak ETImageView* weakSelf = self;
    [[ETImageDownLoadCenter defaultCenter] load:_imageURL cachePolicy:policy extraBundle:key Success:^(UIImage *image, NSURL *url,NSString* key) {
                
        //check url to see if it is legal
        if(![weakSelf checkUrl:weakSelf :key])
            return ;
        
        if (weakSelf.enablePicProcess) {
            
            [[ETThread sharedInstance] enqueueInBackground:^{
                
                
                UIImage* processedImage = [image imageToFitSize:weakSelf.bounds.size method:ETImageResizeCropStart];

                //refill it in to memory image cache
                [[ETImagePool currentImagePool] setImageInMemory:processedImage ForKey:_imageURL];
                
                //cross fade animation
                [[ETThread sharedInstance] enqueueOnMainThread:^{
                    
                    //hide progress view
                    weakSelf.loadingProgressView.hidden = YES;
                    
                    
                    if (weakSelf.enableFadeInAnimation) {
                        
                        [weakSelf showCrossFadeInImageOnMainThread:processedImage Identifier:key];
                    }
                    else
                    {
                        if ([key isEqualToString:weakSelf.identifier] || [key isEqualToString:weakSelf.imageURL.absoluteString]) {
                            
                            if (processedImage) {
                                 weakSelf.image = processedImage;
                            }
                            else
                                weakSelf.image = weakSelf.backgroundImage;
                        
                        }
                    }
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
                    {
                        [weakSelf.delegate imageViewLoadedImage:weakSelf];
                    }
                    
                    
                }];
            }];

        }
        else
        {
            //cross fade animation
            [[ETThread sharedInstance] enqueueOnMainThread:^{
                
                //hide progress view
                weakSelf.loadingProgressView.hidden = YES;
                
                
                if (weakSelf.enableFadeInAnimation) {
                    
                    [weakSelf showCrossFadeInImageOnMainThread:image Identifier:key];
                }
                else
                {
                    if ([key isEqualToString:weakSelf.identifier] || [key isEqualToString:weakSelf.imageURL.absoluteString]) {
                        
                        if (image) {
                               weakSelf.image = image;
                        }
                        else
                            weakSelf.image = weakSelf.backgroundImage;
                     
                    }
                    else
                    {
                        NSLog(@"miss image");
                    }
                }
                
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
                {
                    [weakSelf.delegate imageViewLoadedImage:weakSelf];
                }
            }];

        }
        

     
        
    } Failure:^(UIImage *image, NSURL *url, NSError *error,NSString* key) {
        
      
        //check url to see if it is legal
        if(![weakSelf checkUrl:weakSelf :key])
            return ;

        //show failure status
        NSLog(@"[%@]-->fail loading image:%@ ErrorCode:%d",weakSelf.class,weakSelf.imageURL,error.code);
        
        self.loadingProgressView.hidden = YES;
        
        if (weakSelf.errorBackgroudImage != nil) {
            weakSelf.image = weakSelf.errorBackgroudImage;
        }
        else
        {            
            weakSelf.image = weakSelf.backgroundImage;
        }
        
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)])
        {
            [weakSelf.delegate imageViewFailedToLoadImage:weakSelf error:error];
        }

    } Progress:^(NSNumber *progress, NSURL *url, NSString* key) {
        
        //check url to see if it is legal
        if(![weakSelf checkUrl:weakSelf :key])
            return ;
        
        //show progress
        if(weakSelf.enableProgress)
        {
            _imgProgress = progress.floatValue;
            
       
            [weakSelf.loadingProgressView setHidden:NO];
            [weakSelf setNeedsLayout];
            //[weakSelf.loadingProgressView setProgress:progress.floatValue];
            [weakSelf.loadingProgressView showProgress:progress.floatValue Style:weakSelf.progressStyle];
        }
        
    }ProcessImage:processBlock];

}

- (BOOL)startImageDownloadSynchronously:(NSURL*)imageURL
{
    if(imageURL == nil)
        return NO;
    
    //UIImage* image = [[ETImageDownLoadCenter defaultCenter]loadSynchronouslyFromMemory:imageURL];
    UIImage* image = [[ETImagePool currentImagePool] getImageFromMemoryForKey:imageURL];
        
    if(image == nil)
    {
        if (self.backgroundImage) {
            
            self.image = self.backgroundImage;
            
            if (!self.enableProgress) {
                self.image = self.backgroundImage;
            }
            else
                self.image = nil;
        }
        else
            self.image = nil;
        return NO;
    }
    else
    {
        self.image = image;
        
        if ([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
            [self.delegate imageViewLoadedImage:self];
        }
        
        return YES;
    }
}

- (void)cancelImageLoad
{
    NSLog(@"[%@]-->cancelImageLoad",self.class);
    
    [[ETImageDownLoadCenter defaultCenter] cancelLoadingSingleImage:self.imageURL];
    
}

/**
 * 释放图片
 */
- (void)releaseImage
{
    self.image = nil;
    self.imageURL = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method



-(void)onImgClickedListener:(UIGestureRecognizer*) sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        _clickPt =  [sender locationInView:self];

        if(self.delegate && [self.delegate respondsToSelector:@selector(imageViewClicked:)])
        {
            [self.delegate imageViewClicked:self];
        }
    
    }
}

- (void)showCrossFadeInImageOnMainThread:(UIImage*)image Identifier:(NSString*)identifier
{
     __weak ETImageView* weakSelf = self;
    if ([weakSelf.identifier isEqualToString:identifier]||[weakSelf.imageURL.absoluteString isEqualToString:identifier])
    {
        // crossfade
        id animation = objc_msgSend(NSClassFromString(@"CATransition"), @selector(animation));
        objc_msgSend(animation, @selector(setType:), @"kCATransitionFade");
        objc_msgSend(weakSelf.layer, @selector(addAnimation:forKey:), animation, nil);
        //set processed image
        //self.placeholderImage = image;
        weakSelf.image = image;
        
        
    }
    else
    {
        NSLog(@"miss image");
    }
}

- (BOOL)checkUrl:(ETImageView*)weakSelf :(NSString*)key
{
    if (weakSelf.identifier) {
        
        if (![weakSelf.identifier isEqualToString:key]) {
            return NO;
        }
        else
            return YES;
    }
    else
    {
        if (![key isEqualToString:weakSelf.imageURL.absoluteString]) {
            return NO;
        }
        else
            return YES;
    }
}


@end



////////////////////////////////////////////////////////////////////////////////////////////////////////////



@implementation ETImageLoadingView

@synthesize style = _style;

@synthesize innerColor = _innerColor;
@synthesize outerColor = _outerColor;
@synthesize emptyColor = _emptyColor;
@synthesize indicator  = _indicator;
@synthesize circleBkColor = _circleBkColor;
@synthesize circleColor = _circleColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.innerColor = [UIColor grayColor] ;
		self.outerColor = [UIColor grayColor] ;
		self.emptyColor = [UIColor clearColor] ;
        
        self.circleColor   =  [UIColor whiteColor];
        self.circleBkColor =  [UIColor grayColor];
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)showProgress: (float) progress Style:(ETImageViewProgressStyle)style
{
    _style    = style;
    _progress = progress;
    
    switch (_style)
    {
        case ETImageViewProgressStyle_Circle:
        {
            [self setNeedsDisplay];
            break;
        }
        case ETImageViewProgressStyle_Bar:
        {
            [self setNeedsDisplay];
            break;
        }
            
        case ETImageViewProgressStyle_Indicator:
        {
            if (progress < 1) {
            [self.indicator startAnimating];
            }
            else
                [self.indicator stopAnimating];
            break;
        }
            
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    switch (_style)
    {
        case ETImageViewProgressStyle_Circle:
        {
            
           
            int circleBound = self.bounds.size.width*2/3;
            
            CGFloat lineWidth = 5.f;
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            CGFloat radius = (circleBound - lineWidth)/2;
            CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
            CGFloat endAngle = (2 * (float)M_PI) + startAngle;
            
            
//            UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
//            processBackgroundPath.lineWidth = lineWidth;
//            processBackgroundPath.lineCapStyle = kCGLineCapRound;
       
//            [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//            [self.circleBkColor set];
//            [processBackgroundPath stroke];
            // Draw progress
            UIBezierPath *processPath = [UIBezierPath bezierPath];
            processPath.lineCapStyle = kCGLineCapRound;
            processPath.lineWidth = lineWidth;
            endAngle = (_progress * 2 * (float)M_PI) + startAngle;
            [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            [self.circleColor set];
            [processPath stroke];
            
            break;
        }
        case ETImageViewProgressStyle_Bar:
        {
            CGContextRef context = UIGraphicsGetCurrentContext() ;
            
            // save the context
            CGContextSaveGState(context) ;
            
            // allow antialiasing
            CGContextSetAllowsAntialiasing(context, TRUE) ;
            
            // we first draw the outter rounded rectangle
            rect = CGRectInset(rect, 1.0f, 1.0f) ;
            CGFloat radius = 0.5f * rect.size.height ;
            
            [self.outerColor setStroke] ;
            CGContextSetLineWidth(context, 2.0f) ;
            
            CGContextBeginPath(context) ;
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
            CGContextClosePath(context) ;
            CGContextDrawPath(context, kCGPathStroke) ;
            
            // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
            rect = CGRectInset(rect, 3.0f, 3.0f) ;
            radius = 0.5f * rect.size.height ;
            
            [self.emptyColor setFill] ;
            
            CGContextBeginPath(context) ;
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
            CGContextClosePath(context) ;
            CGContextFillPath(context) ;
            
            // draw the inside moving filled rounded rectangle
            radius = 0.5f * rect.size.height ;
            
            // make sure the filled rounded rectangle is not smaller than 2 times the radius
            rect.size.width *= _progress ;
            if (rect.size.width < 2 * radius)
                rect.size.width = 2 * radius ;
            
            [self.innerColor setFill] ;
            
            CGContextBeginPath(context) ;
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
            CGContextClosePath(context) ;
            CGContextFillPath(context) ;
            
            // restore the context
            CGContextRestoreGState(context) ;
            
            break;
        }
        case ETImageViewProgressStyle_Indicator:
        {
            [super drawRect:rect];
            break;
        }
            
        default:
            break;
    }
    
    
}


@end

