//
//  ETSystemUtil.h
//  etaoshopping
//
//  Created by moxin.xt on 12-10-16.
//
//

#import <Foundation/Foundation.h>
#import "ETNetworkMonitor.h"



typedef enum
{
    ETImageQuality_600 = 0,
    ETImageQuality_430,
    ETImageQuality_300,
    ETImageQuality_180,
    ETImageQuality_120,
    
}ETImageQuality;

@interface ETSystemUtil : NSObject

//////////////////////////////////////////////////////////////////////////////////////////
/*
 * 当前版本
 */
+ (float)           getSystemVersion;
/*
 * 当前系统语言
 */
+ (NSString*)       getSystemLanguage;
/*
 * 图片cdn前缀
 */
+ (NSString*)       getCDNHeaderUrl;
/*
 * 图片cdn后缀
 */
+ (NSString*)       getCDNFooterUrl : (ETImageQuality)quality;
/*
 * 图片合法的urlstring
 */
+ (NSString*)       getCDNImageUrlString:(NSString*)urlStr Quality:(ETImageQuality)quality;
/*
 * 网络是否开关
 */
+ (BOOL)            getNetworkEnabled;
/*
 * 网络类型
 */
+ (ETNetworkStatus)  getNetworkStatus;


//////////////////////////////////////////////////////////////////////////////////////////
//k,m
+ (NSString *)number2String:(int64_t)n;

//去除string中的html标签
+ (NSString *)cleanHtmlLabelForString:(NSString*)srcString;


@end
