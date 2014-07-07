//
//  TXORootCell.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-6.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "TXORootCell.h"
#import "TXORootItem.h"

@interface TXORootCell()<UIWebViewDelegate>

@property(nonatomic,strong) UILabel* label;


@end
@implementation TXORootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.font = [UIFont systemFontOfSize:14.0f];
        self.label.textColor = [UIColor lightGrayColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

- (void)setItem:(TBCitySBTableViewItem *)item
{
    [super setItem:item];
    
    
    
    if ([item isKindOfClass:[TXORootItem class]]) {
        
        TXORootItem* rootItem =(TXORootItem* )item;
        self.label.text = [NSString stringWithFormat:@"%@",rootItem.content];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(10, 10, 100, 100);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    TXORootItem* rootItem =(TXORootItem* )self.item;
    rootItem.isHTMLLoaded = YES;
    
    TBCitySBTableViewDelegate* delegate = (TBCitySBTableViewDelegate* )self.delegate;
    
    SEL sel = @selector(webView:DidFinishLoadAtIndexPath:);
    IMP imp = [delegate.controller methodForSelector:sel];
    if (imp) {
        ((void(*)(id,SEL,...))imp)(delegate.controller,sel,webView,self.indexPath,nil);
    }
}

@end
