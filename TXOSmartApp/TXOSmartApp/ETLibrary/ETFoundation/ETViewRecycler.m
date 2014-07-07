//
//  ETViewRecycler.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETViewRecycler.h"

@implementation ETViewRecycler
{
    NSMutableDictionary* _recycableViews;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _recycableViews = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onRecvMemoryWarning:(id)sender
{
    [self removeAllViews];
}

- (ETRecycableView *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier
{
    NSMutableArray* views = [_recycableViews objectForKey:reuseIdentifier];
    ETRecycableView* view = [views lastObject];
    if (nil != view) {
        [views removeLastObject];
        if ([view respondsToSelector:@selector(prepareForReuse)]) {
            [view prepareForReuse];
        }
    }
    return view;
}
- (void)recycleView:(ETRecycableView *)view
{
    NSString* reuseIdentifier = view.reuseIdentifier;

    if (nil == reuseIdentifier || reuseIdentifier.length == 0) {
        reuseIdentifier = NSStringFromClass([view class]);
    }
    if (nil == reuseIdentifier) {
        return;
    }
    
    NSMutableArray* views = [_recycableViews objectForKey:reuseIdentifier];
    if (nil == views) {
        views = [[NSMutableArray alloc] init];
        [_recycableViews setObject:views forKey:reuseIdentifier];
    }
    [views addObject:view];
}

- (void)removeAllViews
{
    [_recycableViews removeAllObjects];
}

@end




@implementation ETRecycableView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
    }

    return self;
}

- (void)prepareForReuse
{

}

@end