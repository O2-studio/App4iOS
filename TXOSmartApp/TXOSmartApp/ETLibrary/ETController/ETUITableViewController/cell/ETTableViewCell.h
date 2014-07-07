//
//  ETTableViewCell.h
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//

#import <UIKit/UIKit.h>

@class ETTableViewItem;
@interface ETTableViewCellView : UIView

@property(nonatomic,strong) NSString* key;
@property(nonatomic,assign) BOOL cacheImage;

@end

@protocol ETTableViewCellDelegate<NSObject>

@optional
- (void)onCellComponentClickedAtIndex:(NSIndexPath*)indexPath Bundle:(NSDictionary*)extra;

@end


@interface ETTableViewCell : UITableViewCell


//cell的key
@property(nonatomic,strong) NSString* key;
//cell的index
@property (nonatomic,strong) NSIndexPath* indexPath;
//cell的item
@property (nonatomic,strong) ETTableViewItem* item;
//cell的delegate
@property (nonatomic,weak) id<ETTableViewCellDelegate> delegate;
//content view
@property(nonatomic,strong)	ETTableViewCellView* cellCanvas;
//use drawing
@property(nonatomic,assign) BOOL  useDrawing;

+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath;

- (void)drawContentView:(CGRect)rect;


@end
