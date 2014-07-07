//
//  NSObject+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ETExtension)

/**
 引用计数
 */
@property(nonatomic,assign) CFIndex referenceCount;
/**
 tag string
 */
@property(nonatomic,strong) NSString* tagString;


@end
