//
//  ETDebuggerMonitorView.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebuggerMonitorView.h"

//两个定时器，一个读，一个写
static NSTimer* sWriteHeartbeatTimer = nil;

@implementation ETDebuggerMonitorHistogram
{
   
    //NSTimer* sWriteHeartbeatTimer;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;
        


        
        sWriteHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                               target: self
                                                             selector: @selector(writeHeartBeat)
                                                             userInfo: nil
                                                              repeats: YES];
    }
    return self;
}

- (void)writeHeartBeat
{

    
   
}

@end
