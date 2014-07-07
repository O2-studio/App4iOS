//
//  ETCrashHandler.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETCrashHandler : NSObject

ET_SINGLETON(ETCrashHandler);

- (void)install;

- (void)printCrashReport;

@end
