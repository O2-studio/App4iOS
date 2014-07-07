//
//  ETUISlidingController.h
//  etaoshopping
//
//  Created by moxin.xt on 12-9-28.
//
//

#import "ETUIViewController.h"

#define ETSlidingViewUnderRightWillAppear    @"ETSlidingViewUnderRightWillAppear"
#define ETSlidingViewUnderLeftWillAppear     @"ETSlidingViewUnderLeftWillAppear"
#define ETSlidingViewTopDidAnchorLeft        @"ETSlidingViewTopDidAnchorLeft"
#define ETSlidingViewTopDidAnchorRight       @"ETSlidingViewTopDidAnchorRight"
#define ETSlidingViewTopDidReset             @"ETSlidingViewTopDidReset"
#define ETSlidingViewTopWillReset            @"ETSlidingViewTopWillReset"

typedef enum
{
    /*
     * 全屏
     */
    ETSlideController_FullWidth,
    /*
     * 固定偏移
     */
    ETSlideController_FixedRevealWidth,
    /*
     * 动态偏移
     */
    ETSlideController_VariableRevealWidth
    
} ETViewWidthLayout;


typedef enum
{
    /*
     * 左边controller
     */
    ETSlideController_Left,
    /*
     * 右边controller
     */
    ETSlideController_Right
} ETSide;

/*
 *回复 topview 的手势
 */
typedef enum
{
    ETSlideController_None = 0,
    
    /*
     * tap
     */
    ETSlideController_Tapping = 1 << 0,

    /*
     * pan
     */
    ETSlideController_Panning = 1 << 1
} ETResetStrategy;



@interface ETUISlidingController : ETUIViewController
{
    CGPoint startTouchPosition;
    BOOL topViewHasFocus;
}
/*
 * 阴影
 */
@property(nonatomic) BOOL showShadow;
/*
 * 左滑controller
 */
@property (nonatomic, strong) UIViewController *underLeftViewController;

/*
 * 右滑controller
 */
@property (nonatomic, strong) UIViewController *underRightViewController;

/*
 * 中间controller
 */
@property (nonatomic, strong) UIViewController *topViewController;

/*
 * 左边余量
 */
@property (nonatomic) CGFloat anchorLeftPeekAmount;

/*
 * 右边余量
 */
@property (nonatomic) CGFloat anchorRightPeekAmount;
/*
 * 左边剩余余量
 */
@property (nonatomic) CGFloat anchorLeftRevealAmount;
/*
 * 右边剩余余量
 */
@property (nonatomic) CGFloat anchorRightRevealAmount;

/*
 * 动画专场，是否接受用户操作
 */
@property (nonatomic) BOOL shouldAllowUserInteractionsWhenAnchored;

/*
 * 左滑展现方式
 */
@property (nonatomic) ETViewWidthLayout underLeftWidthLayout;

/*
 * 右滑展现方式
 */
@property (nonatomic) ETViewWidthLayout underRightWidthLayout;

/*
 * 左右滑的交互方式
 */
@property (nonatomic) ETResetStrategy resetStrategy;

/*
 * navigation bar的滑动手势
 */
- (UIPanGestureRecognizer *)panGesture;

/*
 * 滑动topview controller到ETSide
 */
- (void)anchorTopViewTo:(ETSide)side;

/*
 * 滑动topview controller到ETSide，动画效果
 */
- (void)anchorTopViewTo:(ETSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

/*
 * topview controller滑出屏幕
 */
- (void)anchorTopViewOffScreenTo:(ETSide)side;

/*
 * topview controller滑出屏幕 带动画
 */
- (void)anchorTopViewOffScreenTo:(ETSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

/*
 * topview controller返回到主屏幕
 */
- (void)resetTopView;
/*
 * topview controller返回到主屏幕
 */
- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete;

/*
 * topview controller部分返回主屏幕
 */
- (void)resetTopViewPartiallyTo:(ETSide)side;
/*
 * topview controller部分返回主屏幕
 */
- (void)resetTopViewPartiallyTo:(ETSide)side animation:(void(^)())animations onComplete:(void(^)())complete;
/*
 * 左边controller是否显示
 */
- (BOOL)underLeftShowing;
/*
 * 右边controller是否显示
 */
- (BOOL)underRightShowing;
/*
 * 中间controll是否显示
 */
- (BOOL)topViewIsOffScreen;

@end

