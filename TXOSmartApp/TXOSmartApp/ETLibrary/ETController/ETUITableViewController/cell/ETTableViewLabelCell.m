//
//  ETTableViewLabelCell.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-16.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETTableViewLabelCell.h"
#import "ETTableViewCusomizedItem.h"
@implementation ETTableViewLabelCell
{
    UILabel* _label;

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)setItem:(ETTableViewCusomizedItem *)item
{
    [super setItem:item];
    
    if (item) {
        _label.text = item.text;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
