//
//  NSObject+ETChannel.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-19.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <dispatch/dispatch.h>

typedef void (^ETChannelsBlock)(id sender, NSDictionary *dictionary);

/**
 moxin: a light-weight communication channel
 */

@interface NSObject (ETChannel)

- (void)post:(NSDictionary *)dictionary toChannel:(NSString *)channelName;

- (void)listenOnChannel:(NSString *)channelName block:(ETChannelsBlock)block;

- (void)listenOnChannel:(NSString *)channelName priority:(NSInteger)priority queue:(dispatch_queue_t)queue block:(ETChannelsBlock)block;

- (void)removeFromChannel:(NSString *)channelName;

@end
