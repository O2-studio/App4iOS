//
//  ETUIAttributeStringParser.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-6.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETUIAttributeLabelHeader.h"

@class ETUIAttributeStringParser;
@protocol ETUIAttributeStringParser <NSObject>

- (void)onAttributeStringFinishedParsing:(ETUIAttributeStringParser*)sender;

@end

@interface ETUIAttributeStringParser : NSObject
{
    
}
@property(nonatomic,weak) id<ETUIAttributeStringParser> delegate;
/**
 attribute string
 */
@property (nonatomic, strong, readonly) NSAttributedString* attributedString;
/**
 content string
 */
@property (nonatomic,strong) NSString* cleanText;

/**
 background color
 */
@property(nonatomic,strong) UIColor* backgroundColor;
/**
 line height : default is 20
 */
@property (nonatomic) CGFloat lineHeight;
/**
 link color : default is [EtaobaseConfigForUX getLightBlueColor]
 */
@property(nonatomic,strong) UIColor* linkColor;
/**
 link background color when touched: default is [UIColor colorWithWhite:0.5f alpha:0.5f]
 */
@property (nonatomic, strong) UIColor* highlightedLinkBackgroundColor;
/**
 text color : default is [EtaobaseConfigForUX getBlackColor]
 */
@property(nonatomic,strong) UIColor* textColor;;
/**
 text font : default is 14
 */
@property(nonatomic,strong) UIFont* textFont;
/**
 Regex  : default is (@[(\\w-)]+)
 eg: @someone
 */
@property(nonatomic,strong) NSRegularExpression*  userNameRegEx;
/**
 Regex : default is (#([^#]+)#)
 eg: #topic# 
 */
@property(nonatomic,strong) NSRegularExpression*  activityRegEx;
/**
 Regex : default is (\\[([^\\]\\[]+)\\]) 
 eg:[smile] [anger]
 */
@property(nonatomic,strong) NSRegularExpression*  imageRegEx;
/**
 text alignment : default is align left
 */
@property(nonatomic)  NSTextAlignment    textAlignment;
/**
 text line break mode : default is wordwrapping
 */
@property(nonatomic)  NSLineBreakMode    lineBreakMode;   
/**
 text number of lines : default is 0
 */
@property(nonatomic,assign) NSInteger numberOfLines;
/**
 constraint text width : default is 320
 */
@property(nonatomic,assign)CGFloat constraintTextWidth;
/**
 constrait text height
 */
@property(nonatomic,assign,readonly) CGFloat constraintTextHeight;
/**
 highlighted keywords
 */
@property(nonatomic,strong) NSMutableArray* highLightedKeywords;
/**
 attribute images
 */
@property(nonatomic,strong) NSMutableArray* attributeImages;
/**
 * preRendered image
 */
@property(nonatomic,strong) UIImage* preRenderedImage;
/**
 * preRenderd image key in cache
 */
@property(nonatomic,strong) NSString* preRenderedImageCacheKey;


/**
 create attributed string from nsstring
 */
- (void)createAttributedString;

/**
 highlight keywords
 */
- (void)highlightKeywords:(NSArray*)keywords;
/**
 highlight keywords in range
 */
- (void)highlightKeywordsInRange:(NSRange)range;

/**
 bold keywords
 */
- (void)boldKeywords:(NSArray*)keywords;
/**
 bold text in range
 */
- (void)boldTextInRange:(NSRange)range;

/**
 set text color in range
 */
- (void)setTextColor:(UIColor*)textColor InRange:(NSRange)range;
/**
 preRender image
 */
- (UIImage*)preRenderText:(CGSize)size;


/////////core text property readonly//////////////
///**
// frame
// */
//@property(nonatomic,readonly)  CTFrameRef ctFrame;
///**
// attribute string
// */
//@property(nonatomic,readonly)  CFMutableAttributedStringRef attrString;
///**
// frame setter
// */
//@property(nonatomic,readonly)  CTFramesetterRef             framesetter;
//////////////////////////////////////////////////


@end
