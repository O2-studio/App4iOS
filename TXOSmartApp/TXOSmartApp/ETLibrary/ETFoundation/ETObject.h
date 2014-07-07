//
//  ETObject.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-30.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 moxin: build for fun
 */


//suppress warnings

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"
@interface ETObject
#pragma clang diagnostic pop

- (Class)superclass;
- (Class)class;
- (id)self;

+ (id)alloc;

@end