//
//  ETDebuggerMemoryMonitorView.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-26.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerMemoryMonitorView.h"


#define kThreshHold 60.0f

@implementation ETDebuggerMemoryMonitorView
{
    UILabel *			_titleView;
	UILabel *			_statusView;
	ETDebuggerPlotView*	_plotView1;
	UIButton *			_autoWarning;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect titleFrame;
		titleFrame.size.width = 90.0f;
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
        _titleView.text = @"Memory Usage";
		[self addSubview:_titleView];
        
		CGRect statusFrame;
		statusFrame.size.width = 200;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 110.0f;
		statusFrame.origin.y = 0.0f;
        
		_statusView = [[UILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor whiteColor];
		_statusView.textAlignment = UITextAlignmentRight;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
        _statusView.backgroundColor = [UIColor clearColor];
		[self addSubview:_statusView];
        
        CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = frame.size.height - 20;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
        
		_plotView1 = [[ETDebuggerPlotView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.6f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = 0.0f;
		_plotView1.lineColor = [UIColor orangeColor];
		_plotView1.lineWidth = 2.0f;
		_plotView1.capacity = 50;
		[self addSubview:_plotView1];
		    
    }
    
    return self;
}


- (void)writeHeartBeat
{
    
    float used = [ETMemoryMonitor bytesOfUsedMemory];
    float total = [ETMemoryMonitor bytesOfTotalMemory];
    
    float percent = (total > 0.0f) ? ((float)used / (float)total * 100.0f) : 0.0f;
	if ( percent >= kThreshHold )
	{
        //预警
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations: ^(void){self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];}
                         completion:NULL];
    }
	else
	{
        
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations: ^(void){self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6f];}
                         completion:NULL];
	}
    
    NSMutableArray* tmp = [ETMemoryMonitor sharedInstance].samplePoints;
    CGFloat _upperBound = 1;
    CGFloat _lowerBound = 0;
    
    for ( NSNumber * n in tmp )
    {
        if ( n.intValue > _upperBound )
        {
            _upperBound = n.intValue;
            if ( _upperBound < _lowerBound )
            {
                _lowerBound = _upperBound;
            }
        }
        else if ( n.intValue < _lowerBound )
        {
            _lowerBound = n.intValue;
        }
    }

    
    [_plotView1 setPlots:tmp];
    [_plotView1 setLowerBound:_lowerBound];
    [_plotView1 setUpperBound:_upperBound];
    [_plotView1 setNeedsDisplay];
    

    
    NSMutableString * text = [NSMutableString string];
    [text appendFormat:@"used:%@ (%.0f%%)   ", [ETSystemUtil number2String:used], percent];
    [text appendFormat:@"free:%@  ", [ETSystemUtil number2String:total - used]];
    _statusView.text = text;
}

-(void)memoryWarning:(id)sender
{
    
    if (_autoWarning.tag == 0)
    {
        _autoWarning.tag = 1;
        [_autoWarning setTitle:@"WARNING(on)" forState:UIControlStateNormal];
        
        //预警
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations: ^(void){self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];}
                         completion:NULL];
        
        [ETMemoryMonitor performLowMemoryWarning];

    }
    else
    {
        _autoWarning.tag = 0;
        [_autoWarning setTitle:@"WARNING(off)" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations: ^(void){self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6f];}
                         completion:NULL];
    }
    
}

@end
