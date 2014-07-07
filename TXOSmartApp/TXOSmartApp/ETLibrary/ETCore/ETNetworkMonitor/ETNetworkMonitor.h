//
//  ETNetworkMonitor.h
//  ETShopping
//
//  Created by moxin.xt on 13-1-28.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kETNetworkStatus_NotReachable =0,
	kETNetworkStatus_ReachableViaWiFi,
    kETNetworkStatus_ReachableVia3G,
    kETNetworkStatus_ReachableVia2G 
	
}ETNetworkStatus;


@interface ETNetworkMonitor : NSObject

+ (void)initialize;

+ (void)startMonitor;

+ (void)stopMonitor;

+ (ETNetworkStatus)getNetworkStatus;

@end
