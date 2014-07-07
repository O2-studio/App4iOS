//
//  ETUIPagingChildView.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETUIPagingChildView.h"

@implementation ETUIPagingChildView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  这个方法在childview被add到scrollview之前执行
 */
- (void)childViewWillAppear
{
      NSLog(@"[PagingChildView:%@]-->will appear-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}
/**
 *  这个方法在childView被add到scrollview之后执行
 */
- (void)childViewDidAppear
{
      NSLog(@"[PagingChildView:%@]-->did appear-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}
/**
 *
 */
- (void)childViewWillDisappear
{
      NSLog(@"[PagingChildView:%@]-->will disappear-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}
/**
 *
 */
- (void)childViewDidDisappear
{
    NSLog(@"[PagingChildView:%@]-->did disappear-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[PagingChildView:%@]-->{%@,%d}",[self class],self.reuseIdentifier,self.pageIndex];
}

- (void)childViewWillBeRecycled
{
     NSLog(@"[PagingChildView:%@]-->will be recycled-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}

- (void)childViewDidBeRecycled
{
    NSLog(@"[PagingChildView:%@]-->did be recycled-->{%@,%d}",self.class,self.reuseIdentifier,self.pageIndex);
}
@end
