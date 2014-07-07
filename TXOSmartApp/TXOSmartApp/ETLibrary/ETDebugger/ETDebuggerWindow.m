//
//  ETDebuggerWindow.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerWindow.h"
#import "ETDebuggerRootViewController.h"

@implementation ETDebuggerWindow

DEF_SINGLETON(ETDebuggerWindow);

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	self = [super initWithFrame:screenBound];
	if (self)
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 200;
        
		if ( [self respondsToSelector:@selector(setRootViewController:)] )
		{
			self.rootViewController = [ETDebuggerRootViewController sharedInstance];
		}
		else
		{
			[self addSubview:[ETDebuggerRootViewController sharedInstance].view];
		}
	}
	return self;
}

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	
	if ( self.hidden )
	{
		[[ETDebuggerRootViewController sharedInstance] viewWillDisappear:NO];
		[[ETDebuggerRootViewController sharedInstance] viewDidDisappear:NO];
	}
	else
	{
		[[ETDebuggerRootViewController sharedInstance] viewWillAppear:NO];
		[[ETDebuggerRootViewController sharedInstance] viewDidAppear:NO];
	}
}

@end
