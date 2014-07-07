//
//  ETUIAttributeLabel.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-5.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETUIAttributeLabelHeader.h"



@protocol ETUIAttributeLabelDelegate <NSObject>

@optional
- (void)onAttributeLableDidSelectKeyword:(NSString*)keyword AtLocation:(NSInteger)location;

@end

/**
moxin:
 
 core text label
 

 */
@interface ETUIAttributeLabel : UIView

/**
 if this flag is ture, it won't call drawRect
 */
@property(nonatomic,assign) BOOL usePreRenderedImage;
/**
 should detect links
 */
@property(nonatomic,assign) BOOL shouldDetectKeyWords;
/**
 should detect images
 */
@property(nonatomic,assign) BOOL shouldDetectImages;
/**
 defer link detection
 default:no
 */
@property(nonatomic,assign) BOOL deferDetection;
/**
 text to display
 */
@property(nonatomic,strong) NSString* text;
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
 */
@property(nonatomic,strong) NSRegularExpression*  userNameRegEx;
/**
 Regex : default is (#([^>]*)#)
 */
@property(nonatomic,strong) NSRegularExpression*  activityRegEx;
/**
 Regex : default is (\\[/.+/\\])
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
@property(nonatomic,strong) NSMutableArray* attributedImages;
/**
 attribute string
 */
@property (nonatomic,strong) NSAttributedString* attributedString;
/**
 delegate
 */
@property(nonatomic,weak) id<ETUIAttributeLabelDelegate> delegate;

/**
 add highlight keywords
 */
- (void)addHighLightedKeywords:(NSArray*)highLightedKeywords;
/**
 highlight keywords in range
 */
- (void)highlightKeywordsInRange:(NSRange)range;

@end
