//
//  TXOSlideCell.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-7.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXOSlideCell.h"
#import "TXOSlideItem.h"

@implementation TXOSlideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 14)];
        self.label.font = [UIFont systemFontOfSize:14.0f];
        self.label.textColor = [UIColor grayColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

- (void)setItem:(TBCitySBTableViewItem *)item
{
    [super setItem:item];
    
    TXOSlideItem* slideItem = (TXOSlideItem* )item;
    self.label.text = slideItem.name;
    
}

@end
