//
//  ETImageScrollView.m
//  etaoLocal
//
//  Created by moxin on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETImageScrollView.h"
#import "ETImageScrollChildView.h"


const int   PAGECONTROL_HEIGHT        = 30;
const int   TIMER_INTERVAL            = 4;

@interface ETImageScrollView()<UIScrollViewDelegate,ETImageScrollChildView>
{    
    int         _type;
    NSInteger   _defaultSelectedIndex;
    
    float   _selfWidth;
    float   _selfHeight;
    CGPoint _selfOriginalPt;
    
    CGPoint _scrollViewContentStartPt;
    float   _scrollViewWidth;
    float   _scrollViewHeight;
    
    
    float   _imgWidth;
    float   _imgHeight;
    int     _imgCount;
    
    ETImageScrollViewType _style;
}

@property (nonatomic,strong) NSTimer*        timer;
//pageViews引用着每一个ETImageView
@property (nonatomic,strong) NSMutableArray* pageViews;
@property (nonatomic,strong) UIPageControl*  pageControl;
@property (nonatomic,strong) UIScrollView*   scrollView;


// method declaration:
- (void)flipPage;
- (void)loadAllVisiblePages;
- (void)updatePageControl;
- (void)notifyDataSourceChanged;
- (void)notifyDataUrlChanged;
- (void)resetPageViews;

@end

@implementation ETImageScrollView

@synthesize imageCount              = _imgCount;
@synthesize currentPageIndex        = _currentPageIndex;
@synthesize timer                   = _timer;
@synthesize isTimerControlEnabled   = _isTimerControlEnabled;
@synthesize isPageControlEnabled    = _isPageControlEnabled;
@synthesize isScrollEnabled         = _isScrollEnabled;
@synthesize delegate                = _delegate;
@synthesize scrollView              = _scrollView;
@synthesize pageControl             = _pageControl;
@synthesize pageImages              = _pageImages;
@synthesize pageUrls                = _pageUrls;
@synthesize pageViews               = _pageViews;
@synthesize backgroundImage         = _backgroundImage;
@synthesize backgroundColor         = _backgroundColor;
@synthesize imageCachePolicy        = _imageCachePolicy;
@synthesize isZoomEnabled           = _isZoomEnabled;


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
//    _scrollViewWidth  = frame.size.width;
//    _scrollViewHeight = frame.size.height;
//    
//    _selfOriginalPt.x = frame.origin.x;
//    _selfOriginalPt.y = frame.origin.y;
//    _selfWidth = frame.size.width;
//    _selfHeight = frame.size.height;
//    
//    [self resetPageViews];
//    [self notifyDataSourceChanged];
}

- (void)setIsZoomEnabled:(BOOL)isZoomEnabled
{
    _isZoomEnabled = isZoomEnabled;
}

- (void)setAlpha:(CGFloat)alpha
{
    self.scrollView.alpha = alpha;
}
// handle content change
// handle count change

-(void)setPageUrls:(NSArray *)pageUrls
{
    if(pageUrls == nil)
        return;
    
    if(pageUrls.count == 0)
        return;
    
    if(_pageUrls)
        _pageUrls = nil;
    
    // handle count change;
    if(_imgCount != pageUrls.count)
    {
        _imgCount = pageUrls.count;
        _pageUrls = [pageUrls copy];
        
        [self resetPageViews];
        
        [self notifyDataSourceChanged];
    }
    
    // handle content change;
    else
    {
        _imgCount = pageUrls.count;
        _pageUrls = [pageUrls copy];
    }
    
    [self notifyDataUrlChanged];
    
}


-(void)setPageImages:(NSArray *)pageImages
{
    NSLog(@"[%@]-->setPageImages",self.class);
    
    _imgCount = pageImages.count;
    
    if(_pageImages)
        _pageImages = nil;
    
    if(pageImages)
    {
        // update images
        _pageImages = [pageImages copy];
        
        // clear page views
        [self resetPageViews];
        
        // show data
        [self notifyDataSourceChanged];
    }
    
}
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView* imgView = [[UIImageView alloc]initWithImage:backgroundImage];
    [imgView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [imgView setClipsToBounds:YES];
    
    [self insertSubview:imgView atIndex:0];
    
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.scrollView.backgroundColor = backgroundColor;
    
}


// Moxin: 注意：
// 指定了target为self，意味着，当这个view要被回收时，timer一定要停止
// 否则会被timer一直引用着，dealloc不会被调用
// 回收与否取决于实际情况

-(void)setIsTimerControlEnabled:(BOOL)isTimerControlEnabled
{
    _isTimerControlEnabled = isTimerControlEnabled;
    
    if(_isTimerControlEnabled)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(flipPage)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    else
    {
        if(_timer && [_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
    
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled
{
    _isScrollEnabled = isScrollEnabled;
    
    if(isScrollEnabled)
        [self.scrollView setScrollEnabled:YES];
    else
        [self.scrollView setScrollEnabled:NO];
}


//////////////////////////////////////////////////
#pragma mark - getters

-(NSMutableArray*)pageViews
{
    if(!_pageViews)
    {
        _pageViews = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < _imgCount; ++i)
        {
            [_pageViews addObject:[NSNull null]];
        }
    }
    
    return _pageViews;
}

- (int)imageCount
{
    if(_pageViews)
        return _pageViews.count;
    else
        return 0;
}

-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

-(UIPageControl*)pageControl
{
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, _scrollViewWidth, PAGECONTROL_HEIGHT)];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        
        // allign scrollview's bottom
        // center in the middle
        [_pageControl setCenter:CGPointMake(self.scrollView.center.x, self.scrollView.frame.size.height - (PAGECONTROL_HEIGHT/2))];
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (CGFloat)alpha
{
    return self.scrollView.alpha;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withStyle:ETImageScroll_ViewPaged];
}

- (id)initWithFrame:(CGRect)frame withStyle : (ETImageScrollViewType) style
{
    return [self initWithFrame:frame withStyle:style DefaultSelected:0];
}

- (id)initWithFrame:(CGRect)frame withStyle : (ETImageScrollViewType) style DefaultSelected:(NSInteger)index
{

    _defaultSelectedIndex = index;
    _style = style;
    
    _scrollViewWidth  = frame.size.width;
    _scrollViewHeight = frame.size.height;
    
    _selfOriginalPt.x = frame.origin.x;
    _selfOriginalPt.y = frame.origin.y;
    _selfWidth = frame.size.width;
    _selfHeight = frame.size.height;
    
    self=  [super initWithFrame:frame];
    
    if (self)
    {
        [self.scrollView setContentSize:CGSizeZero];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setBounces:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        
        //set default image cache policy
        self.imageCachePolicy = ETImageDownloadCacheInFile;
    }
    
    switch (style)
    {
        case ETImageScroll_ViewPaged:
        {
            [self.scrollView setPagingEnabled:YES];
            [self.scrollView setClipsToBounds:YES];
            
            break;
        }
            
        case ETImageScroll_ViewPeekPaged:
        {
            [self.scrollView setPagingEnabled:YES];
            [self.scrollView setClipsToBounds:NO];
            
            break;
        }
                        
        case ETIMageScroll_ViewFadeInOut:
        {
            UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewSwiped:)];
            swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            
            UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewSwiped:)];
            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
            
            
            [self.scrollView addGestureRecognizer:swipeLeft];
            [self.scrollView addGestureRecognizer:swipeRight];
            
            break;
        }
            
        default:
            break;
    }
    
    return self;

}

- (void)dealloc
{
    NSLog(@"[ETImageScrollView]--> dealloc");
    
    
    if(_timer && [_timer isValid] )
    {
        [_timer invalidate];
        _timer = nil;
    }

    _pageControl        = nil;
    _pageViews          = nil;
    _pageImages         = nil;
    _pageUrls           = nil;
    _scrollView         = nil;
    _backgroundImage    = nil;
    _backgroundColor    = nil;

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - scrollview's protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updatePageControl];
    
    //handle code
    if([self.delegate respondsToSelector:@selector(onScrollDidScroll:)])
    {
        [self.delegate onScrollDidScroll:self];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // stop timer when dragging begins
    if(_isTimerControlEnabled)
    {
        //NSLog(@"begin dragging");
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if(_isTimerControlEnabled)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(flipPage)
                                                userInfo:nil
                                                 repeats:YES];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - childeview's deleage


- (void)childViewDidSingleTap:(ETImageScrollChildView *)childView
{
   
    if (childView.tag != _currentPageIndex)
            return;
    
    //handle code
    if([self.delegate respondsToSelector:@selector(onScrollImageClicked:IndexNumber:)])
    {
        [self.delegate onScrollImageClicked:self IndexNumber:_currentPageIndex];
    }
}
- (void)childViewDidDoubleTap:(ETImageScrollChildView *)childView
{

}
- (void)childViewDidTwoFingerTap:(ETImageScrollChildView *)childView
{

}
- (void)childViewDidDoubleTwoFingerTap:(ETImageScrollChildView *)childView
{

}

- (void)childView:(ETImageScrollChildView *)childView DidLoadImagewithUrl:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(onScrollImageLoaded:IndexNumber:)])
    {
        [self.delegate onScrollImageLoaded:self IndexNumber:childView.tag];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public interface

//get image
- (UIImage*)imageAtIndexPage:(NSInteger)index;
{
    if (index > self.imageCount) {
        return nil;
    }
    
    if (index > self.pageViews.count) {
        return nil;
    }
    
    ETImageScrollChildView* childView = self.pageViews[index];
    
    return childView.imageView.image;
}

//get imageView
- (ETImageView*)imageViewAtIndexPage:(NSInteger)index
{
    if(index > self.imageCount)
        return nil;
   
    if (index > self.pageViews.count) {
        return nil;
    }
    
    ETImageScrollChildView* childView = self.pageViews[index];
    return childView.imageView;
}

- (void)scrollToFirstPage
{
    if(_isTimerControlEnabled)
    {
        [self.timer invalidate];
        _timer = nil; 
    }
    
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)scrollToLastPage
{
    if(_isTimerControlEnabled)
    {
        [self.timer invalidate];
        _timer = nil;
    }
    
}

// scroll to certain page
- (void)scrollToPage:(NSInteger)index Animate:(BOOL)animate
{
    if(index >= [self imageCount])
        return;
    
    if(_isTimerControlEnabled)
    {
        [self.timer invalidate];
        _timer = nil;
    }
    
    [self scrollToFirstPage];
    
    if(_style == ETImageScroll_ViewPaged || _style == ETImageScroll_ViewPeekPaged)
    {
    
        CGRect oldRect = self.scrollView.bounds;
        
        CGRect newRect = CGRectMake(index*oldRect.size.width, 0, oldRect.size.width, oldRect.size.height);
        
        
        [self.scrollView scrollRectToVisible:newRect animated:animate];
    }
    
    [self updatePageControl];
}

- (void)clearImageArray
{    
    if(_isTimerControlEnabled)
    {
        [self.timer invalidate];
        _timer = nil;
    }
    
    if(_isPageControlEnabled)
    {
        [self.pageControl setCurrentPage:0];
        [self.pageControl setNumberOfPages:0];
    }
    
     _imgCount = 0;
    
    [self.scrollView setContentSize:CGSizeZero];
    [self.pageViews removeAllObjects];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

// there are two objects point to the ETImageView:
// one is pageViews;
// the other is scrollview
- (void)resetPageViews
{
    NSLog(@"[%@]-->resetPageViews",[self class]);
    
    // let the scrollview release the ETImageView
    for(int i=0; i<_pageViews.count;i++)
    {
        if([_pageViews objectAtIndex:i] != [NSNull null])
            [ [_pageViews objectAtIndex:i] removeFromSuperview];
    }
    
    
    // let the pageViews release the ETImageView
    [self.pageViews removeAllObjects];
    
    // refill the array
    for (NSInteger i = 0; i < _imgCount; i++)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
}

- (void)notifyDataUrlChanged
{
    if(_pageViews)
    {        
        for(int i =0 ;i<_imgCount;i++)
        {

            ETImageScrollChildView* childView = [self.pageViews objectAtIndex:i];
            
            id url = [self.pageUrls objectAtIndex:i];
            
            if([url isKindOfClass:[NSString class]])
            {
                NSString* urlString = (NSString*)url;
                [childView downloadImage:[NSURL URLWithString:urlString] CachePolicy:self.imageCachePolicy];
            }
            
            if([url isKindOfClass:[NSURL class]])
            {
                NSURL* urlString = url;
                [childView downloadImage:urlString CachePolicy:self.imageCachePolicy];
            }
          

        }

    }
    
}

- (void)notifyDataSourceChanged
{
    [self loadAllVisiblePages];
}


- (void)loadAllVisiblePages
{
    NSLog(@"[ETImageScrollView]-->loadAllVisablePages");
    
    // stop the timer
    if(_isTimerControlEnabled)
    {
        [self.timer invalidate];
        _timer = nil;
    }

    if(_style == ETImageScroll_ViewPaged)
    {
        [self.scrollView setFrame:CGRectMake(0, 0, _scrollViewWidth, _scrollViewHeight)];
        // change the content size
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentSize = CGSizeMake(_imgCount*_scrollViewWidth, _scrollViewHeight);
    
    }
    
    //有余边的scrollview
    if(_style == ETImageScroll_ViewPeekPaged)
    {
        // change the frame of scrollview
        // narrow the scrollview
        [self.scrollView setFrame:CGRectMake(10, 0, _scrollViewWidth-20, _scrollViewHeight)];
        // change the content size
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentSize = CGSizeMake(_imgCount*_scrollViewWidth, _scrollViewHeight);
    }
    
       //这种类型scrollview的contentSize为单张图大小
    if(_style == ETIMageScroll_ViewFadeInOut)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentSize = CGSizeMake(_scrollViewWidth, _scrollViewHeight);

    }

    
    // set images
    int index = 0;
    
    for(int i = index; i<_imgCount; i++)
    {
        UIView* pageView = [self.pageViews objectAtIndex:i];
        
        if((NSNull*)pageView == [NSNull null])
        {
            //2，拿到image的Size
            UIImage* image = [self.pageImages objectAtIndex:i];
            //CGSize imgSize = image.size;
            CGRect frame = CGRectZero;
                        
            //3，计算imageView的frame
            if(_style == ETImageScroll_ViewPaged ||
               _style == ETImageScroll_ViewPeekPaged )
            {
                frame = self.scrollView.bounds;
                //imageview的宽度为scrollView的宽度
                frame.origin.x = (frame.size.width) * i;
                frame.origin.y = 0.0f;
                //1，计算origin.y
                
//                // 对于image为空或者image的高度大于scrollview的高度
//                if(imgSize.height > frame.size.height || imgSize.height == 0)
//                    frame.origin.y = 0.0f;
//                
//                // 对于image高度小于scrollview的高度
//                else
//                {
//                    frame.origin.y = (frame.size.height - imgSize.height)/2;
//                }
            }
            if(_style == ETImageScroll_ViewPeekPaged)
                frame = CGRectInset(frame, 5.0f, 0.0f);
            
            if(_style == ETIMageScroll_ViewFadeInOut)
                frame.origin.x = 0.0f;
       
  
            //1，创建imageView
            ETImageScrollChildView* childView = [[ETImageScrollChildView alloc]initWithFrame:frame];
            childView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            childView.childViewDelegate        = self;
            childView.imageView.enableProgress = YES;
            childView.imageView.progressStyle  = ETImageViewProgressStyle_Circle;
            childView.isZoomEnabled            = self.isZoomEnabled;
            childView.imageDisplayMode         = self.imageDisplayMode;
            childView.backgroundColor          = [UIColor clearColor];
            childView.tag = i;
            [childView displayImage:image];
            
            [self.scrollView addSubview:childView];
            [self.pageViews replaceObjectAtIndex:i withObject:childView];
        }
        
    }
    
    // set page controll
    if(!_isPageControlEnabled)
    {
        [self.pageControl setHidden:YES];
    }
    
    else
    {
        [self.pageControl setHidden:NO];
        [self.pageControl setNumberOfPages:_imgCount];
        [self.pageControl setCurrentPage:0];
        [self bringSubviewToFront:self.pageControl];
    }
    
    if(_style == ETImageScroll_ViewPaged)
    {
        if( _defaultSelectedIndex != 0)
        {
            _currentPageIndex = _defaultSelectedIndex;
            CGRect frameScroll = self.scrollView.frame;
            
            CGRect frame = CGRectMake(_defaultSelectedIndex*frameScroll.size.width, 0, frameScroll.size.width, frameScroll.size.height);
            
            [self.scrollView scrollRectToVisible:frame animated:NO];
        }
        
    }

    
    
    [self setNeedsDisplay];
    
    if(_isTimerControlEnabled)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(flipPage)
                                                userInfo:nil 
                                                 repeats:YES];
    }

}


- (void)flipPage
{
    // NSLog(@"FLIP PAGE");
    
    // next frame's start point:
    __block CGRect frame = self.scrollView.bounds;
    frame.origin.x = self.scrollView.contentOffset.x+_scrollViewWidth;
    frame.origin.y = 0.0f;
    
    if(_currentPageIndex >= _imgCount-1)
    {
        [UIView animateWithDuration:0.8f 
                              delay:(TIMER_INTERVAL*2.0)
                            options:UIViewAnimationOptionBeginFromCurrentState 
                         animations:^
         {     
             frame.origin.x = 0;
             frame.origin.y = 0;
             
         }
                         completion:^(BOOL finished) {
                         }];
    }
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)updatePageControl
{
    // First, determine which page is currently visible
    CGFloat pageWidth = _scrollViewWidth;
    
    //计算index
    NSInteger index = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    //int index= self.scrollView.contentOffset.x/pageWidth;
    
    // update pageController's index
    if(_isPageControlEnabled)
        self.pageControl.currentPage = index;
    
    _currentPageIndex = index;
    
    // NSLog(@"index:%d",_currentPageIndex);
}


#pragma mark - fade in out

- (void)scrollViewSwiped:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"[%@]-->scrollViewSwiped:%d",self.class,_currentPageIndex);
    
    
    if(_currentPageIndex == _imgCount-1)
    {
        //3，如果轮播完成
        _currentPageIndex = 0;
        
        [UIView animateWithDuration:0.5 delay:0.0f options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut animations:^{
            for(UIView* view in self.scrollView.subviews)
                view.alpha = 1.0f;
        } completion:nil];
        
        
    }
    
    else
    {
        
        UIView* view = [self.scrollView.subviews objectAtIndex:(_imgCount - _currentPageIndex-1)];
        
        [UIView animateWithDuration:.7f delay:0.0f options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut animations:^{
            
            //1，原来的image淡出
            view.alpha = 0.0f;
            
        } completion:^(BOOL finished)
         {
             //2，index++
             _currentPageIndex ++ ;
             
         }];
        
        
    }
}
@end
