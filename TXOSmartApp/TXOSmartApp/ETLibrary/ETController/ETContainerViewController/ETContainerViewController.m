//
//  ETContainerViewController.m
//  etaoshopping
//
//  Created by moxin.xt on 12-11-2.
//
//

#import "ETContainerViewController.h"

@interface ETContainerViewController ()
{
  
}

@end

@implementation ETContainerViewController

@synthesize contentContainerView    = _contentContainerView;
@synthesize selectedIndex           = _selectedIndex;
@synthesize selectedViewController  = _selectedViewController;
@synthesize viewControllers         = _viewControllers;
@synthesize delegate                = _delegate;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setViewControllers:(NSArray *)newViewControllers
{
    NSAssert([newViewControllers count] >= 2, @"ETContainerViewController requires at least two view controllers");
    
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
		[viewController removeFromParentViewController];
	}
    
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
        [self.contentContainerView addSubview:viewController.view];
		[viewController didMoveToParentViewController:self];
	}
    

}
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)init
{
    self = [super init];
    
    if(self)
    {
        

    
    }
    
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
	_contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_contentContainerView];

	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
    
    if (self.viewControllers.count > 0) {
        self.selectedIndex = lastIndex;
    }
    

}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
	if ([self isViewLoaded] && self.view.window == nil)
	{

		_contentContainerView = nil;

	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method

- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
	NSUInteger index = [self.viewControllers indexOfObject:viewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
    else if (_selectedIndex == newSelectedIndex)
    {
        if (_selectedIndex != NSNotFound) {
        
            [self selectedIndexInvalid];
        }
    }
	else if (_selectedIndex != newSelectedIndex)
	{        
		if (_selectedIndex != NSNotFound)
		{
            [self selectedIndexWillChange];
			_fromViewController = self.selectedViewController;
		}
        
		_oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        

		if (_selectedIndex != NSNotFound)
		{
			_toViewController = self.selectedViewController;
            [self selectedIndexDidChange];
		}
        
		if (_toViewController == nil)  // don't animate
		{
			[_fromViewController.view removeFromSuperview];
		}
		else if (_fromViewController == nil)  // don't animate
		{
			_toViewController.view.frame = _contentContainerView.bounds;
			[_contentContainerView addSubview:_toViewController.view];
            
			if ([self.delegate respondsToSelector:@selector(ETContainerViewController:didSelectViewController:atIndex:)])
				[self.delegate ETContainerViewController:self didSelectViewController:_toViewController atIndex:newSelectedIndex];
		}
		else if ( animated)
		{
            [self transitionAnimationBegin];
            
			[self transitionFromViewController:_fromViewController
                              toViewController:_toViewController
                                      duration:0.2f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 [self transitionAnimationProceeding];
                 
             }
              completion:^(BOOL finished)
             {
                 [self transitionAnimationEnd];
                 
                 if ([self.delegate respondsToSelector:@selector(ETContainerViewController:didSelectViewController:atIndex:)])
                     [self.delegate ETContainerViewController:self didSelectViewController:_toViewController atIndex:newSelectedIndex];
             }];
		}
		else  // not animated
		{
			[_fromViewController.view removeFromSuperview];
            
			_toViewController.view.frame = _contentContainerView.bounds;
			[_contentContainerView addSubview:_toViewController.view];
			
			if ([self.delegate respondsToSelector:@selector(ETContainerViewController:didSelectViewController:atIndex:)])
				[self.delegate ETContainerViewController:self didSelectViewController:_toViewController atIndex:newSelectedIndex];
		}
	}
}

/**
 无效选中状态
 */
- (void)selectedIndexInvalid
{

}

/**
 index will change
 */
- (void)selectedIndexWillChange
{
}

/**
 index did change
 */
- (void)selectedIndexDidChange
{
}
/**
 切换动画开始前
 */
- (void)transitionAnimationBegin
{
}
/**
 切换动画完成
 */
- (void)transitionAnimationEnd
{
}
/**
 切换动画
 */
- (void)transitionAnimationProceeding
{
}


@end
