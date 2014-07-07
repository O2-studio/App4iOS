//
//  ETDebuggerImagePoolMonitorView.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-26.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerImagePoolMonitorView.h"

#define kThreshHold 80.0f

@implementation ETDebuggerImagePoolMonitorView
{
    UILabel *			_titleView;
	UILabel *			_statusView;
	ETDebuggerPlotView*	_plotView1;
    ETDebuggerPlotView* _plotView2;

    
    UIButton*           _purgeMemoryBtn;
    UIButton*           _purgetDiskBtn;
    UIButton*           _recycleMemoryBtn;
    UIButton*           _recycleDiskBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = frame.size.height - 40;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
        
        //draw memory cache
		_plotView1 = [[ETDebuggerPlotView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.6f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = 0.0f;
		_plotView1.lineColor = [UIColor orangeColor];
		_plotView1.lineWidth = 2.0f;
		_plotView1.capacity = 50;
        _plotView1.fill = YES;
		[self addSubview:_plotView1];
        
        //draw file cache
		_plotView2 = [[ETDebuggerPlotView alloc] initWithFrame:plotFrame];
		_plotView2.alpha = 0.6f;
		_plotView2.lowerBound = 0.0f;
		_plotView2.upperBound = 0.0f;
		_plotView2.lineColor = [UIColor greenColor];
		_plotView2.lineWidth = 2.0f;
		_plotView2.capacity = 50;
        _plotView2.fill = NO;
		[self addSubview:_plotView2];
        
		CGRect titleFrame;
		titleFrame.size.width = 120.0f;
		titleFrame.size.height = 20.0f;
		titleFrame.origin.x = 8.0f;
		titleFrame.origin.y = 0.0f;
        
		_titleView = [[UILabel alloc] initWithFrame:titleFrame];
		_titleView.textColor = [UIColor orangeColor];
		_titleView.textAlignment = UITextAlignmentLeft;
		_titleView.font = [UIFont boldSystemFontOfSize:12.0f];
		_titleView.lineBreakMode = UILineBreakModeClip;
        _titleView.backgroundColor = [UIColor clearColor];
		_titleView.numberOfLines = 1;
        _titleView.text = @"Image Pool";
		[self addSubview:_titleView];
        
		CGRect statusFrame;
		statusFrame.size.width = 200;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 100.0f;
		statusFrame.origin.y = 0.0f;
        
		_statusView = [[UILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor whiteColor];
		_statusView.textAlignment = UITextAlignmentRight;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
        _statusView.backgroundColor = [UIColor clearColor];
		[self addSubview:_statusView];
        
        
        CGRect purgeBtnFrame;
        purgeBtnFrame.size.width = 160.0f;
        purgeBtnFrame.size.height = 20.0f;
        purgeBtnFrame.origin.x = 0.0f;
        purgeBtnFrame.origin.y = frame.size.height -20;
        //
        _purgeMemoryBtn = [[UIButton alloc] initWithFrame:purgeBtnFrame];
        _purgeMemoryBtn.backgroundColor = [UIColor darkGrayColor];
        _purgeMemoryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _purgeMemoryBtn.layer.borderWidth = 2.0f;
        _purgeMemoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [_purgeMemoryBtn setTitle:@"clean memory" forState:UIControlStateNormal];
        //[_purgeMemoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
        [_purgeMemoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_purgeMemoryBtn addTarget:self action:@selector(purgeMemory:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_purgeMemoryBtn];
        
        purgeBtnFrame.origin.x = 160;
        
        _purgetDiskBtn = [[UIButton alloc] initWithFrame:purgeBtnFrame];
        _purgetDiskBtn.backgroundColor = [UIColor darkGrayColor];
        _purgetDiskBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _purgetDiskBtn.layer.borderWidth = 2.0f;
        _purgetDiskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [_purgetDiskBtn setTitle:@"clean disk" forState:UIControlStateNormal];
        //[_purgetDiskBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
        [_purgetDiskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_purgetDiskBtn addTarget:self action:@selector(purgeDisk:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_purgetDiskBtn];
        
//        purgeBtnFrame.origin.x = 160;
//        
//        _recycleMemoryBtn = [[UIButton alloc]initWithFrame:purgeBtnFrame];
//        _recycleMemoryBtn.backgroundColor = [UIColor darkGrayColor];
//        _recycleMemoryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _recycleMemoryBtn.layer.borderWidth = 2.0f;
//        _recycleMemoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//        [_recycleMemoryBtn setTitle:@"Recycle M" forState:UIControlStateNormal];
//        [_recycleMemoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
//        [_recycleMemoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_recycleMemoryBtn addTarget:self action:@selector(recycleMemory:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_recycleMemoryBtn];
//
//        purgeBtnFrame.origin.x = 240;
//        
//        _recycleDiskBtn = [[UIButton alloc]initWithFrame:purgeBtnFrame];
//        _recycleDiskBtn.backgroundColor = [UIColor darkGrayColor];
//        _recycleDiskBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _recycleDiskBtn.layer.borderWidth = 2.0f;
//        _recycleDiskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//        [_recycleDiskBtn setTitle:@"Recycle D" forState:UIControlStateNormal];
//        [_recycleDiskBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
//        [_recycleDiskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_recycleDiskBtn addTarget:self action:@selector(recycleDisk:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_recycleDiskBtn];
        
    }
    return self;
}

- (void)purgeMemory:(id)sender
{
    [[ETImageConnectionPool currentPool] cleanBlackUrlList];
    [[ETImageConnectionPool currentPool] cleanPendingUrlList];
    [[ETImagePool currentImagePool] removeAllImagesInMemory];
}
- (void)purgeDisk:(id)sender
{
    [[ETImagePool currentImagePool] removeAllImagesInDisk];
}

- (void)recycleMemory:(id)sender
{
    [[ETImagePool currentImagePool] removeAllImagesInMemory];
}

- (void)recycleDisk:(id)sender
{
    [[ETImagePool currentImagePool] removeAllImagesInDisk];
}

- (void)writeHeartBeat
{
    
    int mem_count  = [ETImagePool currentImagePool].keysInMemory.count;
    int disk_count = [ETImagePool currentImagePool].keysInDisk.count;
    
    


//	if ( mem_count >= kThreshHold )
//	{
//        //预警
////        [UIView animateWithDuration:0.6f
////                              delay:0.0f
////                            options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
////                         animations: ^(void){self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];}
////                         completion:NULL];
//        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
//    }
//	else
//	{
//        
////        [UIView animateWithDuration:0.6f
////                              delay:0.0f
////                            options: UIViewAnimationOptionBeginFromCurrentState
////                         animations: ^(void){self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6f];}
////                         completion:NULL];
//        
//        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6f];
//	}
//    
    
    //memory cache
    NSMutableArray* tmp1 = [ETImagePool currentImagePool].samplePoints;
    CGFloat _upperBound1 = 1;
    CGFloat _lowerBound1 = 0;
    
    for ( NSNumber * n in tmp1 )
    {
        if ( n.intValue > _upperBound1 )
        {
            _upperBound1 = n.intValue;
            if ( _upperBound1 < _lowerBound1 )
            {
                _lowerBound1 = _upperBound1;
            }
        }
        else if ( n.intValue < _lowerBound1 )
        {
            _lowerBound1 = n.intValue;
        }
    }
    
    
    [_plotView1 setPlots:tmp1];
    [_plotView1 setLowerBound:_lowerBound1];
    [_plotView1 setUpperBound:_upperBound1];
    [_plotView1 setNeedsDisplay];
    
    
    NSMutableString * text = [NSMutableString string];
    
    float memSize = [ETImagePool currentImagePool].memroySize;
    NSString* memSizeStr = @"";
   
    if (memSize >= 1024) {
        memSize /= 1024;
        memSizeStr = [NSString stringWithFormat:@"%0.2f MB",memSize];
    }
    else
        memSizeStr = [NSString stringWithFormat:@"%0.2f KB",memSize];
    
    
    
    
    [text appendFormat:@"used:%@(mem:%d,disk:%d)",memSizeStr,mem_count,disk_count];
    _statusView.text = text;
    
    
    //file cache
//    NSMutableArray* tmp2 = [ETImageCache currentCache].samplePoints;
//    CGFloat _upperBound2 = 1;
//    CGFloat _lowerBound2 = 0;
//    
//    for ( NSNumber * n in tmp2 )
//    {
//        if ( n.intValue > _upperBound2 )
//        {
//            _upperBound2 = n.intValue;
//            if ( _upperBound2 < _lowerBound2 )
//            {
//                _lowerBound2 = _upperBound2;
//            }
//        }
//        else if ( n.intValue < _lowerBound2 )
//        {
//            _lowerBound2 = n.intValue;
//        }
//    }
//    
//    [_plotView2 setPlots:tmp2];
//    [_plotView2 setLowerBound:_lowerBound2];
//    [_plotView2 setUpperBound:_upperBound2];
//    [_plotView2 setNeedsDisplay];

}

@end
