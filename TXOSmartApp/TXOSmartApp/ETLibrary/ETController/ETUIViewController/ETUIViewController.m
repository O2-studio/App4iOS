//
//  ETUIViewController.m
//  ETSDK
//
//  Created by moxin on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETUIViewController.h" 



@interface ETUIViewController ()
{

}

@property (nonatomic, strong) UIView *alertProgress;


@end

@implementation ETUIViewController


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.view.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [self.view insertSubview:_contentView atIndex:0];
    }
    
    return _contentView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadView 
{
    [super loadView];
    
    //设置navigationBar的背景
    [[UINavigationBar appearance]setBackgroundImage:[EtaoBaseConfigForUX getNavigationBarImage] forBarMetrics:UIBarMetricsDefault];

    //改变controller的背景图片
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    _isiOS7above = [UIDevice currentDevice].systemVersion.floatValue >= 7.0 ? YES:NO;
    
    if (_isiOS7above) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(id) init
{
    self = [super init];
    
    if(self)
    {        

        
    }
    
    return self;
}

- (void) viewDidLoad 
{
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{ 
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    
}
// last edited by moxin:2012/08/10
- (void)viewDidUnload 
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//- (void)willMoveToParentViewController:(UIViewController *)parent
//{
//    [super willMoveToParentViewController:parent];
//    
//    NSLog(@"[%@]-->willMoveToParentViewController",self.class);
//}
//
//- (void)didMoveToParentViewController:(UIViewController *)parent
//{
//    [super didMoveToParentViewController:parent];
//    
//    NSLog(@"[%@]-->didMoveToParentViewController",self.class);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    

}





@end
