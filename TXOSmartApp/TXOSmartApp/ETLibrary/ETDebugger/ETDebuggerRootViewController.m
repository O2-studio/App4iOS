//
//  ETDebuggerRootViewController.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerRootViewController.h"
#import "ETMemoryMonitor.h"
#import "ETDebuggerMemoryMonitorView.h"
#import "ETDebuggerImagePoolMonitorView.h"
#import "ETDebuggerHttpMonitorView.h"
#import "ETDebuggerUrlCacheView.h"

static NSTimer* sMemoryHeartbeatTimer = nil;


@interface ETDebuggerRootViewController ()

@property(nonatomic,strong) ETDebuggerMemoryMonitorView* memoryView;
@property(nonatomic,strong) ETDebuggerImagePoolMonitorView* imagePoolView;
@property(nonatomic,strong) ETDebuggerHttpMonitorView* httpView;
@property(nonatomic,strong) ETDebuggerUrlCacheView* urlCacheView;

@end

@implementation ETDebuggerRootViewController

DEF_SINGLETON(ETDebuggerRootViewController);



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat height = self.view.frame.size.height/5;
    CGFloat width = self.view.frame.size.width;
    
    //total memory
    CGRect memoryFrame;
    memoryFrame.origin      = CGPointZero;
    memoryFrame.size.width  = width;
    memoryFrame.size.height = height;
    
    _memoryView = [[ETDebuggerMemoryMonitorView alloc] initWithFrame:memoryFrame];
    [self.view addSubview:_memoryView];
    
    
    //image pool
    CGRect imagePoolFrame;
    imagePoolFrame.origin.x = 0;
    imagePoolFrame.origin.y = height;
    imagePoolFrame.size.width  = width;
    imagePoolFrame.size.height = height;
    
    _imagePoolView = [[ETDebuggerImagePoolMonitorView alloc]initWithFrame:imagePoolFrame];
    [self.view addSubview:_imagePoolView];
    
    //url cache
    CGRect urlCacheFrame;
    urlCacheFrame.origin.x = 0;
    urlCacheFrame.origin.y = height*2;
    urlCacheFrame.size.width  = width;
    urlCacheFrame.size.height = height;
    
    _urlCacheView = [[ETDebuggerUrlCacheView alloc]initWithFrame:urlCacheFrame];
    [self.view addSubview:_urlCacheView];
    
    //http
    CGRect httpFrame;
    httpFrame.origin.x = 0;
    httpFrame.origin.y = height*3;
    httpFrame.size.width  = width;
    httpFrame.size.height = height;
    
    _httpView = [[ETDebuggerHttpMonitorView alloc]initWithFrame:httpFrame];
    [self.view addSubview:_httpView];
    

    CGRect closeFrame;
    closeFrame.size.width = 160.0f;
    closeFrame.size.height = height/2;
    closeFrame.origin.x = 160.0f;
    closeFrame.origin.y = height*4 + height/2;
    
    UIButton* closeBtn = nil;
    closeBtn = [[UIButton alloc] initWithFrame:closeFrame];
    closeBtn.backgroundColor = [UIColor darkGrayColor];
    closeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    closeBtn.layer.borderWidth = 2.0f;
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [closeBtn setTitle:@"close" forState:UIControlStateNormal];
    //[_purgeMemoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];

    
    
    CGRect purgeBtnFrame;
    purgeBtnFrame.size.width = 160.0f;
    purgeBtnFrame.size.height = height/2;
    purgeBtnFrame.origin.x = 0.0f;
    purgeBtnFrame.origin.y = height/2 + height*4;
    //
    
    UIButton* _purgeMemoryBtn = nil;
    _purgeMemoryBtn = [[UIButton alloc] initWithFrame:purgeBtnFrame];
    _purgeMemoryBtn.backgroundColor = [UIColor darkGrayColor];
    _purgeMemoryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _purgeMemoryBtn.layer.borderWidth = 2.0f;
    _purgeMemoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_purgeMemoryBtn setTitle:@"MemoryWarning" forState:UIControlStateNormal];
    //[_purgeMemoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
    [_purgeMemoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purgeMemoryBtn addTarget:self action:@selector(memoryWarning:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_purgeMemoryBtn];

    
    
    sMemoryHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                               target: self
                                                             selector: @selector(readMemHeatBeat)
                                                             userInfo: nil
                                                              repeats: YES];
}

- (void)memoryWarning:(id)sender
{
    [ETMemoryMonitor performLowMemoryWarning];
}

- (void)close:(UIButton*)sender
{
    [ETDebuggerOverlay sharedInstance].hidden = NO;
    [ETDebuggerWindow  sharedInstance].hidden = YES;
}

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_memoryView);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)readMemHeatBeat
{
    //memory
    [[ETMemoryMonitor sharedInstance] heartBeat];
    
    //image memory cache
    [[ETImagePool currentImagePool] heartBeat];
    
    //image file cache
    [[ETImageCache currentCache] heartBeat];
    
    //image connection pool
    [[ETImageConnectionPool currentPool] heartBeat];
    
    //http connection pool
    [[ETAFHttpRequestClient sharedInstance] heartBeat];
    
    //url cache
    [[ETUrlCacheManagerDefault sharedManager] heartBeat];
    
    
}

@end
