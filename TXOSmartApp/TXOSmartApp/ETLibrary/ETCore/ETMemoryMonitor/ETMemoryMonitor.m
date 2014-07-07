//
//  ETMemoryMonitor.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETMemoryMonitor.h"
#include <mach/mach.h>
#include <malloc/malloc.h>

static vm_size_t            sPageSize = 0;
static vm_statistics_data_t sVMStats;


@interface ETMemoryMonitor()
{
 
}

@end

@implementation ETMemoryMonitor


DEF_SINGLETON(ETMemoryMonitor)



//for internal use
+ (BOOL)updateHostStatistics {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &sPageSize);
    return (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&sVMStats, &host_size)
            == KERN_SUCCESS);
}
/*
 * The number of bytes in memory that used
 **/
/*
 * stackoverflow.com/questions/7989864/watching-memory-usage-in-ios
 */
+ (unsigned long long)bytesOfUsedMemory
{
//    struct task_basic_info info;
//    mach_msg_type_number_t size = sizeof(info);
//    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
//    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
//
    unsigned long long ret_mem_used;
    
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size( host_port, &pagesize );
    
    vm_statistics_data_t vm_stat;
    kern_return_t ret = host_statistics( host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size );
    if ( KERN_SUCCESS != ret )
    {
        ret_mem_used = 0;
    }
    else
    {
        ret_mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    }
    return ret_mem_used;
}

/**
 * The number of bytes in memory that are free.
 */
+ (unsigned long long)bytesOfFreeMemory
{
    return NSRealMemoryAvailable();
}
/**
 * The total number of bytes of memory.
 */
+ (unsigned long long)bytesOfTotalMemory
{
    [self updateHostStatistics];

    unsigned long long free_count   = (unsigned long long)sVMStats.free_count;
    unsigned long long active_count = (unsigned long long)sVMStats.active_count;
    unsigned long long inactive_count = (unsigned long long)sVMStats.inactive_count;
    unsigned long long wire_count =  (unsigned long long)sVMStats.wire_count;
    unsigned long long pageSize = (unsigned long long)sPageSize;
    
    unsigned long long mem_free = (free_count + active_count + inactive_count + wire_count) * pageSize;

    
    return mem_free;
}
/**
 private api
 */
+ (void)performLowMemoryWarning
{
    SEL memoryWarningSel =  NSSelectorFromString(@"_performMemoryWarning");
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
       
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
#pragma clang diagnostic pop
    } else {
        // UIApplication no loger responds to _performMemoryWarning
        exit(1);
    }
}

/**
 * The number of bytes free on disk.
 */
+ (unsigned long long)bytesOfFreeDiskSpace
{
    return 0;
}
/**
 * The total number of bytes of disk space.
 */
+ (unsigned long long)bytesOfTotalDiskSpace
{
    return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - for debugger use

- (void)heartBeat
{
    if (self.samplePoints == nil)
    {
        self.samplePoints = [NSMutableArray new];
    }
    
    [self.samplePoints addObject:[NSNumber numberWithUnsignedLongLong:[[self class] bytesOfUsedMemory]]];
    [self.samplePoints keepTail:50];
}

@end
