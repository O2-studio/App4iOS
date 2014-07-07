//
//  NSArray+ETExtension.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "NSArray+ETExtension.h"
#include <objc/runtime.h>


@implementation NSArray (ETExtension)

@dynamic APPEND;

- (NSMutableArrayAppendBlock)APPEND
{
	NSMutableArrayAppendBlock block = ^ NSArray * ( id obj )
	{
		NSString * className = [[self class] description];
        
		if ( [className isEqualToString:@"NSMutableArray"] )
		{
			[(NSMutableArray *)self addObject:obj];
			return self;
		}
		else
		{
			NSMutableArray * array = [NSMutableArray arrayWithArray:self];
			[array addObject:obj];
			return array;
		}
		
		return self;
	};
	
	return [block copy];
}

- (NSArray *)head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
	else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
		return tempFeeds;
	}
}

- (NSArray *)tail:(NSUInteger)count
{
    //	if ( [self count] < count )
    //	{
    //		return self;
    //	}
    //	else
    //	{
    //        NSMutableArray * tempFeeds = [NSMutableArray array];
    //
    //        for ( NSUInteger i = 0; i < count; i++ )
    //		{
    //            [tempFeeds insertObject:[self objectAtIndex:[self count] - i] atIndex:0];
    //        }
    //
    //		return tempFeeds;
    //	}
    
    // thansk @lancy, changed: NSArray tail: count
    
	NSRange range = NSMakeRange( self.count - count, count );
	return [self subarrayWithRange:range];
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
	if ( index >= self.count )
		return nil;
    
	return [self objectAtIndex:index];
}

@end


// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

@implementation NSMutableArray(BeeExtension)

+ (NSMutableArray *)nonRetainingArray	// copy from Three20
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
	return (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable( nil, 0, &callbacks ));
}

- (NSMutableArray *)pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];
	}
	
	return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];
	}
	
	return self;
}

- (NSMutableArray *)popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];
	}
	
	return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];
	}
	
	return self;
}

- (void)insertObjectNoRetain:(id)object atIndex:(NSUInteger)index
{
    __weak id weakObj = object;
	[self insertObject:weakObj atIndex:index];

}

- (void)addObjectNoRetain:(NSObject *)object
{
    __weak id weakObj = object;
	[self addObject:weakObj];
}

- (void)removeObjectNoRelease:(NSObject *)object
{
	__strong id strongObj = object;
	[self removeObject:strongObj];
}

- (void)removeAllObjectsNoRelease
{
	for ( NSObject * object in self )
	{
		__strong id strongObj = object;
        [self removeObject:strongObj];
	}
	
	//[self removeAllObjects];
}

@end