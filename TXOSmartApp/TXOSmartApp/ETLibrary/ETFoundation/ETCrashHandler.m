//
//  ETCrashHandler.m
//  ETShopping
//
//  Created by moxin.xt on 13-4-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETCrashHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

const int maxCrashLogNum  = 20;

@implementation ETCrashHandler
{
    BOOL          _isInstalled;
    NSString*     _crashLogPath;
    NSMutableArray* _plist;
}

DEF_SINGLETON(ETCrashHandler);


//handle exception

void HandleException(NSException *exception)
{
	[[ETCrashHandler sharedInstance]saveException:exception];
    abort();
}

void SignalHandler(int signal)
{
    //[[ETCrashHandler sharedInstance] saveSignal:signal];
	//raise( signal );
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    //skip 4, max is 10
    for (i = 4;i < 10;i++)
    {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
        NSString* sandBoxPath  = [ETSandBox libCachePath];
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"ETCrashLog"];
              
		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath] )
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath
									  withIntermediateDirectories:YES
													   attributes:nil
															error:NULL];
		}
        
        //creat plist
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]])
        {
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
        }
        else
            _plist = [NSMutableArray new];
	}
	return self;
}

- (void)printCrashReport
{
    NSLog(@"///////////Crash_Report//////////////////");
    
    for (NSString* key in _plist) {
    
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSLog(@"%@",dict);
    }
    
    NSLog(@"/////////////////////////////////////////");
}

- (void)install
{
    if (_isInstalled) {
        return;
    }
    //注册回调函数
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

- (void)dealloc
{
    signal( SIGABRT,	SIG_DFL );
	signal( SIGBUS,		SIG_DFL );
	signal( SIGFPE,		SIG_DFL );
	signal( SIGILL,		SIG_DFL );
	signal( SIGPIPE,	SIG_DFL );
	signal( SIGSEGV,	SIG_DFL );
}

- (void)saveException:(NSException*)exception
{
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	if ( exception.name )
	{
		[detail setObject:exception.name forKey:@"name"];
	}
	if ( exception.reason )
	{
		[detail setObject:exception.reason forKey:@"reason"];
	}
	if ( exception.userInfo )
	{
		[detail setObject:exception.userInfo forKey:@"userInfo"];
	}
	if ( exception.callStackSymbols )
	{
		[detail setObject:exception.callStackSymbols forKey:@"callStack"];
	}
    
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"exception" forKey:@"type"];
	[dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];

}

- (void)saveSignal:(int) signal
{
    //get back trace stack
    NSArray* backTrace = [ETCrashHandler backtrace];
    
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	[detail setObject:backTrace forKey:@"callStack"];
    
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"signal" forKey:@"type"];
	[dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];
   
}

- (void)saveToFile:(NSMutableDictionary*)dict
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    //add date
    [dict setObject:dateString forKey:@"date"];
    
	//save path
    NSString* savePath = [_crashLogPath stringByAppendingPathComponent:dateString];
    
    //save to disk
    [[ETThread sharedInstance] enqueueInBackground:^{
        
        BOOL succeed = [ dict writeToFile:savePath atomically:YES];
        if ( NO == succeed )
        {
            ETLog(@"【save crash report failed!】");
        }
        else
            ETLog(@"【save crash report succeed!】");
        
        [_plist addObject:dateString];
        [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
        
        if (_plist.count > maxCrashLogNum)
        {
            [[NSFileManager defaultManager] removeItemAtPath:[_crashLogPath stringByAppendingPathComponent:_plist[0]] error:nil];
            [_plist removeObject:0];
            [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
        }
    }];

}



@end
