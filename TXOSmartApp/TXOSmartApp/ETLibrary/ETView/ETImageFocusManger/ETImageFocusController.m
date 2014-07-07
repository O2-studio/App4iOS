//
//  ETImageFocusController.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-6-3.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETImageFocusController.h"

static const double kDefaultOrientationAnimationDuration = 0.3;
static const double kAnimationDuration = 0.3;






@interface ETImageFocusProgressView : UIView

@end

@implementation ETImageFocusProgressView



@end


typedef enum 
{
    scrollViewType_none,
    scrollViewType_http = 1,
    scrollViewType_static = 2,
  
    
}scrollViewType;

@interface ETImageFocusController()<ETImageScrollViewDelegate,UIAlertViewDelegate>
{
    CGRect _startFrame;
    BOOL _isSavingToAlbum;
    BOOL _isAnimationViewClicked;
}

@property(nonatomic,strong)ETImageScrollView* scrollView;

@property (nonatomic, assign) UIInterfaceOrientation fromOrientation;
@property (nonatomic, assign) UIInterfaceOrientation toOrientation;
@property (nonatomic, assign) UIDeviceOrientation previousOrientation;

@property (nonatomic,assign)  scrollViewType scrollType;
@property (nonatomic,strong)  ETActivityIndicatorView* indicator;
@property (nonatomic, assign) NSInteger defaultSelectedIndex;
@property (nonatomic, copy)   NSArray* pageImages;
@property (nonatomic, copy)   NSArray* pageUrls;
@property (nonatomic, strong) UIImageView* animationImageView;
@property (nonatomic, strong) UIButton* saveButton;

@end

@implementation ETImageFocusController
{
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycles


- (id)initWithImages:(NSArray*)images defaultSelectedIndex:(NSInteger)index
{
    self =  [super init];
    
    if (self) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        self.pageImages = images;
        self.defaultSelectedIndex = index;

    }
    return self;
}
- (id)initWithImages:(NSArray *)images downloadImages:(NSArray*)urlArray defaultSelectedIndex:(NSInteger)index
{
    self =  [super init];
    
    if (self) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        self.pageImages = images;
        self.pageUrls   = urlArray;
        self.defaultSelectedIndex = index;
    }
    return self;
}

- (void) loadView {
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *window = [app keyWindow];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor blackColor];

    //create a save image button
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, window.frame.size.height - 50, 64, 40)];
    [self.saveButton setBackgroundImage:__IMAGE(@"save.png") forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
 
    //create an internal scrollview
    self.scrollView = [[ETImageScrollView alloc]initWithFrame:window.bounds withStyle:ETImageScroll_ViewPaged DefaultSelected:self.defaultSelectedIndex];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.isPageControlEnabled = YES;
    self.scrollView.imageDisplayMode = UIViewContentModeScaleAspectFill;
    self.scrollView.isZoomEnabled = YES;
    self.scrollView.delegate = self;
    
    
    //set scrollview type
    if (self.pageUrls.count > 0)
    {
        self.scrollType = scrollViewType_http;
        // create an indicator
        self.indicator = [[ETActivityIndicatorView alloc]initWithFrame:CGRectMake((window.frame.size.width - 50)/2,(window.frame.size.height - 50)/2,50,50)];
    }
    else
    {
        if (self.pageImages.count > 0) {
            self.scrollType = scrollViewType_static;
        }
    }

    //create an animationImageView
    self.animationImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.animationImageView.backgroundColor = [UIColor clearColor];
    self.animationImageView.autoresizesSubviews = YES;
    self.animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animationImageView.clipsToBounds = YES;
    self.animationImageView.userInteractionEnabled = YES;
    [self.animationImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollImageClicked:IndexNumber:)]];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add device orientation listener
    
//     [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
//   
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *window = [app keyWindow];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    

    //convert coordinates from view to window
    _startFrame = [self.focusedView convertRect:self.focusedView.bounds toView:window];
    
    self.animationImageView.image = self.focusedImage;
    self.animationImageView.frame = _startFrame;
    
    [window addSubview:self.animationImageView];
    
    //hide original imageView
    self.focusedView.hidden = YES;
    
    
    CGRect endRect = window.frame;
    [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.animationImageView.frame = endRect;
        
    } completion:^(BOOL finished) {
        
        
        if (self.scrollType == scrollViewType_http) {
         
             //load image urls
            self.scrollView.isScrollEnabled = NO;
            self.scrollView.pageUrls = self.pageUrls;

            [self.indicator startAnimating];
            [window addSubview:self.indicator];
        }
        else
        {
            //load images
            self.scrollView.pageImages = self.pageImages;
            [self.animationImageView setHidden:YES];
            
            [window addSubview:self.scrollView];
            [window addSubview:self.saveButton];
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    UIApplication *app = [UIApplication sharedApplication];
//    UIView *window = [app keyWindow];
//
//    CGRect endRect = [self.view convertRect:self.view.frame toView:window];
//
//    [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        self.animationImageView.frame = endRect;
//        
//    } completion:^(BOOL finished) {
//       
//        [self.animationImageView setHidden:YES];
//        [window addSubview:self.scrollView];
//        [window addSubview:self.saveButton];
//    }];

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.animationImageView.hidden = NO;
    [self.saveButton removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];


    [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.animationImageView.frame = _startFrame;
        
    } completion:^(BOOL finished) {
        
     
        [self.animationImageView removeFromSuperview];
        self.focusedView.hidden = NO;
        
    }];

}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    UIApplication *app = [UIApplication sharedApplication];
//    UIWindow *window = [app keyWindow];
//    
//     CGRect endRect = [self.focusedView convertRect:self.focusedView.bounds toView:window];
//    
//    [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        self.animationImageView.frame = endRect;
//        
//    } completion:^(BOOL finished) {
//        
//  
//        [self.animationImageView removeFromSuperview];
//        self.focusedView.hidden = NO;
//    }];
//
//    
//    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Orientation


- (void)orientationDidChangeNotification:(NSNotification*)nofiy
{    
    [self updateOrientationAnimated:YES];
    //[self orientationChanged:nofiy];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

-(void)onScrollImageClicked:(ETImageScrollView*)sender IndexNumber:(NSInteger)index
{
    if (!_isSavingToAlbum) {
        
        _isAnimationViewClicked = YES;

        [self.scrollView scrollToFirstPage];
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)onScrollImageLoaded:(ETImageScrollView *)sender IndexNumber:(NSInteger)index
{
    if (_isAnimationViewClicked || [self isBeingDismissed]) {
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *window = [app keyWindow];

    
    if (index == self.scrollView.currentPageIndex) {
        
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        
        [self.animationImageView setHidden:YES];
        [window addSubview:self.scrollView];
        [window addSubview:self.saveButton];
        
        self.scrollView.isScrollEnabled = YES;
    }
}

//- (void)onAnimationImageViewClicked:(id)sender
//{
//    if (!_isSavingToAlbum) {
//        
//        [self.scrollView scrollToFirstPage];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods



- (void)orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation o = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0;
    switch (o) {
        case UIDeviceOrientationLandscapeLeft: angle = 90; break;
        case UIDeviceOrientationLandscapeRight: angle = -90; break;
        case UIDeviceOrientationPortraitUpsideDown: angle = 180; break;
        default: break;
    }
    
    CGRect f = [[UIScreen mainScreen] applicationFrame];
    
    
    // Swap the frame height and width if necessary
    if (UIDeviceOrientationIsLandscape(o)) {
        CGFloat t;
        t = f.size.width;
        f.size.width = f.size.height;
        f.size.height = t;
    }
    
    CGAffineTransform previousTransform = self.view.layer.affineTransform;
    CGAffineTransform newTransform = CGAffineTransformMakeRotation((CGFloat)(angle * M_PI / 180.0));
    
    // Reset the transform so we can set the size
    self.view.layer.affineTransform = CGAffineTransformIdentity;
    
    self.view.frame = (CGRect){ { 0, 0 }, f.size};
    
    // Revert to the previous transform for correct animation
    self.view.layer.affineTransform = previousTransform;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // Set the new transform
    self.view.layer.affineTransform = newTransform;
    
    // Fix the view origin
    self.view.frame = (CGRect){ { f.origin.x, f.origin.y },self.view.frame.size};
    [UIView commitAnimations];
}


- (void)updateOrientationAnimated:(BOOL)animated
{
    CGAffineTransform transform;
    NSTimeInterval duration = kDefaultOrientationAnimationDuration;
  
//    CGSize imageSize = [self.scrollView imageAtIndexPage:self.scrollView.currentPageIndex].size;
//    CGSize windowSize = self.view.bounds.size;
    CGRect frame;

    
    if([UIDevice currentDevice].orientation == self.previousOrientation)
        return;
    
    if((UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsLandscape(self.previousOrientation))
       || (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsPortrait(self.previousOrientation)))
    {
        duration *= 2;
    }
    
    if(([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait))
    {
        transform = CGAffineTransformIdentity;
    }
    else
    {
        switch ([UIDevice currentDevice].orientation)
        {
            case UIInterfaceOrientationLandscapeLeft:
                              
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait)
                {
                   
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                else
                {
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                    frame = CGRectMake(0, 0, 100, 100);
                }
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait)
                {
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                else
                {
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                break;
                
            case UIInterfaceOrientationPortrait:
                transform = CGAffineTransformIdentity;
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
                
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationUnknown:
                return;
        }
    }
    
    if(animated)
    {
   
        //frame = self.scrollView.frame;//
        //self.scrollView.frame = frame;

        self.scrollView.frame = frame;
        [UIView animateWithDuration:duration
                         animations:^{
                             self.scrollView.transform = transform;
                             
                         }];
    }
    else
    {
        self.scrollView.transform = transform;
    }
    self.previousOrientation = [UIDevice currentDevice].orientation;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch(toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortraitUpsideDown;
            
        case UIInterfaceOrientationLandscapeLeft:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeLeft;
            
        case UIInterfaceOrientationLandscapeRight:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeRight;
    }
}

- (void)savePhoto:(id)sender
{
    int index = self.scrollView.currentPageIndex;
    
    UIImage* image = [self.scrollView imageAtIndexPage:index];
    
    if (image && !_isSavingToAlbum ) {
        
        _isSavingToAlbum = YES;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
 
    NSString *message;
    
    
    if (!error) {
        message = NSLocalizedString(@"保存成功", @"");
    } else {
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       _isSavingToAlbum = NO;
}

@end
