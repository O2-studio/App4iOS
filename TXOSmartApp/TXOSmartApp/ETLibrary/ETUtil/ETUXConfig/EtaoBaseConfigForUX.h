//
//  EtaoBaseConfigForUX.h
//  etaoLocal
//
//  Created by 稳 张 on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EtaoBaseConfigForUX : NSObject



/*
 * 各种字号
 */
+ (UIFont*)getFontSizeOf24:(BOOL) bold;

+ (UIFont*)getFontSizeOf17:(BOOL) bold;

+ (UIFont*)getFontSizeOf16:(BOOL) bold;

+ (UIFont*)getFontSizeOf14:(BOOL) bold;

+ (UIFont*)getFontSizeOf13:(BOOL) bold;

+ (UIFont*)getFontSizeOf12:(BOOL) bold;

+ (UIFont*)getFontSizeOf10:(BOOL) bold;

/*
 * 各种纯色
 */
//灰色
+ (UIColor *)grayColor;
//深红
+ (UIColor *)darkRedColor;
//黑
+(UIColor*) getBlackColor;
//深黑
+(UIColor*)getDarkBlackColor;
//深灰
+(UIColor*) getDarkGrayColor;
//淡灰
+(UIColor*) getLightGrayColor;
//淡红
+(UIColor*) getLightRedColor;
//淡黄
+(UIColor*) getLightYellowColor;
//黄
+(UIColor*) getDarkYellowColor;
//深白灰
+(UIColor*) getDarkWhiteColor;
//蓝
+(UIColor*) getLightBlueColor;
/*
 * alertView背景
 */
+(UIColor*) getAlertViewColor;

/*
 * controller背景
 */
+ (UIColor*) getControllerBackgroundColor;

/*
 * navigationBar背景
 */
+ (UIImage*) getNavigationBarImage;

/*
 *根据给定的font返回size，宽度默认为320
 */
+ (CGSize) sizeOfView:(NSString *) text atFont:(UIFont*) font;

/*
 *根据给定的font返回size，指定宽度
 */
+ (CGSize) sizeOfView:(NSString *)text atFont:(UIFont *)font atWidth:(CGFloat) width;
/*
 *根据给定的font返回size，指定宽度，行高，主要用于计算ETUIAwesomeLabel的文字szie
 */
+ (CGSize) sizeOfView:(NSString*)text atFont:(UIFont *)font atWidth:(CGFloat) width atLineHeight:(CGFloat)lineHeight;
/**

 */

@end
