//
//  ETDebugger.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETDebugger.h"
#import "ETDebuggerWindow.h"
#import "ETDebuggerOverlay.h"

@implementation ETDebugger

+ (void)show
{
    [ETDebuggerWindow sharedInstance].hidden = YES;
    [ETDebuggerOverlay sharedInstance].hidden = NO;
    
}

@end
