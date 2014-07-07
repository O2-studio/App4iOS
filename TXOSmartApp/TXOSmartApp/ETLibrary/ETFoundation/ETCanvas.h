//
//  ETCanvas.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-9.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 core graphic api
 */



@interface ETCanvas : NSObject

//drawing gradients
void drawLinearGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                        UIColor*  endColor);
//fill rect with color
void drawSolidRectWithColor(CGContextRef context,CGRect rect,UIColor* bkColor);

//draw rect border
void drawRectBorder(CGContextRef context ,CGRect rect, UIColor* strokeColor, CGFloat strokeLineWidth );

//draw a line
void drawSingleLine(CGContextRef context, CGPoint startPt, CGPoint endPt,UIColor* strokeColor, CGFloat strokeLineWidth);

//draw shadow for the given rect
void drawShadowForGivenRect(CGContextRef context, CGSize offset, CGFloat blurDegree, UIColor* shadowColor);

//draw gloss and gradient
void drawGlossAndGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                          UIColor* endColor);
//draw an arrow
void drawArrowInRect(CGContextRef context, CGRect rect, UIColor* strokeColor, CGFloat strokeLineWidth);

//draw heart
void drawSolideHeartInRect(CGContextRef context, CGRect rect, UIColor* heartColor);

//draw lower round corner
void drawLowerRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius,UIColor* fillColor,UIColor* shadowColor);

//draw upper round corner
void drawUpperRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius,UIColor* fillColor,UIColor* shadowColor);

//draw round corner for rect
void drawRoundCornerForRect(CGContextRef context, CGRect rect, CGFloat radius, UIColor* fillColor,UIColor* shadowColor);
@end
