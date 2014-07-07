//
//  NSObject+ETExtension.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "NSObject+ETExtension.h"
#import <objc/runtime.h>

@implementation NSObject (ETExtension)

@dynamic referenceCount,tagString;

- (void) setReferenceCount:(CFIndex)referenceCount
{
    CFIndex rc = CFGetRetainCount((__bridge CFTypeRef)self);
    objc_setAssociatedObject(self, "referenceCount", __NUM_INT(rc), OBJC_ASSOCIATION_ASSIGN);
}

- (CFIndex)referenceCount
{
    return [(NSNumber*)objc_getAssociatedObject(self, "referenceCount") intValue];

}

- (void)setTagString:(NSString *)tagString
{
    objc_setAssociatedObject(self, "tagString", tagString, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)tagString
{
    return objc_getAssociatedObject(self, "tagString");
}
@end
