//
//  ETLibraryPrecompile.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-12.
//  Copyright (c) 2013年 etao. All rights reserved.
//

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - required framework

#include <QuartzCore/QuartzCore.h>
#include <objc/runtime.h>
#include <CoreText/CoreText.h>
#include <SystemConfiguration/SystemConfiguration.h>


/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - constant
/**
 *error domain
 */
#define kETGlobleErrorDomain @"kETGlobalErrorDomain"

static int const otherError          = -10000;
static int const modelRequestInvalid = -9999;
static int const modelParseInvalid   = -9998;



/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - headers
/*
 * ETModel
 */
#import "ETModel.h"
/*
 * foundation
 */
#import "ETFoundationHeader.h"
/*
 * debugger
 */
#import "ETDebuggerHeader.h"
/*
 * core
 */
#import "ETCoreKitHeader.h"
/*
 * controller
 */
#import "ETControllersHeader.h"
/*
 * util class
 */
#import "ETUtilHeader.h"
/*
 * UIkit
 */
#import "ETUIKitHeader.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tool method

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 定义ETLog
 */
#ifdef DEBUG
#   define ETLog(fmt, ...) NSLog((@"%s[Line %d]--> " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define ETLog(...)
#endif
