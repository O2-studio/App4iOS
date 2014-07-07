//
//  ETTableViewImageCell.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-24.
//
//


#import "ETTableViewImageCell.h"
#import "ETImageView.h"
#import "ETTableViewItem.h"

@interface ETTableViewCell()
{
    
}

@end

@implementation ETTableViewImageCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _etImageView                       = [[ETImageView alloc]initWithFrame:CGRectZero];
        _etImageView.enableFadeInAnimation = YES;
        _etImageView.enablePicProcess      = NO;
        _etImageView.enableProgress        = NO;
        [self.contentView addSubview:_etImageView];
        
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETTableviewCell

- (void)setItem:(ETTableViewItem *)item
{
    [super setItem:item];
    [self startDownloadingImage];
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETTableviewImageCell

-(void)startDownloadingImage
{
    if (self.item.imgUrl) {
        [_etImageView startImageDownloadAutomatically:self.item.imgUrl cachePolicy:ETImageDownloadCacheInFile];
    }
}







@end
