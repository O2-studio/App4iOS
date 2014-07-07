//
//  TXRootRecentModel.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-6.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXRootRecentModel.h"
#import "TXORootItem.h"

@implementation TXRootRecentModel
{

}

- (NSString* )methodName
{
    return @"http://fierce-meadow-3934.herokuapp.com/doc/recent?begin=2&end=5&format=json";
}

- (NSArray* )parseResponse:(id)JSON error:(NSError *__autoreleasing *)error
{
    NSMutableArray* list = [NSMutableArray new];
    
    NSArray* docs = JSON[@"docs"];
    for (int i=0; i<docs.count; i++) {
        
        TXORootItem* item = [TXORootItem new];
      

        [item autoKVCBinding:docs[i]];
        
        CGSize sz = [item.content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        item.itemHeight = sz.height + 20;
        [list addObject:item];
    }
    return list;
}

@end
