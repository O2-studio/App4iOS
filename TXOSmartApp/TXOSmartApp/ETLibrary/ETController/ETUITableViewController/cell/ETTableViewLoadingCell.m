//
//  ETTableViewLoadingCell.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-2.
//  Copyright (c) 2014年 etao. All rights reserved.
//

#import "ETTableViewLoadingCell.h"

@implementation ETTableViewLoadingCell
{
    UIActivityIndicatorView* _indicator;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGRect frame = self.contentView.frame;
        
         _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(frame)-20)/2, (CGRectGetHeight(frame)-20)/2, 20, 20)];
        _indicator.color = [UIColor redColor];
        [_indicator stopAnimating];
        
        [self.contentView addSubview:_indicator];
    
    }
    return self;
}
- (void)setItem:(ETTableViewItem *)item
{
    [_indicator startAnimating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    _indicator.hidden = NO;
    _indicator.frame = CGRectMake((CGRectGetWidth(frame)-20)/2, (CGRectGetHeight(frame)-20)/2, 20, 20);
 
}

@end
