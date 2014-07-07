//
//  ETCanvas.m
//  ETShopping
//
//  Created by moxin.xt on 13-4-9.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETCanvas.h"

@implementation ETCanvas

//drawing gradients
void drawLinearGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                        UIColor*  endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    //create CFArrayRef is unnessary
    NSArray *colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];

    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef) colors, locations);
    
    //起点：x轴中点，y顶点
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    //终点：x周中点，y底点
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

}

//fill rect with color
void drawSolidRectWithColor(CGContextRef context,CGRect rect,UIColor* bkColor)
{
    CGContextSetFillColorWithColor(context, bkColor.CGColor);
    CGContextFillRect(context, rect);
    
}

//draw rect border
void drawRectBorder(CGContextRef context ,CGRect rect, UIColor* strokeColor, CGFloat strokeLineWidth)
{
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, strokeLineWidth);
    CGContextStrokeRect(context, rect);
}

//draw a line
void drawSingleLine(CGContextRef context, CGPoint startPt, CGPoint endPt,UIColor* strokeColor, CGFloat strokeLineWidth)
{
    CGFloat delta = strokeLineWidth/2;
    //CGFloat delta = 0;
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, strokeLineWidth);
    CGContextMoveToPoint(context, startPt.x + delta, startPt.y + delta);
    CGContextAddLineToPoint(context, endPt.x - delta, endPt.y - delta);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

//draw shadow for the given rect
void drawShadowForGivenRect(CGContextRef context, CGSize offset, CGFloat blurDegree, UIColor* shadowColor)
{
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, offset, blurDegree, shadowColor.CGColor);
    CGContextRestoreGState(context);
}

//draw gloss and gradient
void drawGlossAndGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                          UIColor* endColor)
{
    drawLinearGradient(context, rect, startColor, endColor);
    
    UIColor* glossColor1 = [UIColor colorWithRed:1.0 green:1.0
                                            blue:1.0 alpha:0.35];
    UIColor* glossColor2 = [UIColor colorWithRed:1.0 green:1.0
                                            blue:1.0 alpha:0.1];
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y,
                                rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
}

//draw arrow
void drawArrowInRect(CGContextRef context, CGRect rect,UIColor* strokeColor, CGFloat strokeLineWidth)
{
    CGPoint origin = rect.origin;
    CGSize  size = rect.size;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Upper tip
    [path moveToPoint:CGPointMake(origin.x, origin.y)];
    // Arrow head
    [path addLineToPoint:CGPointMake(origin.x+size.width, origin.y+size.height/2)];
    // Lower tip
    [path addLineToPoint:CGPointMake(origin.x, origin.y+size.height)];
    
    [strokeColor set];
   
    [path setLineWidth:strokeLineWidth];
    [path stroke];
}

//draw heart
void drawSolideHeartInRect(CGContextRef context, CGRect rect, UIColor* heartColor)
{
//    CGFloat a = MIN(rect.size.width, rect.size.height);
//    CGRect frame = CGRectMake(rect.size.width/2 - a/2, rect.size.height/2 - a/2, a, a);

    CGRect frame = rect;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49986 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24129 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.64732 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05022 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55044 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11201 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33067 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06393 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46023 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14682 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39785 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08864 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05011 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30516 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05454 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27896 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04999 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36081 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.12805 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05067 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.00977 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15998 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29627 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70379 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.00709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55420 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.18069 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62648 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50061 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92498 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40835 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77876 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48812 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88133 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70195 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70407 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50990 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88158 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59821 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77912 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.99177 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35870 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.81539 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62200 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.99308 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55208 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.99040 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15672 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86824 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04848 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, heartColor.CGColor);
	CGContextAddPath(context, (__bridge CGPathRef)(bezierPath));
	CGContextFillPath(context);
	CGContextRestoreGState(context);
    
}

//draw lower round corner
void drawLowerRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius,UIColor* fillColor,UIColor* shadowColor)
{
//    CGFloat outerMargin = 0.0f;
//    CGRect outerRect = CGRectInset(rect, outerMargin, outerMargin);
    CGRect outerRect = rect;
    CGMutablePathRef path = CGPathCreateMutable();
    
    //move to the middle of left side line
    CGPathMoveToPoint(path, NULL, CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect));
   
    //right lower corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
   
    //lower left corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
  
    //draw line to seal the rect
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
  
    //close path
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor.CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    CGContextRestoreGState(context);
    
    
}

//draw upper round corner
void drawUpperRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius,UIColor* fillColor,UIColor* shadowColor)
{

}

//draw round corner for rect
void drawRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius,UIColor* fillColor,UIColor* shadowColor)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    //right upper corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    //right lower corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    //lower left corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    
    //upper left corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor.CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    CGContextRestoreGState(context);
    

    

}


@end
