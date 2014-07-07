//
//  NSString+ETExtension.h
//  ETShopping
//
//  Created by moxin.xt on 13-4-1.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (ETExtension)

- (NSString *)sha1;
- (NSString *) md5:(NSString *) input;

@end
