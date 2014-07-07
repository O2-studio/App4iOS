//
//  ETUIPagingScrollView.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETUIPagingScrollView.h"
#import "ETUIPagingChildView.h"
#import "ETViewRecycler.h"


//计算边界值：
static inline NSInteger calculateBoundary(NSInteger value, NSInteger min, NSInteger max) {
    if (max < min) {
        max = min;
    }
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}


const CGFloat  kETUIPagingScrollViewDefaultPageMargin     =  0;
const NSInteger  kETUIPagingScrollViewDefaultNumberOfPage = -1;

@interface ETUIPagingScrollView()
{
    ETViewRecycler* _viewRecycler;
    BOOL _bAnimatingToNextPage;
}

@end

@implementation ETUIPagingScrollView


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.scrollView.contentSize = [self contentSizeForScrollView];
    [self layoutVisiblePages];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (BOOL)hasNextPage{
    return (self.centerPageIndex < self.numberOfPages - 1);
}

- (BOOL)hasPreviousPage{
    return self.centerPageIndex > 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initScrollView];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initScrollView];
    }
    return self;
}


- (void)initScrollView
{
    _centerPageIndex  = -1;
    _pageMargin       = kETUIPagingScrollViewDefaultPageMargin;
    _numberOfPages    = kETUIPagingScrollViewDefaultNumberOfPage;
    _viewRecycler     = [ETViewRecycler new];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate      = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollsToTop  = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                              | UIViewAutoresizingFlexibleHeight);
    

    [self addSubview:_scrollView];

    
}

- (void)dealloc
{
    _delegate = nil;
    _dataSource = nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (void)reloadData
{
    
    //0,recycle pages
    
    
    //1,check datasource
    if (![self.dataSource numberOfPagesInPagingScrollView:self]) {
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        [_viewRecycler removeAllViews];
        return; 
    }
    
    
    //2,create visible pages
    _visiblePages  = nil;
    _visiblePages  = [NSMutableSet new];
    _numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
    self.scrollView.frame       = [self frameForScrollView];
    self.scrollView.contentSize = [self contentSizeForScrollView];
    
    //3,layout child views
    [self layoutChildView];
    
//    
//    NSInteger oldCenterPageIndex = _currentPageIndex;
//    if (oldCenterPageIndex >= 0) {
//        _centerPageIndex = boundi(_centerPageIndex, 0, self.numberOfPages - 1);
//        
//        if (![self.scrollView isTracking] && ![self.scrollView isDragging]) {
//            // The content size is calculated based on the number of pages and the scroll view frame.
//            CGPoint offset = [self frameForPageAtIndex:_centerPageIndex].origin;
//            offset = [self adjustOffsetWithMargin:offset];
//            self.pagingScrollView.contentOffset = offset;
//            
//            _isKillingAnimation = YES;
//        }
//    }
    
    // Begin requesting the page information from the data source.
//    [self updateVisiblePagesShouldNotifyDelegate:NO];
    
}

- (ETUIPagingChildView*)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    if (nil == identifier) {
        return nil;
    }
    
    return (ETUIPagingChildView *)[_viewRecycler dequeueReusableViewWithIdentifier:identifier];
}

- (ETUIPagingChildView*)centerPageView
{
    for (ETUIPagingChildView* page in _visiblePages) {
        if (page.pageIndex == self.centerPageIndex) {
            return page;
        }
    }
    return nil;

}

- (void)showNextPage:(BOOL)animated
{
    if (self.hasNextPage) {
        NSInteger pageIndex = self.centerPageIndex + 1;
        [self moveToNextPage:pageIndex withAnimation:animated];
    }
}

- (void)showPrevioutsPage:(BOOL)animated
{
    if (self.hasPreviousPage) {
        NSInteger pageIndex = self.centerPageIndex - 1;
        [self moveToNextPage:pageIndex withAnimation:animated];
    }

}

- (void)centerPageAtIndex:(NSInteger)pageIndex animated:(BOOL)b
{
    CGPoint offset = [self frameForChildViewAtIndex:pageIndex].origin;
    [self.scrollView setContentOffset:offset animated:b];
    if (!b) {
        [self layoutChildView];
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self layoutChildView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  
//    if ([self.delegate respondsToSelector:_cmd]) {
//        [self.delegate scrollViewDidScroll:scrollView];
//    }
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    //_isKillingAnimation = NO;
//    
//    if (!decelerate) {
//        [self layoutChildView];
//        [self resetSurrondingPages];
//    }
//    
//    if ([self.delegate respondsToSelector:_cmd]) {
//        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
//    }
//}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    [self layoutChildView];
    [self resetSurrondingPages];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  
    [self didMoveToNextPage];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - layout child view 

- (void)layoutChildView
{
    NSRange visibleRange = [self visiblePageRange];
    
    for (ETUIPagingChildView* view in [_visiblePages copy]) {
        
        //不可见的view回收掉
        if (!NSLocationInRange(view.pageIndex, visibleRange) ){
            
            [view childViewWillBeRecycled];
            
            [_viewRecycler recycleView:view];
            [view removeFromSuperview];
            [_visiblePages removeObject:view];
            
            [view childViewDidBeRecycled];
        }
        
    }
    
    NSInteger oldCenterPageIndex = _centerPageIndex;
    
    if (self.numberOfPages > 0)
    {
        _centerPageIndex = [self centerVisiblePageIndex];

        [self centerPageDidAppear];
        
        if (![self isDisplayingChildPageAtIndex:_centerPageIndex]) {
            [self displayChildPageAtIndex:_centerPageIndex];
        }
        
        // Add missing pages.
        for (int pageIndex = visibleRange.location;pageIndex < (NSInteger)NSMaxRange(visibleRange); ++pageIndex)
        {
            if (![self isDisplayingChildPageAtIndex:pageIndex]) {
                [self displayChildPageAtIndex:pageIndex];
            }
        }
    }
    else
    {
        _centerPageIndex = -1;
    }
    
    
    //notify outside
    if (oldCenterPageIndex != _centerPageIndex) {
        
        if ([self.delegate respondsToSelector:@selector(pagingScrollViewDidChangePages:)]) {
            [self.delegate pagingScrollViewDidChangePages:self];
        }
    }
}

- (ETUIPagingChildView*)loadChildPageAtIndex:(NSInteger)index
{
    ETUIPagingChildView* view = (ETUIPagingChildView*)[self.dataSource pagingScrollView:self pageViewForIndex:index ];
    return view;
}

- (void)displayChildPageAtIndex:(NSInteger)pageIndex {
   
    [self willDisplayPageAtIndex:pageIndex];
    
    ETUIPagingChildView* pageView = [self loadChildPageAtIndex:pageIndex];
  
    CGRect frame = pageView.bounds;
    CGRect oldFrm = self.scrollView.bounds;
    
    int oriX = 0;
    int oriY = 0;
    
    
    if (self.pageMargin) {
        
        oriX = (oldFrm.size.width*pageIndex) + (oldFrm.size.width - frame.size.width - self.pageMargin*2)/2;
        oriY = (oldFrm.size.height-frame.size.height)/2;
    }
    else
    {
        oriX = (oldFrm.size.width*pageIndex) + (oldFrm.size.width - frame.size.width)/2;
        oriY = (oldFrm.size.height-frame.size.height)/2;
    }
    

    
    frame.origin.x = oriX;
    frame.origin.y = oriY;
    
    pageView.frame = frame;
    pageView.pageIndex = pageIndex;
    
    
    if (pageView) {
        
        [pageView childViewWillAppear];
        
        [self.scrollView addSubview:pageView];
        [_visiblePages addObject:pageView];
        
        [pageView childViewDidAppear];
    }
    
    [self didDisplayPageAtIndex:pageIndex];
   
}


- (void)layoutVisiblePages {
    for (ETUIPagingChildView* page in _visiblePages) {
        CGRect pageFrame = [self frameForChildViewAtIndex:page.pageIndex];
        page.frame = pageFrame;
    }
}

- (void)resetSurrondingPages
{
    for (ETUIPagingChildView* page in _visiblePages) {
    
        if (page.pageIndex != self.centerPageIndex) {
            
            //[page childViewDidDisappear];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method

- (CGRect)frameForScrollView
{
    CGRect frame = self.bounds;
    
//    frame.origin.x -= self.pageMargin;
//    frame.size.width += 2*self.pageMargin;
    
    return frame;
}
- (CGSize)contentSizeForScrollView
{
    CGRect bounds = self.scrollView.bounds;
    return CGSizeMake(bounds.size.width * self.numberOfPages, bounds.size.height);
}



- (CGRect)frameForChildViewAtIndex:(NSInteger)pageIndex {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page
    // placement. When the device is in landscape orientation, the frame will still be in
    // portrait because the pagingScrollView is the root view controller's view, so its
    // frame is in window coordinate space, which is never rotated. Its bounds, however,
    // will be in landscape because it has a rotation transform applied.
    CGRect pageFrame = self.scrollView.bounds;

    // We need to counter the extra spacing added to the paging scroll view in
    // frameForPagingScrollView:
    pageFrame.size.width -= self.pageMargin * 2;
    pageFrame.origin.x = (pageFrame.size.width * pageIndex) + self.pageMargin;
    
    return pageFrame;
}

- (NSInteger)centerVisiblePageIndex {
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGSize boundsSize = self.scrollView.bounds.size;
    

    return calculateBoundary((NSInteger)(floorf((contentOffset.x + boundsSize.width / 2) / boundsSize.width)
                              + 0.5f),
                  0, self.numberOfPages - 1);
        
   }


//当前可见的页数范围
- (NSRange)visiblePageRange {
    if (0 >= self.numberOfPages) {
        return NSMakeRange(0, 0);
    }
    
    NSInteger currentVisiblePageIndex = [self centerVisiblePageIndex];
    
    int firstVisiblePageIndex = calculateBoundary(currentVisiblePageIndex - 1, 0, self.numberOfPages - 1);
    int lastVisiblePageIndex  = calculateBoundary(currentVisiblePageIndex + 1, 0, self.numberOfPages - 1);
    
    NSRange range =  NSMakeRange(firstVisiblePageIndex, lastVisiblePageIndex - firstVisiblePageIndex + 1);
    
    NSLog(@"[%@]-->visible range:{%d,%d}",[self class],firstVisiblePageIndex,lastVisiblePageIndex);
    
    return range;
}

//当前展示页面index
- (BOOL)isDisplayingChildPageAtIndex:(NSInteger)pageIndex {
    BOOL foundPage = NO;
    for (ETUIPagingChildView* page in _visiblePages) {
        if (page.pageIndex == pageIndex) {
            foundPage = YES;
            break;
        }
    }
    
    return foundPage;
}

- (void)moveToNextPage:( NSInteger )index withAnimation:(BOOL) animated
{
    //如果正在翻页
    if (_bAnimatingToNextPage) {
        return;
    }
    
    //得到index对应page的位置
    CGPoint offset = [self frameForChildViewAtIndex:index].origin;
    
    if (animated) {
        _bAnimatingToNextPage = YES;
    }
    [self.scrollView setContentOffset:offset animated:animated];
    

}

- (void)didMoveToNextPage
{
    _bAnimatingToNextPage = NO;
    
    [self layoutChildView];
}
@end


@implementation ETUIPagingScrollView(SubclassingOverride)



- (void)willDisplayPageAtIndex:(NSInteger)index
{
    //no-op;
}

- (void)didDisplayPageAtIndex:(NSInteger)index
{

}
- (void)centerPageDidAppear
{

}

@end