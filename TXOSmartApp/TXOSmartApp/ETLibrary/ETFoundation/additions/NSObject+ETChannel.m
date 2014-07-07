//
//  NSObject+ETChannel.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-19.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "NSObject+ETChannel.h"

@interface ETChannelListener : NSObject

@property (nonatomic, weak) id object;
@property (nonatomic, copy) ETChannelsBlock block;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) dispatch_queue_t queue;

@end

@implementation ETChannelListener

@synthesize object;
@synthesize block;
@synthesize priority;
@synthesize queue;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ object = %@", [super description], object];
}

@end

@implementation NSObject (ETChannel)

- (NSMutableDictionary *)channelsDictionary
{
	static dispatch_once_t pred;
	static NSMutableDictionary *dictionary;
	dispatch_once(&pred, ^{ dictionary = [NSMutableDictionary dictionaryWithCapacity:4]; });
	return dictionary;
}

- (void)pruneDeadListenersFromChannel:(NSString *)channelName
{
	NSMutableDictionary *channelsDictionary = [self channelsDictionary];
	NSMutableArray *listeners = [channelsDictionary objectForKey:channelName];
    
	NSMutableSet *listenersToRemove = nil;
    
	for (ETChannelListener *listener in listeners)
	{
		if (listener.object == nil)
		{
			if (listenersToRemove == nil)
				listenersToRemove = [NSMutableSet set];
            
			[listenersToRemove addObject:listener];
		}
	}
    
	if (listenersToRemove != nil)
	{
		for (ETChannelListener *listener in listenersToRemove)
			[listeners removeObject:listener];
        
		if ([listeners count] == 0)
			[channelsDictionary removeObjectForKey:channelName];
	}
}

- (void)post:(NSDictionary *)dictionary toChannel:(NSString *)channelName
{
	NSParameterAssert(channelName != nil);
    
	NSMutableDictionary *channelsDictionary = [self channelsDictionary];
	@synchronized (channelsDictionary)
	{
		NSMutableArray *listeners = [channelsDictionary objectForKey:channelName];
		if (listeners != nil)
		{
			for (ETChannelListener *listener in listeners)
			{
				if (listener.object != nil)
				{
					if (listener.queue == nil)
						listener.block(listener, dictionary);
					else
						dispatch_async(listener.queue, ^{ listener.block(listener, dictionary); });
				}
			}
            
			[self pruneDeadListenersFromChannel:channelName];
		}
	}
}

- (void)listenOnChannel:(NSString *)channelName block:(ETChannelsBlock)block
{
	[self listenOnChannel:channelName priority:0 queue:nil block:block];
}

- (void)listenOnChannel:(NSString *)channelName priority:(NSInteger)priority queue:(dispatch_queue_t)queue block:(ETChannelsBlock)block
{
	NSParameterAssert(channelName != nil);
	NSParameterAssert(block != nil);
    
	NSMutableDictionary *channelsDictionary = [self channelsDictionary];
	@synchronized (channelsDictionary)
	{
		NSMutableArray *listeners = [channelsDictionary objectForKey:channelName];
		if (listeners == nil)
		{
			listeners = [NSMutableArray arrayWithCapacity:2];
			[channelsDictionary setObject:listeners forKey:channelName];
		}
        
		ETChannelListener *listener = [[ETChannelListener alloc] init];
		listener.object = self;
		listener.block = block;
		listener.priority = priority;
		listener.queue = queue;
        
		[listeners addObject:listener];
		[self pruneDeadListenersFromChannel:channelName];
        
		[listeners sortUsingComparator:^(ETChannelListener *obj1, ETChannelListener *obj2)
         {
             if (obj1.priority < obj2.priority)
                 return NSOrderedDescending;
             else if (obj1.priority > obj2.priority)
                 return NSOrderedAscending;
             else
                 return NSOrderedSame;
         }];
	}
}

- (void)removeFromChannel:(NSString *)channelName
{
	NSParameterAssert(channelName != nil);
    
	NSMutableDictionary *channelsDictionary = [self channelsDictionary];
	@synchronized (channelsDictionary)
	{
		NSMutableArray *listeners = [channelsDictionary objectForKey:channelName];
		if (listeners != nil)
		{
			for (ETChannelListener *listener in listeners)
			{
				if (listener.object == self)
					listener.object = nil;
			}
            
			[self pruneDeadListenersFromChannel:channelName];
		}
	}
}

- (void)debugChannels
{
	NSMutableDictionary *channelsDictionary = [self channelsDictionary];
	@synchronized (channelsDictionary)
	{
		NSLog(@"Channels dictionary: %@", channelsDictionary);
	}
}

@end
