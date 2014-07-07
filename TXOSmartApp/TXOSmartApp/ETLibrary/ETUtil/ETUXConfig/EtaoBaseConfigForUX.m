//
//  EtaoBaseConfigForUX.m
//  etaoLocal
//
//  Created by 稳 张 on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 * maintained by moxin.xt
 */

#import "EtaoBaseConfigForUX.h"


@implementation EtaoBaseConfigForUX

+ (UIFont*)getFontSizeOf24:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:24];
    }
    else
        return [UIFont systemFontOfSize:24];
}

+ (UIFont*)getFontSizeOf17:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:17];
    }
    else
        return [UIFont systemFontOfSize:17];
}
+ (UIFont*)getFontSizeOf16:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:16];
    }
    else
        return [UIFont systemFontOfSize:16];
}
+ (UIFont*)getFontSizeOf14:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:14];
    }
    else
        return [UIFont systemFontOfSize:14];
}
+ (UIFont*)getFontSizeOf13:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:13];
    }
    else
        return [UIFont systemFontOfSize:13];
}

+ (UIFont*)getFontSizeOf12:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:12];
    }
    else
        return [UIFont systemFontOfSize:12];
}

+ (UIFont*)getFontSizeOf10:(BOOL) bold
{
    if (bold) {
        return [UIFont boldSystemFontOfSize:10];
    }
    else
        return [UIFont systemFontOfSize:10];
}

//深红
+ (UIColor *)darkRedColor{
    return [UIColor colorWithRed:172/255.0 green:45/255.0 blue:0 alpha:1.0];
}

//灰色
+ (UIColor *)grayColor{
    return [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0];
}

//深灰
+(UIColor*) getDarkGrayColor
{
    return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
}
//淡灰
+(UIColor*) getLightGrayColor
{
    return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
}
//淡红
+(UIColor*) getLightRedColor
{
    return [UIColor colorWithRed:82/255.0 green:155/255.0 blue:192/255.0 alpha:1.0];
}
//淡黄
+(UIColor*) getLightYellowColor
{
    return [UIColor colorWithRed:255/255.0 green:115/255.0 blue:1/255.0 alpha:1.0];
}

//黄
+(UIColor*) getDarkYellowColor
{
    return [UIColor colorWithRed:253/255.0 green:242/255.0 blue:230/255.0 alpha:1.0];
}
//黑色
+(UIColor*) getBlackColor
{
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}
//深黑
+(UIColor*)getDarkBlackColor
{
    return [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
}

//蓝
+(UIColor*) getLightBlueColor
{
    return [UIColor colorWithRed:117.0/255.0 green:156.0/255.0 blue:169.0/255.0 alpha:1.0f];
}
//深白灰
+(UIColor*) getDarkWhiteColor
{
    return [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
}
/*-----------------------------alertView背景-----------------------*/
//+(UIColor*) getAlertViewColor
//{
//    return [UIColor colorWithRed:46.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
//}
+(UIColor*) getAlertViewColor
{
    return [UIColor colorWithRed:33.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:0.9];
}

/*-----------------------------controller背景-----------------------*/

+ (UIColor*) getControllerBackgroundColor
{
    return [UIColor grayColor];
}

+ (UIImage*) getNavigationBarImage
{
    return [UIImage imageNamed:@"top_bar.png"];
    
}


+ (CGSize) sizeOfView:(NSString *)text atFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(320.0, CGFLOAT_MAX);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size;
}

+ (CGSize) sizeOfView:(NSString *)text atFont:(UIFont *)font atWidth:(CGFloat) width
{
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size;
}
//
////针对nsmutableAttributeString
+ (CGSize) sizeOfView:(NSString*)text atFont:(UIFont *)font atWidth:(CGFloat) width atLineHeight:(CGFloat)lineHeight
{
    //1,convert nsstring to nsmutableAttributeString
    if(text.length == 0 || ![text isKindOfClass:[NSString class]])
        return CGSizeZero;
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString setFont:font];
    
    CTTextAlignment textAlignment = kCTLeftTextAlignment;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;

    //put some attributes on string
    [attributedString setTextAlignment:textAlignment lineBreakMode:lineBreak lineHeight:lineHeight];

    
    //2, detect 

   // calculate the size of nsmutablestring
    
    if (nil == attributedString) {
        return CGSizeZero;
    }
    
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)attributedString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
    CFRange range = CFRangeMake(0, 0);

    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, CGSizeMake(width, CGFLOAT_MAX), &fitCFRange);
    
    if (nil != framesetter) {
        CFRelease(framesetter);
        framesetter = nil;
    }
    
    return CGSizeMake(ceilf(newSize.width), ceilf(newSize.height));
   
    
}

@end
