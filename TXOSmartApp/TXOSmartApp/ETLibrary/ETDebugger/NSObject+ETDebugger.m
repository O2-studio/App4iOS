//
//  NSObject+ETDebugger.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "NSObject+ETDebugger.h"
#import <objc/runtime.h>

@implementation NSObject (ETDebugger)


- (void)setSamplePoints:(NSMutableArray *)samplePoints
{
    objc_setAssociatedObject(self, "samplePoints", samplePoints, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)samplePoints
{
    return objc_getAssociatedObject(self, "samplePoints");
}

- (void)heartBeat
{

}
@end
