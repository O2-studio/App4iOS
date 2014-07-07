//
//  ETUIAttributeLabel.m
//  ETShopping
//
//  Created by moxin.xt on 13-4-5.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETUIAttributeLabel.h"





@interface ETUIAttributeLabel()
{
    BOOL _isDetectingImages;
    BOOL _isDetectingKeywords;
}


@property (nonatomic, strong) NSString* cleanText;
@property (nonatomic, strong) NSMutableAttributedString* mutableAttributedString;
@property (nonatomic, assign) CTFrameRef        ctFrame;
@property (nonatomic, assign) CTFramesetterRef  ctFramesetter;
@property (nonatomic, assign) CTTextAlignment   ctTextAlignment;
@property (nonatomic, assign) CTLineBreakMode   ctLineBreakMode;

@property (nonatomic,assign) BOOL isDetectingImages;
@property (nonatomic,assign) BOOL isDetectingKeywords;
@property (nonatomic,assign) BOOL imagesHaveBeenDetected;
@property (nonatomic,assign) BOOL linksHaveBeenDetected;
@property (nonatomic, strong) MXTextCheckingResult* originalLink;
@property (nonatomic, strong) MXTextCheckingResult* touchedLink;
@property (nonatomic, assign) CGPoint touchPoint;


@end

@implementation ETUIAttributeLabel

@synthesize attributedString    = _attributedString;
@synthesize highLightedKeywords = _highLightedKeywords;

//@synthesize parser = _parser;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self.mutableAttributedString setTextColor:textColor];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    [self.mutableAttributedString setFont:textFont];
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight = lineHeight;
    
    if (nil != self.mutableAttributedString) {
       
        [self.mutableAttributedString setTextAlignment:_ctTextAlignment lineBreakMode:_ctLineBreakMode lineHeight:_lineHeight];
    }
}

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

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (self.mutableAttributedString != attributedString) {
        _mutableAttributedString = [attributedString mutableCopy];
    }

    self.linksHaveBeenDetected  = YES;
    self.imagesHaveBeenDetected = YES;
    self.isDetectingImages  = NO;
    self.isDetectingKeywords = NO;
    
    if (!self.usePreRenderedImage) {
        [self _prepareToRedraw];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    _cleanText = text;
    
    //create mutableAttributedString
    [self _createAttributedString];
    //clear attribute images
    [self.attributedImages removeAllObjects];
    //clear highlighted keywords
    [self.highLightedKeywords removeAllObjects];
    //clear flags
    self.linksHaveBeenDetected = NO;
    self.imagesHaveBeenDetected = NO;
    self.isDetectingKeywords = NO;
    self.isDetectingImages = NO;
    //prepare to redraw
    if (!self.usePreRenderedImage) {
        [self _prepareToRedraw];
    }
}




-(void)setFrame:(CGRect)frame
{
    BOOL zeroFrame = CGRectEqualToRect(frame, CGRectZero);
    
    if (zeroFrame) {
        [super setFrame:frame];
    }
    else
    {
        BOOL frameDidChange =  !CGRectEqualToRect(self.frame, frame);
        
        [super setFrame:frame];
        
        if (frameDidChange && !zeroFrame) {
            
            if (!self.usePreRenderedImage) {
                [self _prepareToRedraw];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters


- (NSAttributedString*)attributedString
{
    if (self.mutableAttributedString) {
        return [self.mutableAttributedString copy];
    }
    else
        return _attributedString;

}
- (NSMutableArray*)attributedImages
{
    if(!_attributedImages)
        _attributedImages = [NSMutableArray new];
    
    return _attributedImages;
}

- (NSMutableArray*)highLightedKeywords
{
    if(!_highLightedKeywords)
        _highLightedKeywords = [NSMutableArray new];
    
    return _highLightedKeywords;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.shouldDetectImages   = YES;
        self.shouldDetectKeyWords = YES;
        self.lineHeight = 20;
        self.linkColor = [EtaoBaseConfigForUX getLightBlueColor];
        self.textColor = [EtaoBaseConfigForUX getBlackColor];
        self.textFont  = [EtaoBaseConfigForUX getFontSizeOf14:NO];
        self.lineBreakMode = UILineBreakModeWordWrap;
        self.textAlignment = UITextAlignmentLeft;
        self.numberOfLines = 0;
        self.constraintTextWidth = 320;
        self.highlightedLinkBackgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        
        NSError *error = NULL;
		self.userNameRegEx = [NSRegularExpression regularExpressionWithPattern:@"(@[(\\w-)]+)" options:NSRegularExpressionCaseInsensitive error:&error];
        self.activityRegEx = [NSRegularExpression regularExpressionWithPattern:@"(#([^#]+)#)" options:NSRegularExpressionCaseInsensitive error:&error];
        self.imageRegEx = [NSRegularExpression regularExpressionWithPattern:@"(\\[([^\\]\\[]+)\\])" options:NSRegularExpressionCaseInsensitive error:&error];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
    if (nil != _ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public


- (void)addHighLightedKeywords:(NSArray*)highLightedKeywords
{
    if (self.text.length == 0) {
        
        return;
    }
    
    if (!self.mutableAttributedString) {
        [self _createAttributedString];
    }
    NSRange range;
    
    NSString* tmp = [[self.mutableAttributedString string] copy];
        
    for (NSString* name in highLightedKeywords)
    {
        
        range = [tmp rangeOfString:name];
        
        while (range.location != NSNotFound)
        {
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

- (void)highlightKeywordsInRange:(NSRange)range
{
    if (self.text.length == 0) {
        
        return;
    }
    
    if (!self.mutableAttributedString) {
        [self _createAttributedString];
    }
    
    [self.mutableAttributedString setTextColor:self.linkColor range:range];
    
    [self _prepareToRedraw];
    //[self _attributedStringDidChange];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - uiview
/**
 very simple drawing
 */

- (void)drawRect:(CGRect)rect
{
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return [super drawRect:rect];
    }
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    if (self.attributedString.length > 0)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextClearRect(context, rect);
        
        //画背景
        if(self.backgroundColor != [UIColor clearColor])
        {
            CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
            CGContextFillRect(context, rect);
        }

    
        //coreText和UIKit的绘制路径相反
        CGAffineTransform transform = [self _transformForCoreText];
        CGContextConcatCTM(context, transform);

        if (!_ctFrame) {
            CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)self.mutableAttributedString;
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedString);
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, nil, rect);
            _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CGPathRelease(path);
            CFRelease(framesetter);

        }
           
        //行
        CFArrayRef lines = CTFrameGetLines(_ctFrame);
        //行数
        CFIndex numberOfLines = CFArrayGetCount(lines);

        if(numberOfLines == 0) return;
        
        //画
        CGPoint lineOrigins[numberOfLines];
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOrigins);
        
        //不考虑最后一行的截断
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
        {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            CTLineDraw(line, context);
        }

        //画image
        [self drawImages];
        
        //画highlight background
        [self drawHighlightWithRect:rect];
        
        CGContextRestoreGState(context);

    }
    else
    {
        [super drawRect:rect];
    }
  
    NSLog(@"coreText drawing: %.2fms",1000.0*(CFAbsoluteTimeGetCurrent()-startTime));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - background drawing

- (void)_drawInBackground:(CGRect)rect
{
//    if (self.isInBackgroundDrawing || CGRectEqualToRect(rect, CGRectZero)) {
//        
//        return;
//    }
//    
//    self.isInBackgroundDrawing = YES;
//    
//    //BOOL opaque = self.backgroundColor == [UIColor clearColor] ? NO:YES;
//    
//    [[ETAsyncDrawingCache sharedInstance] drawViewAsyncWithCacheKey:self.key size:rect.size backgroundColor:self.backgroundColor drawBlock:^(CGRect rect) {
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        CGContextClearRect(context, rect);
//        
//        //画背景
//        if(self.backgroundColor != [UIColor clearColor])
//        {
//            CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
//            CGContextFillRect(context, rect);
//        }
//        
//        
//        //coreText和UIKit的绘制路径相反
//        CGAffineTransform transform = [self _transformForCoreText];
//        CGContextConcatCTM(context, transform);
//        
//        if (!_ctFrame) {
//            [self _calculateTextFrame];
//        }
//        //行
//        CFArrayRef lines = CTFrameGetLines(_ctFrame);
//        //行数
//        CFIndex numberOfLines = CFArrayGetCount(lines);
//        
//        if(numberOfLines == 0) return;
//        
//        //画
//        CGPoint lineOrigins[numberOfLines];
//        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOrigins);
//        
//        //不考虑最后一行的截断
//        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
//        {
//            CGPoint lineOrigin = lineOrigins[lineIndex];
//            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
//            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
//            CTLineDraw(line, context);
//        }
//        
//        //画image
//        [self drawImages];
//
//        CGContextRestoreGState(context);
//
//        
//    } completionBlock:^(UIImage *drawnImage, NSString *cacheKey) {
//        
//        if (drawnImage && [self.key isEqualToString:cacheKey]) {
//            
//            self.layer.contents = (id)drawnImage.CGImage;
//        }
//        else
//            self.layer.contents = nil;
//            
//            self.isInBackgroundDrawing = NO;
//    }];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

//draw highlight keywords
- (void)drawHighlightWithRect:(CGRect)rect
{
    if ((nil == self.touchedLink ) || nil == self.highlightedLinkBackgroundColor)
    {
        return;
    }
    [self.highlightedLinkBackgroundColor setFill];
    
    NSRange linkRange = self.touchedLink.range;
    
    //获得所有行信息
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    
    //获得行数
    CFIndex count = CFArrayGetCount(lines);
    
    //存放起始行坐标数组
    CGPoint lineOrigins[count];
    
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    //begin drawing
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (CFIndex i = 0; i < count; i++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CFRange stringRange = CTLineGetStringRange(line);
        NSRange lineRange = NSMakeRange(stringRange.location, stringRange.length);
        NSRange intersectedRange = NSIntersectionRange(lineRange, linkRange);
        if (intersectedRange.length == 0) {
            continue;
        }
        
        /**
         moxin:lineOrigin的计算有些问题，用下面公式取代:(i * 行高 + 行间距)
         moxin:不对，是我自己搞错了：(
         */
//        CGPoint lineOrigin = CGPointMake(0, i*self.parser.lineHeight + (self.parser.lineHeight - self.parser.textFont.pointSize));

        CGRect highlightRect = [self _rectForRange:linkRange inLine:line lineOrigin:lineOrigins[i]];

        highlightRect = CGRectOffset(highlightRect, 0, -rect.origin.y);
        
        if (!CGRectIsEmpty(highlightRect)) {

            CGFloat radius = 5.0f;
            drawRoundCornerForRect(ctx, highlightRect, radius, self.highlightedLinkBackgroundColor, nil);
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - copied from NIAttributeLabel
- (void)drawImages
{
    if (0 == self.attributedImages.count) {
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
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //  [super touchesBegan:touches withEvent:event];
    
    [self resetCTFrame];
    [self _calculateTextFrame];

    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.touchedLink = [self linkAtPoint:point];
    self.touchPoint = point;
    self.originalLink = self.touchedLink;
    
    [self setNeedsDisplay];
    
    if (!self.touchedLink) {
        [super touchesBegan:touches withEvent:event];
    }

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesMoved:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // If the user moves their finger away from the original link, deselect it.
    // If the user moves their finger back to the original link, reselect it.
    // Don't allow other links to be selected other than the original link.
    
    if (nil != self.originalLink) {
        MXTextCheckingResult* oldTouchedLink = self.touchedLink;
        
        if ([self isPoint:point nearLink:self.originalLink])
        {
            self.touchedLink = self.originalLink;
            
        } else {
            self.touchedLink = nil;
        }
        
        if (oldTouchedLink != self.touchedLink)
        {
            
            [self setNeedsDisplay];
        }
    }
    if (!self.touchedLink) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (nil != self.originalLink)
    {
        if ([self isPoint:point nearLink:self.originalLink])
        {
            if([self.delegate respondsToSelector:@selector(onAttributeLableDidSelectKeyword:AtLocation:)])
                [self.delegate onAttributeLableDidSelectKeyword:self.originalLink.result AtLocation:self.originalLink.range.location];
        }
    }
    
    self.touchedLink = nil;
    self.originalLink = nil;
    
    [self setNeedsDisplay];
    
    if (!self.touchedLink) {
        [super touchesEnded:touches withEvent:event];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    
    self.touchedLink = nil;
    self.originalLink = nil;
    
    [self setNeedsDisplay];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (void)_attributedStringDidChange
{
    //clear old ctFrame
    [self resetCTFrame];
    //calculate new ctFrame
    [self _calculateTextFrame];
    
    
//    if (self.asyncDrawing) {
//        
//        [self _drawInBackground:rect];
//        
//    }
//    else
    //draw directly
    [self setNeedsDisplay];
    
}

- (void)_prepareToRedraw
{
    if (self.deferDetection) {
        
        [[ETThread sharedInstance] enqueueInBackground:^{
            
            [self _detect];
            
            [[ETThread sharedInstance] enqueueOnMainThread:^{
               
                [self _attributedStringDidChange];
            }];
        }];
    }
    else
    {
        //parse elements
        [self _detect];
    }
    
    
    [self _attributedStringDidChange];
}

- (void)resetCTFrame
{
    if (nil!= self.ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}


- (CGAffineTransform)_transformForCoreText {
    // CoreText context coordinates are the opposite to UIKit so we flip the bounds
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MXTextCheckingResult *)linkAtPoint:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectInset(self.bounds, 0, -5.0), point)) {
        return nil;
    }
    
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    if (!lines) return nil;
    CFIndex count = CFArrayGetCount(lines);
    
    MXTextCheckingResult* foundLink = nil;
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0,0), origins);
    
    CGAffineTransform transform = [self _transformForCoreText];
    CGFloat verticalOffset = 0;
    
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, -5.0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            foundLink = [self linkAtIndex:idx];
            if (foundLink) {
                return foundLink;
            }
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint) point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y - descent, width, height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (MXTextCheckingResult *)linkAtIndex:(CFIndex)i
{
    MXTextCheckingResult* foundResult = nil;
   
    for (MXTextCheckingResult* result in self.highLightedKeywords)
    {
        if (NSLocationInRange(i, result.range)) {
            foundResult = result;
            break;
        }
    }
   
    return foundResult;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isPoint:(CGPoint)point nearLink:(MXTextCheckingResult *)link {
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    if (nil == lines) {
        return NO;
    }
    CFIndex count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    CGAffineTransform transform = [self _transformForCoreText];
    CGFloat verticalOffset = 0;
    
    NSRange linkRange = link.range;
    
    BOOL isNearLink = NO;
    for (int i = 0; i < count; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect linkRect = [self _rectForRange:linkRange inLine:line lineOrigin:lineOrigins[i]];
        
        if (!CGRectIsEmpty(linkRect)) {
            linkRect = CGRectApplyAffineTransform(linkRect, transform);
            linkRect = CGRectOffset(linkRect, 0, verticalOffset);
            linkRect = CGRectInset(linkRect, -22, -22);
            if (CGRectContainsPoint(linkRect, point)) {
                isNearLink = YES;
                break;
            }
        }
    }
    
    return isNearLink;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)_rectForRange:(NSRange)range inLine:(CTLineRef)line lineOrigin:(CGPoint)lineOrigin
{
    
    CGRect rectForRange = CGRectZero;
    //获得每行的字数
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    //获得每行字的个数
    CFIndex runCount = CFArrayGetCount(runs);
    
    //遍历每行字
    for (CFIndex k = 0; k < runCount; k++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        
        CFRange stringRunRange = CTRunGetStringRange(run);
        NSRange lineRunRange = NSMakeRange(stringRunRange.location, stringRunRange.length);
        NSRange intersectedRunRange = NSIntersectionRange(lineRunRange, range);
        
        if (intersectedRunRange.length == 0) {
            // This run doesn't intersect the range, so skip it.
            continue;
        }
        
        //找到range对应的区域
        CGFloat ascent = 0.0f;
        CGFloat descent = 0.0f;
        CGFloat leading = 0.0f;
        
        //rect的宽度
        CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                           CFRangeMake(0, 0),
                                                           &ascent,
                                                           &descent,
        
                                                           NULL); //&leading);
        
        //rect高度
        CGFloat height = ascent + descent;
        
        //x的便宜
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
        
        //y的偏移为lineOrign.y
        CGRect linkRect = CGRectMake(lineOrigin.x + xOffset - leading, lineOrigin.y - descent, width + leading, height);
        
        linkRect = CGRectIntegral(linkRect);
        linkRect = CGRectInset(linkRect, -2, 0);
        
        if (CGRectIsEmpty(rectForRange)) {
            rectForRange = linkRect;
            
        } else {
            rectForRange = CGRectUnion(rectForRange, linkRect);
        }
    }
    
    return rectForRange;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)_calculateTextFrame
{
   
    if (!self.mutableAttributedString) {
        return;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(self.mutableAttributedString));
    
    
    CFRange range = CFRangeMake(0, self.mutableAttributedString.length);
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, CGSizeMake(self.constraintTextWidth, CGFLOAT_MAX), &fitCFRange);
    
    _constraintTextHeight = newSize.height;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    //上下颠倒，左右颠倒
//    CGAffineTransform reverseT = CGAffineTransformIdentity;
//    reverseT = CGAffineTransformScale(reverseT, 1.0, -1.0);
//    reverseT = CGAffineTransformTranslate(reverseT, 0.0, -_constraintTextHeight);
//    
//    
//    //draw的路径
//    CGPathAddRect(path, nil, CGRectApplyAffineTransform(CGRectMake(0, 0, _constraintTextWidth, _constraintTextHeight), reverseT));
    CGPathAddRect(path, nil, self.frame);
    
    //CGPathAddRect(path, nil, CGRectMake(0, 0, _constraintTextWidth, _constraintTextHeight));
    
    [self resetCTFrame];
    _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, CFAttributedStringGetLength((__bridge CFAttributedStringRef)(self.mutableAttributedString))), path, NULL);
    
    CGPathRelease(path);
    CFRelease(framesetter);

}

- (void)_createAttributedString
{
    if ([self.text isKindOfClass:[NSString class]] && self.text.length > 0)
    {
        self.mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
        [self.mutableAttributedString setTextColor:self.textColor];
        [self.mutableAttributedString setFont:self.textFont];
        [self.mutableAttributedString setTextAlignment:_ctTextAlignment lineBreakMode:_ctLineBreakMode lineHeight:self.lineHeight];
    }
}

- (void)_detect
{
    if (!self.mutableAttributedString) {
        return;
    }
    
    if (self.shouldDetectImages && !self.imagesHaveBeenDetected && !self.isDetectingImages) {
        
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        [self _detectImages];
        
        NSLog(@"detect image: %.2fms",1000.0*(CFAbsoluteTimeGetCurrent()-startTime));
    }
    
    if (self.shouldDetectKeyWords && !self.linksHaveBeenDetected && !self.isDetectingKeywords) {
        
         CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        [self _detectKeywords];
         NSLog(@"detect keywords: %.2fms",1000.0*(CFAbsoluteTimeGetCurrent()-startTime));
    }
}

- (void)_detectImages
{
    
    self.isDetectingImages = YES;
    
    //Parse image
    [self.imageRegEx enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, self.text.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        
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
                [self.attributedImages addObject:labelImage];
            }
        }
    }];
    

    //parse image
    if (self.attributedImages.count > 0)
    {
        // Sort the label images in reverse order by index so that when we add them the string's indices
        // remain relatively accurate to the original string. This is necessary because we're inserting
        // spaces into the string.
        [self.attributedImages sortUsingComparator:^NSComparisonResult(ETUIAttributeImageParser* obj1, ETUIAttributeImageParser*  obj2) {
            if (obj1.index < obj2.index) {
                return NSOrderedDescending;
            } else if (obj1.index > obj2.index) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        for (ETUIAttributeImageParser *labelImage in self.attributedImages)
        {
            CTRunDelegateCallbacks callbacks;
            memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
            callbacks.version = kCTRunDelegateVersion1;
            callbacks.getAscent  = ImageDelegateGetAscentCallback;
            callbacks.getDescent = ImageDelegateGetDescentCallback;
            callbacks.getWidth   = ImageDelegateGetWidthCallback;
            
            NSUInteger index = labelImage.index;
            if (index >= self.mutableAttributedString.length) {
                index = self.mutableAttributedString.length - 1;
            }
            
            NSDictionary *attributes = [self.mutableAttributedString attributesAtIndex:index effectiveRange:NULL];
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
            [self.mutableAttributedString replaceCharactersInRange:labelImage.range withAttributedString:space];
        }
    }
    
    
    //set flags
    self.imagesHaveBeenDetected = YES;
    self.isDetectingImages = NO;
    
}
- (void)_detectKeywords
{
    
    self.isDetectingKeywords = YES;
    
    //reset text
    NSString* tmp  = [self.mutableAttributedString string];
    
    
    //parse "@"symbol
    [self.userNameRegEx enumerateMatchesInString:tmp options:0 range:NSMakeRange(0, [tmp length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        if(match.numberOfRanges > 1)
        {
            NSRange range = [match rangeAtIndex:1];
            if(range.length > 1)
            {
                MXTextCheckingResult * result = [MXTextCheckingResult new];
                //add highlight keywords
                result.resultType = NSTextCheckingTypeRegularExpression;
                result.result = [tmp substringWithRange:NSMakeRange(range.location, range.length)];
                result.range = range;
                [_highLightedKeywords addObject:result];
            }
        }
    }];
    
    //parse "#"symbol
    [self.activityRegEx enumerateMatchesInString:tmp options:0 range:NSMakeRange(0, [tmp length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        
        if(match.numberOfRanges > 1)
        {
            NSRange range = [match rangeAtIndex:1];
            if(range.length > 1)
            {
                MXTextCheckingResult * result = [MXTextCheckingResult new];
                //add highlight keywords
                result.resultType = NSTextCheckingTypeRegularExpression;
                result.result = [tmp substringWithRange:NSMakeRange(range.location, range.length)];
                result.range = range;
                [_highLightedKeywords addObject:result];
            }
        }
    }];
    
    //parse http link
    //  NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
    
    //                                                                 error:nil];
    
    
    NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:nil];
    NSRange range = NSMakeRange(0, tmp.length);
    NSArray* tmps = [linkDetector matchesInString:tmp options:0 range:range];
    
    for(NSTextCheckingResult* match in tmps)
    {
        MXTextCheckingResult * result = [MXTextCheckingResult new];
        result.range = match.range;
        result.resultType = NSTextCheckingTypeLink;
        result.result = [tmp substringWithRange:match.range];
        [_highLightedKeywords addObject:result];
    }
    
    //highlight keywords color
    for (MXTextCheckingResult* result in _highLightedKeywords)
    {
        [self.mutableAttributedString setTextColor:self.linkColor range:result.range];
        
        if (result.resultType == NSTextCheckingTypeRegularExpression)
        {
            [self.mutableAttributedString setFont:[UIFont boldSystemFontOfSize:self.textFont.pointSize] range:result.range];
        }
    }
    
    //set flag
    self.linksHaveBeenDetected = YES;
    self.isDetectingKeywords = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetAscentCallback(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;
    
    return labelImage.boxSize.height - labelImage.fontDescent;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetDescentCallback(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;
    
    return labelImage.fontDescent;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat ImageDelegateGetWidthCallback(void* refCon)
{
    ETUIAttributeImageParser *labelImage = (__bridge ETUIAttributeImageParser *)refCon;
    
    if (!CGSizeEqualToSize(labelImage.size, CGSizeZero) ) {
        return labelImage.size.width + labelImage.margins.left+labelImage.margins.right;
    }
    else
        return labelImage.image.size.width + labelImage.margins.left + labelImage.margins.right;

}
@end

