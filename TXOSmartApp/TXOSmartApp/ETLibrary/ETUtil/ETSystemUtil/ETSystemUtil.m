//
//  ETSystemUtil.m
//  etaoshopping
//
//  Created by moxin.xt on 12-10-16.
//
//

#import "ETSystemUtil.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define KB	(1024)
#define MB	(KB * 1024)
#define GB	(MB * 1024)

@interface ETSystemUtil()
{
}


@end

@implementation ETSystemUtil
{
 
}

+ (BOOL)getNetworkEnabled
{
    ETNetworkStatus status = [self getNetworkStatus];
    return status == kETNetworkStatus_NotReachable ? NO : YES;
}
+ (ETNetworkStatus)   getNetworkStatus
{
    return [ETNetworkMonitor getNetworkStatus];
}

+ (NSString*) getSystemLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"[ETSystemUtil]-->system language:%@", preferredLang);
    
    return preferredLang;
}

+ (NSString*) getCDNHeaderUrl
{
//#ifdef __WAP_TEST__
//    return @"http://img01.daily.taobaocdn.net/tfscom/";
//#else
//    return @"http://tu04.tbcdn.cn/tps/";
//#endif
    
    return @"http://tu04.tbcdn.cn/tps/";
//    return @"http://img01.daily.taobaocdn.net/tfscom/";

}

//红色类目图标
+ (NSString*) getCategory1HeaderUrl
{
    return @"http://a.tbcdn.cn/apps/etaoshopping/apps/ios/images/category1/";
}

//灰色类目图标
+ (NSString*) getCategory2HeaderUrl
{
    return @"http://a.tbcdn.cn/apps/etaoshopping/apps/ios/images/category2/";
}

+ (NSString*) getCDNFooterUrl : (ETImageQuality)quality
{
    
    NSString* str = @"";
    
    switch (quality)
    {
        case ETImageQuality_600:
        {
            str = @"_600x600.jpg_.webp";
            break;
        }
        case ETImageQuality_430:
        {
            str = @"_430x430.jpg_.webp";
            //str = @"_430x430_.webp";
            break;
        }
        case ETImageQuality_300:
        {
            str = @"_300x300.jpg_.webp";
            break;
        }
        case ETImageQuality_120:
        {
            str = @"_120x120.jpg_.webp";
            break;
        }
        case ETImageQuality_180:
        {
            str = @"_180x180.jpg_.webp";
            break;
        }
            
        default:
            break;
    }
    
    return str;
}

/*
 * 图片合法的urlstring
 */
+ (NSString*)          getCDNImageUrlString:(NSString*)urlStr Quality:(ETImageQuality)quality
{
    NSString* url = @"";
    
    //只包含字母，数字，标点符号。ASCII能完全覆盖
    if([urlStr canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        NSString* cdnHeader = [self getCDNHeaderUrl];
        
        NSString* cdnFooter = [self getCDNFooterUrl:quality];
        
        url = [NSString stringWithFormat:@"%@%@%@",cdnHeader,urlStr,cdnFooter];
    }
    
    
    return url;
                                      
}
+ (float) getSystemVersion
{
    float ver = [[[UIDevice currentDevice]systemVersion]floatValue];
    NSLog(@"[ETSystemUtil]-->system ver: %f",ver);
    
    return ver;
}

+ (NSString *)number2String:(int64_t)n
{
	if ( n < KB )
	{
		return [NSString stringWithFormat:@"%lldB", n];
	}
	else if ( n < MB )
	{
		return [NSString stringWithFormat:@"%.1fK", (float)n / (float)KB];
	}
	else if ( n < GB )
	{
		return [NSString stringWithFormat:@"%.1fM", (float)n / (float)MB];
	}
	else
	{
		return [NSString stringWithFormat:@"%.1fG", (float)n / (float)GB];
	}
}

//去除string中的html标签
+ (NSString *)cleanHtmlLabelForString:(NSString*)srcString
{
    NSString* ret = srcString;
    
    //去除html的标签
    NSString* prefix = @"<";
    NSRange rangeP = [ret rangeOfString:prefix];
    
    if(rangeP.location != NSNotFound)
    {
        NSString* suffix = @"/>";
        
        NSRange rangeL = [ret rangeOfString:suffix];
        
        if(rangeL.location != NSNotFound)
        {
            if (rangeL.location > rangeP.location) {
                
                NSRange range = NSMakeRange(rangeP.location, rangeL.location-rangeP.location+1);
                ret = [ret stringByReplacingCharactersInRange:range withString:@""];
            }
        }
    }
    
    return ret;
}

@end
