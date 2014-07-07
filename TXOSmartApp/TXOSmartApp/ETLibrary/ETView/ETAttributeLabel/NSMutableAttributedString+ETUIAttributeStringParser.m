//
//  NSMutableAttributedString+ETUIAttributeStringParser.m
//  ETShopping
//
//  Created by moxin.xt on 13-4-7.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "NSMutableAttributedString+ETUIAttributeStringParser.h"

@implementation NSMutableAttributedString (ETUIAttributeStringParser)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight
                   range:(NSRange)range {
    
    CTParagraphStyleRef style;
    
    if ( lineHeight == 0 ) {
        CTParagraphStyleSetting paragraphStyles[2] = {
            {.spec = kCTParagraphStyleSpecifierAlignment,
                .valueSize = sizeof(CTTextAlignment),
                .value = (const void*)&textAlignment},
            {.spec = kCTParagraphStyleSpecifierLineBreakMode,
                .valueSize = sizeof(CTLineBreakMode),
                .value = (const void*)&lineBreakMode},
        };
        style = CTParagraphStyleCreate(paragraphStyles, 2);
    } else {
        CTParagraphStyleSetting paragraphStyles[4] = {
            {.spec = kCTParagraphStyleSpecifierAlignment,
                .valueSize = sizeof(CTTextAlignment),
                .value = (const void*)&textAlignment},
            {.spec = kCTParagraphStyleSpecifierLineBreakMode,
                .valueSize = sizeof(CTLineBreakMode),
                .value = (const void*)&lineBreakMode},
            {.spec = kCTParagraphStyleSpecifierMinimumLineHeight,
                .valueSize = sizeof(lineHeight),
                .value = (const void*)&lineHeight},
            {.spec = kCTParagraphStyleSpecifierMaximumLineHeight,
                .valueSize = sizeof(lineHeight),
                .value = (const void*)&lineHeight},
        };
        style = CTParagraphStyleCreate(paragraphStyles, 4);
    }
    [self addAttribute:(NSString*)kCTParagraphStyleAttributeName
                 value:(__bridge id)style
                 range:range];
    CFRelease(style);
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight {
    [self setTextAlignment:textAlignment
             lineBreakMode:lineBreakMode
                lineHeight:lineHeight
                     range:NSMakeRange(0, self.length)];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor*)color range:(NSRange)range {
    if (nil != color) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
        
        [self addAttribute:(NSString*)kCTForegroundColorAttributeName
                     value:(id)color.CGColor
                     range:range];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor*)color {
    [self setTextColor:color range:NSMakeRange(0, self.length)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font range:(NSRange)range {
    if (nil != font) {
        [self removeAttribute:(NSString*)kCTFontAttributeName range:range];
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
        [self addAttribute:(__bridge NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font {
    [self setFont:font range:NSMakeRange(0, self.length)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range {
    [self removeAttribute:(NSString*)kCTUnderlineColorAttributeName range:range];
    [self addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:(style|modifier)]
                 range:range];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier {
    [self setUnderlineStyle:style
                   modifier:modifier
                      range:NSMakeRange(0, self.length)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self removeAttribute:(NSString*)kCTStrokeWidthAttributeName range:range];
    [self addAttribute:(NSString*)kCTStrokeWidthAttributeName
                 value:[NSNumber numberWithFloat:width]
                 range:range];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeWidth:(CGFloat)width {
    [self setStrokeWidth:width range:NSMakeRange(0, self.length)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeColor:(UIColor *)color range:(NSRange)range {
    if (nil != color) {
        [self removeAttribute:(NSString*)kCTStrokeColorAttributeName range:range];
        
        [self addAttribute:(NSString*)kCTStrokeColorAttributeName
                     value:(id)color.CGColor
                     range:range];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeColor:(UIColor *)color {
    [self setStrokeColor:color range:NSMakeRange(0, self.length)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setKern:(CGFloat)kern range:(NSRange)range {
    [self removeAttribute:(NSString*)kCTKernAttributeName range:range];
    [self addAttribute:(NSString*)kCTKernAttributeName
                 value:[NSNumber numberWithFloat:kern]
                 range:range];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setKern:(CGFloat)kern {
    [self setKern:kern range:NSMakeRange(0, self.length)];
}

@end
