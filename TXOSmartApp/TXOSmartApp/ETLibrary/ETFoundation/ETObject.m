//
//  ETObject.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-30.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETObject.h"
#import <objc/runtime.h>

@implementation ETObject
{
    Class isa;
    volatile int32_t retainCount;
}

- (Class)superclass
{
    return nil;
}
- (Class)class
{
    return nil;
}
- (id)self
{
    return nil;
}

+ (id)alloc
{
    ETObject *obj = (__bridge ETObject *)(calloc(1, class_getInstanceSize(self)));
    obj->isa = self;
    obj->retainCount = 1;
    return obj;
}


@end
