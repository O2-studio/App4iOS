//
//  UIView+ETExtension.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-17.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "UIView+ETExtension.h"
#import <objc/runtime.h>

@implementation UIView (ETExtension)

- (void)setMarginTop:(CGFloat)top
{
    CGRect oldRect = self.frame;
    self.frame = CGRectMake(oldRect.origin.x, oldRect.origin.y+top, oldRect.size.width, oldRect.size.height);
    
}
- (void)setMarginBottom:(CGFloat)bottom
{
    CGRect oldRect = self.frame;
    self.frame = CGRectMake(oldRect.origin.x, oldRect.origin.y-bottom, oldRect.size.width, oldRect.size.height);
}
- (void)setMarginLeft:(CGFloat)left
{
    CGRect oldRect = self.frame;
    self.frame = CGRectMake(oldRect.origin.x+left, oldRect.origin.y, oldRect.size.width, oldRect.size.height);
}
- (void)setMarginRight:(CGFloat)right
{
    CGRect oldRect = self.frame;
    self.frame = CGRectMake(oldRect.origin.x-right, oldRect.origin.y, oldRect.size.width, oldRect.size.height);
}

@end
