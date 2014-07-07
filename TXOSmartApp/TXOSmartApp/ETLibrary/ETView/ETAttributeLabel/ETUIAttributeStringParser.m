//
//  ETUIAttributeStringParser.m
//  ETShopping
//
//  Created by moxin.xt on 13-4-6.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETUIAttributeStringParser.h"




@interface ETUIAttributeStringParser()
{
    //clean text
    NSString*                   _cleanText;
    NSMutableAttributedString*  _mutableAttributeString;
    
    //core fondation
    CFMutableAttributedStringRef _attrString;
    
    //core text
    CTFramesetterRef             _framesetter;
	CTFrameRef                   _ctFrame;
    CTLineBreakMode              _ctLineBreakMode;
    CTTextAlignment              _ctTextAlignment;
    CTFontRef                    _ctFont;
    
    //core graphic
    CGColorRef                   _ctColor;
    
    //highlighted keywords
    NSMutableArray*              _highLightedKeywords;
    
}

@end

@implementation ETUIAttributeStringParser

@synthesize cleanText = _cleanText;



////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    
    //to core text
    switch (lineBreakMode)
    {
        case NSLineBreakByWordWrapping:
        {
            _ctLineBreakMode = kCTLineBreakByWordWrapping;
            break;
        }
        case NSLineBreakByCharWrapping:{ _ctLineBreakMode = kCTLineBreakByCharWrapping; break;}
        case NSLineBreakByClipping: { _ctLineBreakMode = kCTLineBreakByClipping; break;}
        case NSLineBreakByTruncatingHead: {_ctLineBreakMode = kCTLineBreakByTruncatingHead; break;}
        case NSLineBreakByTruncatingTail: {_ctLineBreakMode = kCTLineBreakByTruncatingTail; break;}
        case NSLineBreakByTruncatingMiddle:{_ctLineBreakMode = kCTLineBreakByTruncatingMiddle; break;}
        default: break;
    }

}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    //to core text
    switch (textAlignment)
    {
        case NSTextAlignmentLeft: {_ctTextAlignment= kCTLeftTextAlignment; break;}
        case NSTextAlignmentCenter: {_ctTextAlignment= kCTCenterTextAlignment;break;}
        case NSTextAlignmentRight: {_ctTextAlignment= kCTRightTextAlignment;break;}
        case NSTextAlignmentJustified:{ _ctTextAlignment = kCTJustifiedTextAlignment;break;}
        default: {_ctTextAlignment = kCTLeftTextAlignment;break;};
    }
}

- (void)setCleanText:(NSString *)cleanText
{
    _cleanText = cleanText;
    [self createAttributedString];
}



////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSAttributedString*)attributedString
{
    return [_mutableAttributeString copy];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _highLightedKeywords = [NSMutableArray new];
        _attributeImages = [NSMutableArray new];
        
        self.lineHeight = 20;
        self.linkColor = [EtaoBaseConfigForUX getLightBlueColor];
        self.textColor = [EtaoBaseConfigForUX getBlackColor];
        self.textFont  = [EtaoBaseConfigForUX getFontSizeOf14:NO];
        self.lineBreakMode = UILineBreakModeWordWrap;
        self.textAlignment = UITextAlignmentLeft;
        self.numberOfLines = 0;
        self.constraintTextWidth = 285;
        self.highlightedLinkBackgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        
        NSError *error = NULL;
		self.userNameRegEx = [NSRegularExpression regularExpressionWithPattern:@"(@[(\\w-)]+)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        self.activityRegEx = [NSRegularExpression regularExpressionWithPattern:@"(#([^#]+)#)" options:NSRegularExpressionCaseInsensitive error:&error];
      
        self.imageRegEx = [NSRegularExpression regularExpressionWithPattern:@"(\\[([^\\]\\[]+)\\])" options:NSRegularExpressionCaseInsensitive error:&error];
    }
    
    return self;
}

-(void)dealloc
{    
	if(_attrString){ CFRelease(_attrString); _attrString = nil; }
	if(_framesetter){ CFRelease(_framesetter);  _framesetter = nil;}
	if(_ctFrame){ CFRelease(_ctFrame); _ctFrame = nil;}

}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void) createAttributedString
{
    if (self.cleanText.length == 0) {
        return;
    }
    
    if (_mutableAttributeString != nil) {
        return;
    }

    [self clearAttrString];
    //create attribute string
    _attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	CFAttributedStringReplaceString (_attrString, CFRangeMake(0, 0), (__bridge CFStringRef)_cleanText);
    
    //convert CoreFoundation to NextStep :)
    _mutableAttributeString = (__bridge NSMutableAttributedString *)(_attrString);

    //set text color
    [_mutableAttributeString setTextColor:self.textColor];
    
    //set text font
    [_mutableAttributeString setFont:self.textFont];
    
    //set lineHeight and paragraph style
    [_mutableAttributeString setTextAlignment:_ctTextAlignment lineBreakMode:_ctLineBreakMode lineHeight:self.lineHeight];
    
    //Parse image
    [self.imageRegEx enumerateMatchesInString:_cleanText options:0 range:NSMakeRange(0, _cleanText.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange range = match.range;
        
        if (range.length  > 2) {

            NSString* full = [_cleanText substringWithRange:range];
            NSString* picName = [NSString stringWithFormat:@"%@.png",[full substringWithRange:NSMakeRange(1, full.length-2)]];
            UIImage* image = __IMAGE(picName);
            
            if (image) {

                ETUIAttributeImageParser* labelImage = [ETUIAttributeImageParser new];
                labelImage.range = match.range;
                labelImage.index = match.range.location;
                labelImage.image = image;
                labelImage.size  = CGSizeMake(self.lineHeight, self.lineHeight);
                labelImage.margins = UIEdgeInsetsMake(0, 0, 0, 0);
                
                [_attributeImages addObject:labelImage];
            }
        }

    }];

    //parse image
    if (_attributeImages.count > 0)
    {
        // Sort the label images in reverse order by index so that when we add them the string's indices
        // remain relatively accurate to the original string. This is necessary because we're inserting
        // spaces into the string.
        [_attributeImages sortUsingComparator:^NSComparisonResult(ETUIAttributeImageParser* obj1, ETUIAttributeImageParser*  obj2) {
            if (obj1.index < obj2.index) {
                return NSOrderedDescending;
            } else if (obj1.index > obj2.index) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        for (ETUIAttributeImageParser *labelImage in _attributeImages)
        {
            CTRunDelegateCallbacks callbacks;
            memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
            callbacks.version = kCTRunDelegateVersion1;
            callbacks.getAscent  = ImageDelegateGetAscentCallbackForParser;
            callbacks.getDescent = ImageDelegateGetDescentCallbackForParser;
            callbacks.getWidth   = ImageDelegateGetWidthCallbackForParser;
            
            NSUInteger index = labelImage.index;
            if (index >= _mutableAttributeString.length) {
                index = _mutableAttributeString.length - 1;
            }
            
            NSDictionary *attributes = [_mutableAttributeString attributesAtIndex:index effectiveRange:NULL];
            CTFontRef font = (__bridge CTFontRef)[attributes valueForKey:(__bridge id)kCTFontAttributeName];
            
            if (font != NULL) {
                labelImage.fontAscent = CTFontGetAscent(font);
                labelImage.fontDescent = CTFontGetDescent(font);
            }
            
            CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)labelImage);
            
            // Character to use as recommended by kCTRunDelegateAttributeName documentation.
            unichar objectReplacementChar = 0xFFFC;
            NSString *objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
            NSMutableAttributedString* space = [[NSMutableAttributedString alloc] initWithString:objectReplacementString];
            CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
            CFRelease(delegate);
//            [_mutableAttributeString insertAttributedString:space atIndex:labelImage.index];
            
            if (labelImage.image != nil) {
                [_mutableAttributeString replaceCharactersInRange:labelImage.range withAttributedString:space];
            }
        }
    }
    
    
    //reset text
    _cleanText = [_mutableAttributeString string];

    
    //parse "@"symbol
    [self.userNameRegEx enumerateMatchesInString:_cleanText options:0 range:NSMakeRange(0, [_cleanText length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        if(match.numberOfRanges > 1)
        {
            NSRange range = [match rangeAtIndex:1];
            if(range.length > 1)
            {
                MXTextCheckingResult * result = [MXTextCheckingResult new];
                //add highlight keywords
                result.resultType = NSTextCheckingTypeRegularExpression;
                result.result = [_cleanText substringWithRange:NSMakeRange(range.location, range.length)];
                result.range = range;
                [_highLightedKeywords addObject:result];
            }
        }
    }];
    
    //parse "#"symbol
    [self.activityRegEx enumerateMatchesInString:_cleanText options:0 range:NSMakeRange(0, [_cleanText length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        
        if(match.numberOfRanges > 1)
        {
            NSRange range = [match rangeAtIndex:1];
            if(range.length > 1)
            {
                MXTextCheckingResult * result = [MXTextCheckingResult new];
                //add highlight keywords
                result.resultType = NSTextCheckingTypeRegularExpression;
                result.result = [_cleanText substringWithRange:NSMakeRange(range.location, range.length)];
                result.range = range;
                [_highLightedKeywords addObject:result];
            }
        }
    }];
    
    //parse http link
    NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink
                                                                   error:nil];
    NSRange range = NSMakeRange(0, _cleanText.length);
    NSArray* tmp = [linkDetector matchesInString:_cleanText options:0 range:range];
    
    for(NSTextCheckingResult* match in tmp)
    {
        MXTextCheckingResult * result = [MXTextCheckingResult new];
        result.range = match.range;
        result.resultType = NSTextCheckingTypeLink;
        result.result = [_cleanText substringWithRange:match.range];
        [_highLightedKeywords addObject:result];
    }
    
    //highlight keywords color
    for (MXTextCheckingResult* result in _highLightedKeywords)
    {
        [_mutableAttributeString setTextColor:self.linkColor range:result.range];
        
        if (result.resultType == NSTextCheckingTypeRegularExpression)
        {
             [_mutableAttributeString setFont:[UIFont boldSystemFontOfSize:self.textFont.pointSize] range:result.range];
        }
    }
    

   //get size
    [self calculateTextFrame];
}

/**
 add a link to user name and highlight it
 */
- (void)highlightKeywords:(NSArray*)keywords
{
    if (_mutableAttributeString.length == 0) {
        
        [self createAttributedString];
    }
    
    NSRange range;
    NSString* tmp = [self.cleanText copy];
    
    for (NSString* name in keywords)
    {
        range = [tmp rangeOfString:name];
        
        while (range.location != NSNotFound) {
            
            MXTextCheckingResult* result = [MXTextCheckingResult new];
            result.resultType = NSTextCheckingTypeRegularExpression;
            result.result = name;
            result.range = range;
            
            [self.highLightedKeywords addObject:result];
            [self highlightKeywordsInRange:range];
            
            //去掉关键字
            unichar emptyChars[range.length];
            
            for (int i=0; i<range.length; i++) {
                emptyChars[i] = ' ';
            }
            NSString *objectReplacementString = [NSString stringWithCharacters:emptyChars length:range.length];
            tmp = [tmp stringByReplacingCharactersInRange:range withString:objectReplacementString ];
            
            //递归
            range = [tmp rangeOfString:name];
        }
    }
}
/**
 bold user name
 */
- (void)boldKeywords:(NSArray*)keywords
{
    if (_mutableAttributeString.length == 0)
    {
        [self createAttributedString];
    }
    
    NSRange range;
    NSString* tmp = [self.cleanText copy];
    
    for (NSString* name in keywords)
    {
        range = [tmp rangeOfString:name];
        
        while (range.location != NSNotFound) {
            
            [self boldTextInRange:range];
            
            //去掉关键字
            unichar emptyChars[range.length];
            
            for (int i=0; i<range.length; i++) {
                emptyChars[i] = ' ';
            }
            NSString *objectReplacementString = [NSString stringWithCharacters:emptyChars length:range.length];
            tmp = [tmp stringByReplacingCharactersInRange:range withString:objectReplacementString ];
            
            //递归
            range = [tmp rangeOfString:name];
        }
    }
}
/**
 add a link to user name and highlight it
 */
- (void)highlightKeywordsInRange:(NSRange)range
{
    if (_mutableAttributeString.length == 0) {
        [self createAttributedString];
    }
    
    [_mutableAttributeString setTextColor:self.linkColor range:range];
    
    [self attributeChanged];
}

/**
 set text color in range
 */
- (void)setTextColor:(UIColor*)textColor InRange:(NSRange)range;
{
    if (_mutableAttributeString.length == 0) {
        [self createAttributedString];
    }
    
    [_mutableAttributeString setTextColor:textColor range:range];
    
    [self attributeChanged];
}
/**
 bold text in range
 */
- (void)boldTextInRange:(NSRange)range
{
    if (_mutableAttributeString.length == 0) {
        return;
    }
    
    CGFloat pointSize = self.textFont.pointSize;
    UIFont* boldFont = [UIFont boldSystemFontOfSize:pointSize];

    [_mutableAttributeString setFont:boldFont range:range];

    [self attributeChanged];
}

- (UIImage*)preRenderText:(CGSize)size
{
    BOOL opaque = [self colorIsOpaque:self.backgroundColor];
    CGSize imageSize = CGSizeZero;
    CGRect imageRect = CGRectZero;
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        
        imageSize = CGSizeMake(self.constraintTextWidth, self.constraintTextHeight);
        imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);

    }
    else
    {
        imageSize = size;
        imageRect = CGRectMake(0, 0, size.width, size.height);
    }

    UIImage *resultImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, opaque, 0);
    {
        //create a drawing context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
    
        if (_mutableAttributeString.length > 0)
        {
            CGContextSaveGState(context);
            CGContextClearRect(context, imageRect);
            
            //画背景
            if(self.backgroundColor != [UIColor clearColor])
            {
                CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
                CGContextFillRect(context, imageRect);
            }
            
            //reset text frame
            [self resetCTFrame];
     
            CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)_mutableAttributeString;
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedString);
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, nil, imageRect);
            _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CGPathRelease(path);
            CFRelease(framesetter);
            
            //coreText和UIKit的绘制路径相反
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, imageSize.height), 1.f, -1.f);
            CGContextConcatCTM(context, transform);
            
            //行
            CFArrayRef lines = CTFrameGetLines(_ctFrame);
            
            //行数
            CFIndex numberOfLines = CFArrayGetCount(lines);
            
            if(numberOfLines == 0) return nil;
            
            //画
            CGPoint lineOrigins[numberOfLines];
            CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOrigins);
            
            BOOL shouldDrawLine = YES;
            
            //考虑最后一行的截断
            for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
            {
                CGPoint lineOrigin = lineOrigins[lineIndex];
                CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
                CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
                
                //需要截断
                if (imageRect.size.height < self.constraintTextHeight && lineIndex == numberOfLines - 1)
                {
                    // Does the last line need truncation?
                    CFRange lastLineRange = CTLineGetStringRange(line);
                    if (lastLineRange.location + lastLineRange.length < (CFIndex)_mutableAttributeString.length) {
                        
                        CTLineTruncationType truncationType = kCTLineTruncationEnd;
                        NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                        
                        
                        //替换最后一个字符为省略号
                        NSDictionary *tokenAttributes = [_mutableAttributeString attributesAtIndex:truncationAttributePosition
                                                                                    effectiveRange:NULL];
                        NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:@"\u2026"
                                                                                          attributes:tokenAttributes];
                        CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
                        
                        NSMutableAttributedString *truncationString = [[_mutableAttributeString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                        
                        if (lastLineRange.length > 0)
                        {
                            // Remove any whitespace at the end of the line.
                            unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
                            if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter]) {
                                [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                            }
                        }
                        [truncationString appendAttributedString:tokenString];
                        
                        CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                        CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, imageRect.size.width, truncationType, truncationToken);
                        if (!truncatedLine) {
                            // If the line is not as wide as the truncationToken, truncatedLine is NULL
                            truncatedLine = CFRetain(truncationToken);
                        }
                        CFRelease(truncationLine);
                        CFRelease(truncationToken);
                        
                        CTLineDraw(truncatedLine, context);
                        CFRelease(truncatedLine);
                        
                        shouldDrawLine = NO;
                    }
                    
                }
                
                if (shouldDrawLine)
                    CTLineDraw(line, context);
            }
            
            //画image
            [self drawImages];

            CGContextRestoreGState(context);
            
        }

        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if (resultImage)
        {
//            [[ETImagePool currentImagePool] setImageInMemory:resultImage ForKey:[NSURL URLWithString:self.preRenderedImageCacheKey]];
//            [[ETImagePool currentImagePool] setImageInDisk:resultImage ForKey:[NSURL URLWithString:self.preRenderedImageCacheKey]];
            self.preRenderedImage = resultImage;
        }
        
    }
    UIGraphicsEndImageContext();
    
    return resultImage;
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (void)resetCTFrame
{
    if (nil!= _ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

-(void)clearAttrString
{
	if(_attrString)
    {
		CFRelease(_attrString);
		_attrString = nil;
    }
    
    if (_mutableAttributeString) {
        _mutableAttributeString = nil;
    }
}

- (void)attributeChanged
{
    [self calculateTextFrame];
}

- (void)calculateTextFrame
{
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(_attrString);
    
    CFRange range = CFRangeMake(0, _mutableAttributeString.length);
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, CGSizeMake(self.constraintTextWidth, CGFLOAT_MAX), &fitCFRange);
    
    _constraintTextHeight = newSize.height;
    

    CGMutablePathRef path = CGPathCreateMutable();
    //上下颠倒，左右颠倒
    CGPathAddRect(path, nil, CGRectMake(0, 0, _constraintTextWidth, _constraintTextHeight));

    if(_ctFrame){CFRelease(_ctFrame); _ctFrame = nil;};
        _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, CFAttributedStringGetLength(_attrString)), path, NULL);
   
    CGPathRelease(path);
    CFRelease(framesetter);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onAttributeStringFinishedParsing:)]) {
        [self.delegate onAttributeStringFinishedParsing:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetAscentCallbackForParser(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;

    return labelImage.boxSize.height - labelImage.fontDescent;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetDescentCallbackForParser(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;
    
    return labelImage.fontDescent;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetWidthCallbackForParser(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;
    
    if (!CGSizeEqualToSize(labelImage.size, CGSizeZero) ) {
        return labelImage.size.width + labelImage.margins.left+labelImage.margins.right;
    }
    else
        return labelImage.image.size.width + labelImage.margins.left + labelImage.margins.right;
}

- (BOOL)colorIsOpaque:(UIColor *)color
{
    CGFloat alpha = -1.0f;
    [color getRed:NULL green:NULL blue:NULL alpha:&alpha];
    
    BOOL wrongColorSpace = (alpha == -1.0f);
    if (wrongColorSpace)
    {
        [color getWhite:NULL alpha:&alpha];
    }
    
    return (alpha == 1.0f);
}

- (void)drawImages
{
    if (0 == _attributeImages.count) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
    CFIndex numberOfLines = CFArrayGetCount(lines);
    
    for (CFIndex i = 0; i < numberOfLines; i++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[i];
        CGFloat lineAscent;
        CGFloat lineDescent;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
        //CGFloat lineHeight = lineAscent + lineDescent;
        CGFloat lineBottomY = lineOrigin.y - lineDescent;
        
        // Iterate through each of the "runs" (i.e. a chunk of text) and find the runs that
        // intersect with the range.
        for (CFIndex k = 0; k < runCount; k++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
            if (nil == delegate) {
                continue;
            }
            ETUIAttributeImageParser* labelImage = (__bridge ETUIAttributeImageParser *)CTRunDelegateGetRefCon(delegate);
            
            CGFloat ascent = 0.0f;
            CGFloat descent = 0.0f;
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                               CFRangeMake(0, 0),
                                                               &ascent,
                                                               &descent,
                                                               NULL);
            
            CGFloat imageBoxHeight = labelImage.boxSize.height;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
            
            CGFloat imageBoxOriginY = 0.0f;
            
            imageBoxOriginY = lineBottomY;
            
            CGRect rect = CGRectMake(lineOrigin.x + xOffset, imageBoxOriginY, width, imageBoxHeight);
            UIEdgeInsets flippedMargins = labelImage.margins;
            CGFloat top = flippedMargins.top;
            flippedMargins.top = flippedMargins.bottom;
            flippedMargins.bottom = top;
            
            CGRect imageRect = UIEdgeInsetsInsetRect(rect, flippedMargins);
            CGContextDrawImage(ctx, imageRect, labelImage.image.CGImage);
        }
    }
}

@end
