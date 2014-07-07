//
//  TXOSlideModel.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXOSlideModel.h"
#import "TXOSlideItem.h"

@implementation TXOSlideModel

- (NSString* )methodName
{
    return @"http://fierce-meadow-3934.herokuapp.com/tags?format=json";
}

- (NSArray* )parseResponse:(id)JSON error:(NSError *__autoreleasing *)error
{
    NSMutableArray* list = [NSMutableArray new];
    
    NSArray* tags = JSON[@"tags"];
    
    for (NSDictionary* dict in tags) {
        
        TXOSlideItem* item = [TXOSlideItem new];
        [item autoKVCBinding:dict];
        [item setValue:dict[@"id"] forKeyPath:@"identifier"];
        [list addObject:item];
    }
    
    return list;
}

@end
