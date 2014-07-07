//
//  NSArray+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSArray *	(^NSMutableArrayAppendBlock)( id obj );

@interface NSArray (ETExtension)

@property (nonatomic, readonly) NSMutableArrayAppendBlock	APPEND;

- (NSArray *)head:(NSUInteger)count;
- (NSArray *)tail:(NSUInteger)count;

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray(ETExtension)

+ (NSMutableArray *)nonRetainingArray;	// copy from Three20

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
- (void)addObjectNoRetain:(NSObject *)obj;
- (void)removeObjectNoRelease:(NSObject *)obj;
- (void)removeAllObjectsNoRelease;

@end