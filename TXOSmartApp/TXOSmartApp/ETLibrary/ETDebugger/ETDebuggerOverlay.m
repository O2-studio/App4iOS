//
//  ETDebuggerOverlay.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerOverlay.h"
#import "ETDebuggerWindow.h"




@implementation ETDebuggerOverlay


DEF_SINGLETON(ETDebuggerOverlay);

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect shortcutFrame;
	shortcutFrame.size.width = 40.0f;
	shortcutFrame.size.height = 40.0f;
	shortcutFrame.origin.x = CGRectGetMaxX(screenBound) - shortcutFrame.size.width-44;
	shortcutFrame.origin.y = CGRectGetMaxY(screenBound) - shortcutFrame.size.height - 44.0f;
    
	self = [super initWithFrame:shortcutFrame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 100.0f;
        
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfMoved:)];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfClicked:)];
        
        
        UIImageView* imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, shortcutFrame.size.width, shortcutFrame.size.height)];
        imgV.image = __IMAGE(@"debuger_logo.png");
        imgV.backgroundColor = [UIColor whiteColor];
        imgV.layer.cornerRadius = 20.0f;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [UIColor blackColor].CGColor;
        imgV.layer.borderWidth = 2.0f;
        
        [self addSubview:imgV];
        
        [self addGestureRecognizer:panGesture];
        [self addGestureRecognizer:tapGesture];
        
    }
	return self;
}

- (void)onSelfClicked:(id)sender
{
	
	[ETDebuggerOverlay sharedInstance].hidden = YES;
    [ETDebuggerWindow sharedInstance].hidden = NO;
}

- (void)onSelfMoved:(UIPanGestureRecognizer*)sender
{
    CGPoint nowPoint = [sender locationInView:self];
    nowPoint = [self convertPoint:nowPoint toWindow:[UIApplication sharedApplication].keyWindow];
    
    self.center = CGPointMake(nowPoint.x,nowPoint.y);
}

@end
