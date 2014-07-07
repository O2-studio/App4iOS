//
//  ETUISlidingController.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-28.
//
//

#import "ETUISlidingController.h"
#import "UIImage+ImageWithUIView.h"
#import "ETUIViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////


@interface ETUISlidingController ()<UIGestureRecognizerDelegate>
{

}

@property (nonatomic, strong) UIView *topViewSnapshot;
@property (nonatomic) CGFloat initialTouchPositionX;
@property (nonatomic) CGFloat initialHoizontalCenter;
@property (nonatomic) CGFloat initialHorizontalOriginX;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *resetTapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer* resetSwipeGestureLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer* resetSwipeGestureRight;
@property (nonatomic, unsafe_unretained) BOOL underLeftShowing;
@property (nonatomic, unsafe_unretained) BOOL underRightShowing;
@property (nonatomic, unsafe_unretained) BOOL topViewIsOffScreen;
@property (nonatomic,assign) CGFloat partiallyResetedCenter;

- (NSUInteger)autoResizeToFillScreen;
- (UIView *)topView;
- (UIView *)underLeftView;
- (UIView *)underRightView;
- (void)adjustLayout;
- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter;
- (void)addTopViewSnapshot;
- (void)removeTopViewSnapshot;
/*
 * 右边controller中点
 */
- (CGFloat)anchorRightTopViewCenter;
/*
 * 左边controller中点
 */
- (CGFloat)anchorLeftTopViewCenter;
/*
 * controller宽度/2
 */
- (CGFloat)resettedCenter;
- (CGFloat)screenWidth;
- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation;
- (void)underLeftWillAppear;
- (void)underRightWillAppear;
- (void)topDidReset;
- (BOOL)topViewHasFocus;
- (void)updateUnderLeftLayout;
- (void)updateUnderRightLayout;

@end

@implementation ETUISlidingController

@synthesize initialHorizontalOriginX    = _initialHorizontalOriginX;
@synthesize topViewController           = _topViewController;
@synthesize underLeftViewController     = _underLeftViewController;
@synthesize underRightViewController    = _underRightViewController;
@synthesize anchorLeftPeekAmount        = _anchorLeftPeekAmount;
@synthesize anchorLeftRevealAmount      = _anchorLeftRevealAmount;
@synthesize anchorRightRevealAmount     = _anchorRightRevealAmount;
@synthesize anchorRightPeekAmount       = _anchorRightPeekAmount;
@synthesize resetStrategy               = _resetStrategy;
@synthesize underLeftWidthLayout        = _underLeftWidthLayout;
@synthesize underRightWidthLayout       = _underRightWidthLayout;
@synthesize shouldAllowUserInteractionsWhenAnchored = _shouldAllowUserInteractionsWhenAnchored;
@synthesize partiallyResetedCenter = _partiallyResetedCenter;

// category properties
@synthesize topViewSnapshot;
@synthesize initialTouchPositionX;
@synthesize initialHoizontalCenter;
@synthesize panGesture = _panGesture;
@synthesize resetTapGesture = _resetTapGesture;
@synthesize resetSwipeGestureLeft = _resetSwipeGestureLeft;
@synthesize resetSwipeGestureRight = _resetSwipeGestureRight;
@synthesize underLeftShowing   = _underLeftShowing;
@synthesize underRightShowing  = _underRightShowing;
@synthesize topViewIsOffScreen = _topViewIsOffScreen;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setTopViewController:(ETUIViewController *)theTopViewController
{
    [self removeTopViewSnapshot];
    [_topViewController.view removeFromSuperview];
    [_topViewController willMoveToParentViewController:nil];
    [_topViewController removeFromParentViewController];
    
    _topViewController = theTopViewController;
    
    [self addChildViewController:self.topViewController];
    [self.topViewController didMoveToParentViewController:self];
    
    [_topViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
    [_topViewController.view setFrame:self.contentView.bounds];

    
    if (self.showShadow) {
    
        //self.topViewController.view.layer.masksToBounds = YES;
        //self.topViewController.view.layer.cornerRadius  = 10.0f;

        
//        ((ETUINavigationController*)self.topViewController).topViewController.view.layer.borderWidth = 5.0f;
//        ((ETUINavigationController*)self.topViewController).topViewController.view.layer.borderColor = [UIColor orangeColor].CGColor;
       self.topViewController.view.layer.shadowOpacity = self.showShadow ? 0.5f : 0.0f;
       self.topViewController.view.layer.shadowOffset = CGSizeZero;
       self.topViewController.view.layer.shadowRadius = 10.0f;
       self.topViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topViewController.view.bounds].CGPath;
        
        
      
        //self.topViewController.view.layer.delegate = self;
    }
    
    [self.contentView addSubview:_topViewController.view];
}



- (void)setUnderLeftViewController:(ETUIViewController *)theUnderLeftViewController
{
    [_underLeftViewController.view removeFromSuperview];
    [_underLeftViewController willMoveToParentViewController:nil];
    [_underLeftViewController removeFromParentViewController];
    
    _underLeftViewController = theUnderLeftViewController;
    
    if (_underLeftViewController) {
        [self addChildViewController:self.underLeftViewController];
        [self.underLeftViewController didMoveToParentViewController:self];
        
        [self updateUnderLeftLayout];
        
        [self.contentView insertSubview:_underLeftViewController.view atIndex:0];
    }
}

- (void)setUnderRightViewController:(ETUIViewController *)theUnderRightViewController
{
    [_underRightViewController.view removeFromSuperview];
    [_underRightViewController willMoveToParentViewController:nil];
    [_underRightViewController removeFromParentViewController];
    
    _underRightViewController = theUnderRightViewController;
    
    if (_underRightViewController) {
        [self addChildViewController:self.underRightViewController];
        [self.underRightViewController didMoveToParentViewController:self];
        
        [self updateUnderRightLayout];
        
        [self.contentView insertSubview:_underRightViewController.view atIndex:0];
    }
}

- (void)setUnderLeftWidthLayout:(ETViewWidthLayout)underLeftWidthLayout
{
    if (underLeftWidthLayout == ETSlideController_VariableRevealWidth && self.anchorRightPeekAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightPeekAmount must be set"];
    }
    else if (underLeftWidthLayout == ETSlideController_FixedRevealWidth && self.anchorRightRevealAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightRevealAmount must be set"];
    }
    
    _underLeftWidthLayout = underLeftWidthLayout;
}

- (void)setUnderRightWidthLayout:(ETViewWidthLayout)underRightWidthLayout
{
    if (underRightWidthLayout == ETSlideController_VariableRevealWidth && self.anchorLeftPeekAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftPeekAmount must be set"];
    }
    else if (underRightWidthLayout == ETSlideController_FixedRevealWidth && self.anchorLeftRevealAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftRevealAmount must be set"];
    }
    
    _underRightWidthLayout = underRightWidthLayout;
}

- (void)setResetStrategy:(ETResetStrategy)theResetStrategy
{
    _resetStrategy = theResetStrategy;
    
    if (_resetStrategy & ETSlideController_Tapping)
    {
        self.resetTapGesture.enabled = YES;
        self.resetSwipeGestureRight.enabled = YES;
        self.resetSwipeGestureLeft.enabled = YES;
    }
    else
    {
        self.resetTapGesture.enabled = NO;
        self.resetSwipeGestureRight.enabled = NO;
        self.resetSwipeGestureLeft.enabled = NO;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)dealloc
{
    _topViewController = nil;
    _underRightViewController = nil;
    _underLeftViewController = nil;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.shouldAllowUserInteractionsWhenAnchored = NO;
    self.resetSwipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(resetTopView)];
    self.resetSwipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    self.resetSwipeGestureLeft.delegate = self;
    
    self.resetSwipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(resetTopView)];
    self.resetSwipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    self.resetSwipeGestureRight.delegate = self;
    
    self.resetTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTopView)];
    _panGesture          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopViewHorizontalCenterWithRecognizer:)];
    self.resetTapGesture.delegate = self;
   
    self.resetSwipeGestureRight.enabled = NO;
    self.resetSwipeGestureLeft.enabled = NO;
    self.resetTapGesture.enabled = NO;
    self.resetStrategy = ETSlideController_Tapping | ETSlideController_Panning;
    
    //滑屏或点击
    self.topViewSnapshot = [[UIView alloc] initWithFrame:self.topView.bounds];
    [self.topViewSnapshot setAutoresizingMask:self.autoResizeToFillScreen];
    [self.topViewSnapshot addGestureRecognizer:self.resetTapGesture];
    [self.topViewSnapshot addGestureRecognizer:self.resetSwipeGestureLeft];
    [self.topViewSnapshot addGestureRecognizer:self.resetSwipeGestureRight];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[%@]-->viewWillAppear",self.class);
    
    [super viewWillAppear:animated];
    

//    if (self.showShadow) {
//        
//        self.etContentView.layer.borderWidth = 10.0f;
//        self.etContentView.layer.borderColor = [UIColor orangeColor].CGColor;
//        self.etContentView.layer.shadowOpacity = self.showShadow ? 0.5f : 0.0f;
//        self.etContentView.layer.shadowOffset = CGSizeZero;
//        self.etContentView.layer.shadowRadius = 10.0f;
//        self.etContentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.etContentView.bounds].CGPath;
//    }
    [self adjustLayout];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public
/*
 * navigation bar的滑动手势
 */
- (UIPanGestureRecognizer *)panGesture
{
    return _panGesture;
}

- (UITapGestureRecognizer*)resetTapGesture
{
    return _resetTapGesture;
}

/*
 * 滑动controller到ETSide
 */
- (void)anchorTopViewTo:(ETSide)side
{
    [self anchorTopViewTo:side animations:nil onComplete:nil];

}

/*
 * 滑动controller到ETSide，动画效果
 */
- (void)anchorTopViewTo:(ETSide)side animations:(void(^)())animations onComplete:(void(^)())complete
{
    
    //1，拿到新的center
    CGFloat newCenter = self.topView.center.x;
    
    //2，计算topview的新center
    
    //topview向左滑
    if (side == ETSlideController_Left)
    {
        newCenter = self.anchorLeftTopViewCenter;
        
        //notify child
        [self onTopViewControllerWillAnchorLeft];
    }
    
    //topView向右滑
    else if (side == ETSlideController_Right)
    {
        newCenter = self.anchorRightTopViewCenter;
        
        //notify child
        [self onTopViewControllerWillAnchorRight];
    }
    
    //3，改变center
    [self topViewHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.2f animations:
     ^{
        if (animations)
        {
            animations();
        }
         
         //改变center
        [self updateTopViewHorizontalCenter:newCenter];
         
               
    }
    completion:^(BOOL finished)
    {
        if (_resetStrategy & ETSlideController_Panning)
        {
            self.panGesture.enabled = YES;
        }
        else
        {
            self.panGesture.enabled = NO;
        }
        if (complete)
        {
            complete();
        }
        _topViewIsOffScreen = NO;
        
        [self addTopViewSnapshot];
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            NSString *key = (side == ETSlideController_Left) ? ETSlidingViewTopDidAnchorLeft : ETSlidingViewTopDidAnchorRight;
           
                           // 通知出去
                           [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
        });
    }];


}

/*
 * 主controller滑出
 */
- (void)anchorTopViewOffScreenTo:(ETSide)side
{
    [self anchorTopViewOffScreenTo:side animations:nil onComplete:nil];
}

/*
 * 主controller滑出，带动画
 */
- (void)anchorTopViewOffScreenTo:(ETSide)side animations:(void(^)())animations onComplete:(void(^)())complete
{

    CGFloat newCenter = self.topView.center.x;
    
    if (side == ETSlideController_Left)
    {
        newCenter = -self.resettedCenter;
    }
    else if (side == ETSlideController_Right)
    {
        newCenter = self.screenWidth + self.resettedCenter;
    }
    
    [self topViewHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (animations) {
            animations();
        }
        [self updateTopViewHorizontalCenter:newCenter];
    } completion:^(BOOL finished){
        if (complete) {
            complete();
        }
        
        _topViewIsOffScreen = YES;
        
        [self addTopViewSnapshot];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *key = (side == ETSlideController_Left) ? ETSlidingViewTopDidAnchorLeft : ETSlidingViewTopDidAnchorRight;
            [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
        });
    }];


}

/*
 * 重新设置top controller
 */
- (void)resetTopView
{
    [self onTopViewControllerWillReset];
    
    [self resetTopViewWithAnimations:nil onComplete:nil];
    

}
/*
 * 返回主controller，带动画
 */
- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete
{

    [self topViewHorizontalCenterWillChange:self.resettedCenter];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
        
        if (animations)
        {
            animations();
        }
        [self updateTopViewHorizontalCenter:self.resettedCenter];


    } completion:^(BOOL finished)
    {
        if (complete)
        {
            complete();
        }
        
        [self topViewHorizontalCenterDidChange:self.resettedCenter];

    } ];
}

/*
 * topview controller部分返回主屏幕
 */
- (void)resetTopViewPartiallyTo:(ETSide)side
{
    [self resetTopViewPartiallyTo:side animation:nil onComplete:nil];
}
/*
 * topview controller部分返回主屏幕
 */
- (void)resetTopViewPartiallyTo:(ETSide)side animation:(void(^)())animations onComplete:(void(^)())complete
{
    if(side == ETSlideController_Right)
    {
        self.partiallyResetedCenter = self.topView.center.x + self.anchorRightPeekAmount;
    }
    
    if(side == ETSlideController_Left)
    {
        self.partiallyResetedCenter = self.topView.center.x - self.anchorLeftPeekAmount;
    }
    
    [self topViewHorizontalCenterWillChange:self.partiallyResetedCenter];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
        
        if (animations)
        {
            animations();
        }
        [self updateTopViewHorizontalCenter:self.partiallyResetedCenter];
        
        
    } completion:^(BOOL finished)
     {
         if (complete)
         {
             complete();
         }
         
         [self topViewHorizontalCenterDidChange:self.partiallyResetedCenter];
         
     } ];

}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private


- (NSUInteger)autoResizeToFillScreen
{
    return (UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin);

}
- (UIView *)topView
{
    return self.topViewController.view;
}
- (UIView *)underLeftView
{
    return self.underLeftViewController.view;

}
- (UIView *)underRightView
{
    return self.underRightViewController.view;

}
- (void)adjustLayout
{
    self.topViewSnapshot.frame = self.topView.bounds;
    
    if ([self underRightShowing] && ![self topViewIsOffScreen])
    {
        [self updateUnderRightLayout];
        [self updateTopViewHorizontalCenter:self.anchorLeftTopViewCenter];
    }
    else if ([self underRightShowing] && [self topViewIsOffScreen])
    {
        [self updateUnderRightLayout];
        [self updateTopViewHorizontalCenter:-self.resettedCenter];
    }
    else if ([self underLeftShowing] && ![self topViewIsOffScreen])
    {
        [self updateUnderLeftLayout];
        [self updateTopViewHorizontalCenter:self.anchorRightTopViewCenter];
    }
    else if ([self underLeftShowing] && [self topViewIsOffScreen])
    {
        [self updateUnderLeftLayout];
        [self updateTopViewHorizontalCenter:self.screenWidth + self.resettedCenter];
    }


}
- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint currentTouchPoint     = [recognizer locationInView:self.contentView];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.initialTouchPositionX = currentTouchPositionX;
        self.initialHoizontalCenter = self.topView.center.x;
        self.initialHorizontalOriginX = self.topView.frame.origin.x;
        
        //notify child
        [self onTopViewControllerPanned:recognizer];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat panAmount = self.initialTouchPositionX - currentTouchPositionX;
        CGFloat newCenterPosition = self.initialHoizontalCenter - panAmount;
        
        if ((newCenterPosition < self.resettedCenter && self.anchorLeftTopViewCenter == NSNotFound) || (newCenterPosition > self.resettedCenter && self.anchorRightTopViewCenter == NSNotFound)) {
            newCenterPosition = self.resettedCenter;
        }
        
        [self topViewHorizontalCenterWillChange:newCenterPosition];
        [self updateTopViewHorizontalCenter:newCenterPosition];
        [self topViewHorizontalCenterDidChange:newCenterPosition];
        
        self.initialHorizontalOriginX = self.topView.frame.origin.x;
        
        //notify child
        [self onTopViewControllerPanned:recognizer];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint currentVelocityPoint = [recognizer velocityInView:self.contentView];
        CGFloat currentVelocityX     = currentVelocityPoint.x;
        
        if ([self underLeftShowing] && abs(currentVelocityX) > 100)
        {
            [self anchorTopViewTo:ETSlideController_Right];
        }
        else if ([self underRightShowing] && abs(currentVelocityX) > 100)
        {
            [self anchorTopViewTo:ETSlideController_Left];
        }
        else if([self underLeftShowing] && self.initialHorizontalOriginX > self.topView.frame.size.width/2)
        {
             [self anchorTopViewTo:ETSlideController_Right];
        }
        else if([self underRightShowing] && abs(self.initialHorizontalOriginX) > self.topView.frame.size.width/2)
        {
            [self anchorTopViewTo:ETSlideController_Left];
        }
        else
        {
            [self resetTopView];
        }
        
        //notify child
        [self onTopViewControllerPanned:recognizer];
    }

}
- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topView.center;
    center.x = newHorizontalCenter;
    
    self.topView.layer.position = center;
    
}
- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topView.center;
    
    //topview向右滑
    if (center.x <= self.resettedCenter && newHorizontalCenter > self.resettedCenter)
    {
        [self underLeftWillAppear];
    }
    
    //topview向左滑
    else if (center.x >= self.resettedCenter && newHorizontalCenter < self.resettedCenter)
    {
        [self underRightWillAppear];
    }

}
- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter
{
    if (newHorizontalCenter == self.resettedCenter)
    {
        [self topDidReset];
    }

}
- (void)addTopViewSnapshot
{
    if (!self.topViewSnapshot.superview && !self.shouldAllowUserInteractionsWhenAnchored)
    {
        //topViewSnapshot.layer.contents = (id)[UIImage imageWithUIView:self.topView].CGImage;
        topViewSnapshot.frame = self.topView.bounds;
        self.topViewSnapshot.backgroundColor = [UIColor clearColor];
        [self.topView addSubview:self.topViewSnapshot];
    }

}
- (void)removeTopViewSnapshot
{
    if (self.topViewSnapshot.superview)
    {
        [self.topViewSnapshot removeFromSuperview];
    }

}
- (CGFloat)anchorRightTopViewCenter
{

    if (self.anchorRightPeekAmount)
    {
        return self.screenWidth + self.resettedCenter - self.anchorRightPeekAmount;
    }
    else if (self.anchorRightRevealAmount)
    {
        return self.resettedCenter + self.anchorRightRevealAmount;
    }
    else
    {
        return NSNotFound;
    }


}
- (CGFloat)anchorLeftTopViewCenter
{
    //相对于topview.center的位置
    if (self.anchorLeftPeekAmount)
    {
        return -self.resettedCenter + self.anchorLeftPeekAmount;
    }
    else if (self.anchorLeftRevealAmount)
    {
        return -self.resettedCenter + (self.screenWidth - self.anchorLeftRevealAmount);
    }
    else
    {
        return NSNotFound;
    }


}
- (CGFloat)resettedCenter
{
    return ceil(self.screenWidth / 2);

}
- (CGFloat)screenWidth
{

    return [self screenWidthForOrientation:[UIApplication sharedApplication].statusBarOrientation];

}
- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation
{

    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size.width;

}
- (void)underLeftWillAppear
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ETSlidingViewUnderLeftWillAppear object:self userInfo:nil];
    });
    
    self.underRightView.hidden = YES;
    
    //leftviewcontroller
    [self.underLeftViewController viewWillAppear:NO];
    
    //leftview
    self.underLeftView.hidden = NO;
    
    
    [self updateUnderLeftLayout];
    
    //显示标志
    _underLeftShowing  = YES;
    _underRightShowing = NO;

}
- (void)underRightWillAppear
{

    dispatch_async(dispatch_get_main_queue(),
                   ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ETSlidingViewUnderRightWillAppear object:self userInfo:nil];
    });
    
    self.underLeftView.hidden = YES;
    
    [self.underRightViewController viewWillAppear:NO];
    self.underRightView.hidden = NO;
    
    
    [self updateUnderRightLayout];
    
    _underLeftShowing  = NO;
    _underRightShowing = YES;

}
- (void)topDidReset
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ETSlidingViewTopDidReset object:self userInfo:nil];
    });
    
    //topview被重置后，取消点击手势
    [self.topView removeGestureRecognizer:self.resetTapGesture];
    //去掉snapShot浮层
    [self removeTopViewSnapshot];
    //允许滑动手势
    self.panGesture.enabled = YES;
    _underLeftShowing   = NO;
    _underRightShowing  = NO;
    _topViewIsOffScreen = NO;

}
- (BOOL)topViewHasFocus
{
    return !_underLeftShowing && !_underRightShowing && !_topViewIsOffScreen;

}
- (void)updateUnderLeftLayout
{
    
    //全屏
    if (self.underLeftWidthLayout == ETSlideController_FullWidth)
    {
        [self.underLeftView setAutoresizingMask:self.autoResizeToFillScreen];
        [self.underLeftView setFrame:self.contentView.bounds];
    }
    
    //动态peek offset
    else if (self.underLeftWidthLayout == ETSlideController_VariableRevealWidth && !self.topViewIsOffScreen)
    {
        CGRect frame = self.contentView.bounds;
        CGFloat newWidth;
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            newWidth = [UIScreen mainScreen].bounds.size.height - self.anchorRightPeekAmount;
        } else {
            newWidth = [UIScreen mainScreen].bounds.size.width - self.anchorRightPeekAmount;
        }
        
        frame.size.width = newWidth;
        
        self.underLeftView.frame = frame;
    }
    
    //静态peek offset
    else if (self.underLeftWidthLayout == ETSlideController_FixedRevealWidth)
    {
        CGRect frame = self.contentView.bounds;
        
        //宽度显示width-offset
        frame.size.width = self.anchorRightRevealAmount;
        self.underLeftView.frame = frame;
    }
    else
    {
        [NSException raise:@"Invalid Width Layout" format:@"underLeftWidthLayout must be a valid ECViewWidthLayout"];
    }


}
- (void)updateUnderRightLayout
{

    if (self.underRightWidthLayout == ETSlideController_FullWidth)
    {
        [self.underRightViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
        self.underRightView.frame = self.contentView.bounds;
    }
    
    else if (self.underRightWidthLayout == ETSlideController_VariableRevealWidth)
    {
        CGRect frame = self.contentView.bounds;
        
        CGFloat newLeftEdge;
        CGFloat newWidth;
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            newWidth = [UIScreen mainScreen].bounds.size.height;
        }
        else
        {
            newWidth = [UIScreen mainScreen].bounds.size.width;
        }
        
        if (self.topViewIsOffScreen)
        {
            newLeftEdge = 0;
        }
        else
        {
            newLeftEdge = self.anchorLeftPeekAmount;
            newWidth   -= self.anchorLeftPeekAmount;
        }
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.underRightView.frame = frame;
    }
    else if (self.underRightWidthLayout == ETSlideController_FixedRevealWidth)
    {
        CGRect frame = self.contentView.bounds;
        
        CGFloat newLeftEdge = self.screenWidth - self.anchorLeftRevealAmount;
        CGFloat newWidth = self.anchorLeftRevealAmount;
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.underRightView.frame = frame;
    }
    else
    {
        [NSException raise:@"Invalid Width Layout" format:@"underRightWidthLayout must be a valid ECViewWidthLayout"];
    }


}

/*
 * child override
 */

- (void)onTopViewControllerPanned:(UIPanGestureRecognizer*)gesture
{

}

- (void)onTopViewControllerWillReset
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ETSlidingViewTopWillReset object:nil];
}

- (void)onTopViewControllerWillAnchorLeft
{

}

- (void)onTopViewControllerWillAnchorRight
{

}



@end
