//
//  NSNumber+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __NUM_INT( __x )			[NSNumber numberWithInt:(NSInteger)__x]
#define __NUM_UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]
#define	__NUM_FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]
#define	__NUM_DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]
#define __NUM_BOOL( __x )          [NSNumber numberWithBool:(bool)__x]

@interface NSNumber (ETExtension)

@end
