//
//  ETNetworkMonitor.m
//  ETShopping
//
//  Created by moxin.xt on 13-1-28.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETNetworkMonitor.h"
#import "AFHTTPClient.h"


/*
 *typedef enum {
 AFNetworkReachabilityStatusUnknown          = -1,
 AFNetworkReachabilityStatusNotReachable     = 0,
 AFNetworkReachabilityStatusReachableViaWWAN = 1,
 AFNetworkReachabilityStatusReachableViaWiFi = 2,
 } AFNetworkReachabilityStatus;
 */

static AFHTTPClient* afClient;


@implementation ETNetworkMonitor

/*
 * moxin:
 *
 * 创建一个AFClient来监控当前网络状况，注意的是，baseUrl要写完整，否则host找不到
 *
 */
+ (void)startMonitor
{
    if(afClient == nil)
        afClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    
    [afClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        ETNetworkStatus s;
        
        if(status == AFNetworkReachabilityStatusReachableViaWiFi)
            s = kETNetworkStatus_ReachableViaWiFi;
        
        if(status == AFNetworkReachabilityStatusNotReachable)
            s = kETNetworkStatus_NotReachable;
        
        if(status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            //can not be accurate wether it's 2g/3g
            s = kETNetworkStatus_ReachableVia3G;
            
            //check status bar
            NSNumber* number = [self dataNetworkTypeFromStatusBar];
            
            if (number.intValue == 1) {
                s = kETNetworkStatus_ReachableVia2G;
            }
     
            if(number.intValue == 2)
                s = kETNetworkStatus_ReachableVia3G;
        }
        
    }];
}

+ (void)stopMonitor
{
    //afClient
    afClient = nil;
}

+ (ETNetworkStatus)getNetworkStatus
{
    ETNetworkStatus s;
    
    AFNetworkReachabilityStatus status = afClient.networkReachabilityStatus;
    
    if(status == AFNetworkReachabilityStatusReachableViaWiFi)
        s = kETNetworkStatus_ReachableViaWiFi;
    
    if(status == AFNetworkReachabilityStatusNotReachable)
        s = kETNetworkStatus_NotReachable;
    
    if(status == AFNetworkReachabilityStatusReachableViaWWAN)
    {
        //can not be accurate wether it's 2g/3g
        s = kETNetworkStatus_ReachableVia3G;
        
        //check status bar
        NSNumber* number = [self dataNetworkTypeFromStatusBar];
        
        if (number.intValue == 1) {
            s = kETNetworkStatus_ReachableVia2G;
        }
        
        if(number.intValue == 2)
            s = kETNetworkStatus_ReachableVia3G;
    }

    
    return s;
}

/**
 @"No wifi or cellular",
 @"2G and earlier? (not confirmed)",
 @"3G? (not yet confirmed)",
 @"4G",
 @"LTE",
 @"Wifi",
 */

+ (NSNumber *) dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"]    subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }

    return [dataNetworkItemView valueForKey:@"dataNetworkType"];
}



@end
