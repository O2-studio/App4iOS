//
//  ETHTTPNetworkCoreHeader.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#ifndef ETLibDemo_ETHTTPNetworkCoreHeader_h
#define ETLibDemo_ETHTTPNetworkCoreHeader_h

/**
 core network supports:
 
 1, concurrent HTTP request operation
 
 2, full HTTP protocol support
 
 3, built-in response cache
 
 4, automatically calculate the volume of network traffic 
 
 5，support connection frozen
 
 6, support searilzation: when app enter background it will automatically save the current status and send when app become alive
 
 7, support 3rd party injection
 
 */


//#import "ETHTTPGlobalConstants.h"

#import "ETHTTPRunloopOperation.h"
#import "ETHTTPURLConnectionOperation.h"
#import "ETHTTPNetworkAgent.h"
#endif
