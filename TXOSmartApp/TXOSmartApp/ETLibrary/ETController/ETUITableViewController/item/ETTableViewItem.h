//
//  ETTableViewItem.h
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//

#import <Foundation/Foundation.h>
#import "ETItem.h"


typedef NS_ENUM(int, ITEM_TYPE)
{
    kETItem_Normal  = 0,
    kETItem_Loading = 1,
    kETItem_Error   = 2,
    kETItem_Customize = 3
};

@interface ETTableViewItem : ETItem<NSCoding>

// item的index
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,assign) CGFloat    itemHeight;
@property (nonatomic,assign) ITEM_TYPE  itemType;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) NSURL* imgUrl;
@property (nonatomic,strong) NSMutableArray* imageUrlArray;     //对象为NSURL


@end
