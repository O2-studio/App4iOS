//
//  ETItem.m
//  ETLibSDK
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETItem.h"

@implementation ETItem

+ (id)item {
    return [[[self class] alloc] initWithDictionary:nil];
}

+ (id)itemWithJSON:(NSDictionary *)json {
    if ([json isKindOfClass:[NSDictionary class]]) {
        return [[[self class] alloc] initWithDictionary:json];
    }else{
        return nil;
    }
}

+ (id)itemArrayWithJSON:(NSArray *)jsonArray {
    if ([jsonArray isKindOfClass:[NSArray class]]) {
        Class cls = [self class];
        NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
        
        for (NSDictionary *dict in jsonArray) {
            NSDictionary *tempDict = [cls itemWithJSON:dict];
            if (tempDict != nil) {
                [ret addObject:[cls itemWithJSON:dict]];
            }
        }
        
        return ret;
    }else{
        return nil;
    }
    
}

#pragma mark -
#pragma mark Initialize

- (id)init {
    return [self initWithDictionary:nil];
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        //为了保证不因为服务端的数据错误crash
        @try {
            [self setFromDictionary:dict];
        }
        @catch (NSException *exception) {
            self = nil;
        }
    }
    
    return self;
}


-(NSDictionary *)keyMapDictionary {
    return nil;
}

- (void)setFromDictionary:(NSDictionary *)dict {
    NSDictionary *keyMap = [self keyMapDictionary];
    for (NSString __strong *key in [dict keyEnumerator]) {
        
        id val = [dict objectForKey:key];
        
        if ([keyMap objectForKey:key]) {
            key = [keyMap objectForKey:key];
        }
        
        if ([val isKindOfClass:[NSArray class]]) {
            Class type = [self classForKey:key];
            
            if (type) {
                [self setValue:[type itemArrayWithJSON:val] forKey:key];
            } else {
                [self setValue:val forKey:key];
            }
            
        } else if (![val isKindOfClass:[NSDictionary class]] && ![val isKindOfClass:[NSNull class]]) {
            
            [self setValue:val forKey:key];
            
        } else {
            
            id origVal = [self valueForKey:key];
			
            if ([origVal isKindOfClass:[NSArray class]]) {
                
                NSArray *allKeys = [val allKeys];
                
                if ([allKeys count] > 0) {
                    NSArray *arr = [val objectForKey:[allKeys objectAtIndex:0]];
                    
                    Class type = [self classForKey:key];
                    
                    if (type && [arr isKindOfClass:[NSArray class]]) {
                        [self setValue:[type itemArrayWithJSON:arr] forKey:key];
                    }
                }
                
            } else {
                Class cls = [self classForKey:key];
                if (cls) {
                    [self setValue:[cls itemArrayWithJSON:val] forKey:key];
                } else {
                    [self setValue:val forKey:key];
                }
            }
            
        }
    }
}

#pragma mark -

- (Class)classForKey:(NSString *)key {
    return NULL;
}

- (NSArray *)keys {
    return nil;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:[[self keys] count]];
    NSArray *keys = [self keys];
    for (NSString *key in keys) {
        id val = [self valueForKey:key];
        if (val && ![val isKindOfClass:[NSNull class]]) {
            [ret setObject:val forKey:key];
        }
    }
    return ret;
}


@end
