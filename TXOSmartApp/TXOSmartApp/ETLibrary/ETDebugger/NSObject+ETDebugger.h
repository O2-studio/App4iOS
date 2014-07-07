//
//  NSObject+ETDebugger.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-27.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ETDebugger)

/**
 for debugger use
 */
@property(nonatomic,strong) NSMutableArray* samplePoints;
/**
 for debugger use
 */
- (void)heartBeat;

@end
