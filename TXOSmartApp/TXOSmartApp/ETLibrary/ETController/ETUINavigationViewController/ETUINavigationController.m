//
//  ETUINavigationController.m
//  MyTaobao
//
//  Created by GuanYuhong on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETUINavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]



@interface ETUINavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate> {
@private
    
    CGPoint startTouch;
 
    UIImageView *lastScreenShotView;
    UIView* blackMask;
    UIView* blackMaskBottom;
    
    BOOL _isPush;

}

@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;


@end

@implementation ETUINavigationController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       
        
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.enableGestureSlidingBack = YES;
//
//    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];

    recognizer.delegate = self;
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _isPush = YES;

    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    _isPush = NO;
    
    [self.screenShotsList removeLastObject];

    return [super popViewControllerAnimated:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigation delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_isPush) {
        
        __block __weak UIView* _viewRef = self.view;
        
        [[ETThread sharedInstance] enqueueInBackground:^{
            
            UIGraphicsBeginImageContextWithOptions(_viewRef.bounds.size, _viewRef.opaque, 0.0f);
            
            [_viewRef.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            [[ETThread sharedInstance]enqueueOnMainThread:^{
                
                [self.screenShotsList addObject:image];
            }];
            
        }];

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Utility Methods -

 //get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
    
}

- (void)moveViewWithX:(float)x
{
    
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Recognizer 

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.enableGestureSlidingBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            
            blackMaskBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
            blackMaskBottom.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMaskBottom];
        }
        
        self.backgroundView.hidden = NO;
              
        if (lastScreenShotView)
            [lastScreenShotView removeFromSuperview];
        
        //UIImage *lastScreenShot = [self.screenShotsList lastObject];
        UIImage* lastScreenShot = self.screenShotsList[self.screenShotsList.count-2];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];

        [self.backgroundView addSubview:lastScreenShotView];
        [self.backgroundView addSubview:blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
                [self.backgroundView removeFromSuperview];
                _backgroundView = nil;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                //self.backgroundView.hidden = YES;
                [self.backgroundView removeFromSuperview];
                _backgroundView = nil;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            //self.backgroundView.hidden = YES;
            [self.backgroundView removeFromSuperview];
            _backgroundView = nil;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}



@end
