//
//  ETDebuggerHttpMonitorView.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerHttpMonitorView.h"

@implementation ETDebuggerHttpMonitorView
{
    UILabel *			_titleView;
	UILabel *			_statusView;
	ETDebuggerPlotView*	_plotView1;
    ETDebuggerPlotView* _plotView2;
    ETDebuggerPlotView* _plotView3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = frame.size.height - 40.0f;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
        
        //draw http connection pool
		_plotView1 = [[ETDebuggerPlotView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.6f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = 0.0f;
		_plotView1.lineColor = [UIColor yellowColor];
		_plotView1.lineWidth = 2.0f;
		_plotView1.capacity = 50;
        _plotView1.fill = NO;
		[self addSubview:_plotView1];
        
        //draw image connection pool
		_plotView2 = [[ETDebuggerPlotView alloc] initWithFrame:plotFrame];
		_plotView2.alpha = 0.6f;
		_plotView2.lowerBound = 0.0f;
		_plotView2.upperBound = 0.0f;
		_plotView2.lineColor = [UIColor blueColor];
		_plotView2.lineWidth = 2.0f;
		_plotView2.capacity = 50;
        _plotView2.fill = NO;
		[self addSubview:_plotView2];
        
        //draw http url mem cache
        
        
        //draw http url file cache
        
        
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
        _titleView.text = @"Network";
		[self addSubview:_titleView];
        
		CGRect statusFrame;
		statusFrame.size.width = 160;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 140.0f;
		statusFrame.origin.y = 0.0f;
        
		_statusView = [[UILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor whiteColor];
		_statusView.textAlignment = UITextAlignmentRight;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
        _statusView.backgroundColor = [UIColor clearColor];
		[self addSubview:_statusView];

    }
    return self;
}

- (void)writeHeartBeat
{
    
    int image_http_count    = [ETImageConnectionPool currentPool].operationQueue.operationCount;
    int http_count          = [ETAFHttpRequestClient sharedInstance].operationQueue.operationCount;
//    
//    
    NSMutableString * text = [NSMutableString string];
    [text appendFormat:@"image: %d  ", image_http_count];
    [text appendFormat:@"http: %d",http_count];
    _statusView.text = text;

    
    
    //image connection pool cache
    NSMutableArray* tmp1 = [ETImageConnectionPool currentPool].samplePoints;
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
    
    //http connection pool
    NSMutableArray* tmp2 = [ETAFHttpRequestClient sharedInstance].samplePoints;
    CGFloat _upperBound2 = 1;
    CGFloat _lowerBound2 = 0;
    
    for ( NSNumber * n in tmp2 )
    {
        if ( n.intValue > _upperBound2 )
        {
            _upperBound2 = n.intValue;
            if ( _upperBound2 < _lowerBound2 )
            {
                _lowerBound2 = _upperBound2;
            }
        }
        else if ( n.intValue < _lowerBound2 )
        {
            _lowerBound2 = n.intValue;
        }
    }
    
    [_plotView2 setPlots:tmp2];
    [_plotView2 setLowerBound:_lowerBound2];
    [_plotView2 setUpperBound:_upperBound2];
    [_plotView2 setNeedsDisplay];
    
}


@end
