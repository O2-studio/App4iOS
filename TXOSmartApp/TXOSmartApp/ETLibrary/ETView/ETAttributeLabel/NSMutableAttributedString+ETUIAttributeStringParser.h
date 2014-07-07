//
//  NSMutableAttributedString+ETUIAttributeStringParser.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-7.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

//copied from nimbus

@interface NSMutableAttributedString (ETUIAttributeStringParser)

/**
 * Sets the text alignment and the line break mode for a given range.
 *
 * TextAlignment Values:
 * - kCTLeftTextAlignment
 * - kCTCenterTextAlignment
 * - kCTRightTextAlignment
 * - kCTJustifiedTextAlignment
 * - kCTNaturalTextAlignment
 *
 * LineBreakMode Values
 * - kCTLineBreakByWordWrapping
 * - kCTLineBreakByCharWrapping
 * - kCTLineBreakByClipping
 * - kCTLineBreakByTruncatingHead
 * - kCTLineBreakByTruncatingTail
 * _ kCTLineBreakByTruncatingMiddle
 */
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat) lineHeight
                   range:(NSRange)range;


/**
 * Sets the text alignment and the line break mode for the whole string.
 *
 * TextAlignment Values:
 * - kCTLeftTextAlignment
 * - kCTCenterTextAlignment
 * - kCTRightTextAlignment
 * - kCTJustifiedTextAlignment
 * - kCTNaturalTextAlignment
 *
 * LineBreakMode Values
 * - kCTLineBreakByWordWrapping
 * - kCTLineBreakByCharWrapping
 * - kCTLineBreakByClipping
 * - kCTLineBreakByTruncatingHead
 * - kCTLineBreakByTruncatingTail
 * _ kCTLineBreakByTruncatingMiddle
 
 */
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat) lineHeight;


/**
 * Sets the text color for a given range.
 */
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

/**
 * Sets the text color for the whole string.
 */
- (void)setTextColor:(UIColor*)color;

/**
 * Sets the font for a given range.
 */
- (void)setFont:(UIFont*)font range:(NSRange)range;

/**
 * Sets the font for the whole string.
 */
- (void)setFont:(UIFont*)font;

/**
 * Sets the underline style and modifier for a given range.
 *
 * Style Values:
 * - kCTUnderlineStyleNone
 * - kCTUnderlineStyleSingle
 * - kCTUnderlineStyleThick
 * - kCTUnderlineStyleDouble
 *
 * Modifier Values:
 * - kCTUnderlinePatternSolid
 * - kCTUnderlinePatternDot
 * - kCTUnderlinePatternDash
 * - kCTUnderlinePatternDashDot
 * - kCTUnderlinePatternDashDotDot
 */
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

/**
 * Sets the underline style and modifier for the whole string.
 *
 * Style Values:
 * - kCTUnderlineStyleNone
 * - kCTUnderlineStyleSingle
 * - kCTUnderlineStyleThick
 * - kCTUnderlineStyleDouble
 *
 * Modifier Values:
 * - kCTUnderlinePatternSolid
 * - kCTUnderlinePatternDot
 * - kCTUnderlinePatternDash
 * - kCTUnderlinePatternDashDot
 * - kCTUnderlinePatternDashDotDot
 */
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;

/**
 * Sets the stroke width for a given range.
 */
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 * Sets the stroke width for the whole string.
 */
- (void)setStrokeWidth:(CGFloat)width;

/**
 * Sets the stroke color for a given range.
 */
- (void)setStrokeColor:(UIColor*)color range:(NSRange)range;

/**
 * Sets the stroke color for the whole string.
 */
- (void)setStrokeColor:(UIColor*)color;

/**
 * Sets the text kern for a given range.
 */
- (void)setKern:(CGFloat)kern range:(NSRange)range;

/**
 * Sets the text kern for the whole string.
 */
- (void)setKern:(CGFloat)kern;

@end
