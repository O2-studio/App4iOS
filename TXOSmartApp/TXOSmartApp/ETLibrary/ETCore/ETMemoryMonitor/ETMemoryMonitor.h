//
//  ETMemoryMonitor.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETImagePool.h"


@interface ETMemoryMonitor : NSObject



ET_SINGLETON( ETMemoryMonitor );




#pragma mark- Memory monitor

/*
 * The number of bytes in memory that used
 **/
+ (unsigned long long)bytesOfUsedMemory;

/**
 * The number of bytes in memory that are free.
 */
+ (unsigned long long)bytesOfFreeMemory;

/**
 * The total number of bytes of memory.
 */
+ (unsigned long long)bytesOfTotalMemory;
/**
 * Simulate low memory warning
 * notice : _performMemoryWarning is private api
 */
+ (void)performLowMemoryWarning;
/**
 * The number of bytes free on disk.
 */
+ (unsigned long long)bytesOfFreeDiskSpace;
/**
 * The total number of bytes of disk space.
 */
+ (unsigned long long)bytesOfTotalDiskSpace;


@end
