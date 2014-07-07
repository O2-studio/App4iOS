//
//  ETDebuggerPlotView.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 copied from "Bee"
 */

@interface ETDebuggerPlotView : UIView

@property (nonatomic, assign) BOOL			fill;
@property (nonatomic, assign) BOOL			border;
@property (nonatomic, assign) CGFloat		lineScale;
@property (nonatomic, retain) UIColor *		lineColor;
@property (nonatomic, assign) CGFloat		lineWidth;
@property (nonatomic, assign) CGFloat		lowerBound;
@property (nonatomic, assign) CGFloat		upperBound;
@property (nonatomic, assign) NSUInteger	capacity;
@property (nonatomic, retain) NSArray *		plots;

//moxin
@property (nonatomic, assign) CGFloat        dot;


@end
