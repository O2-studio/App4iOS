//
//  ETTableViewImageCell.h
//  etaoshopping
//
//  Created by moxin.xt on 12-9-24.
//
//

#import "ETTableViewCell.h"

@class ETImageView;
@interface ETTableViewImageCell : ETTableViewCell

@property(nonatomic,strong) ETImageView* etImageView;

- (void)startDownloadingImage;



@end
