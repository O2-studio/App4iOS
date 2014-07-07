//
//  ETTableViewCell.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//


#define ETDEFAULT_CELL_HEIGHT 115

#import "ETTableViewCell.h"
#import "ETTableViewItem.h"


@implementation ETTableViewCellView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.opaque = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
	}
	return self;
}


- (void)setNeedsRedraw
{
    if (CGSizeEqualToSize(self.frame.size, CGSizeZero))
    {
        return;
    }

//    [[ETAsyncDrawingCache sharedInstance] drawViewAsyncWithCacheKey:self.key size:self.frame.size backgroundColor:self.backgroundColor drawBlock:^(CGRect frame) {
//           [(ETTableViewCell*)self.superview.superview drawContentView:frame];
//    } completionBlock:^(UIImage *drawnImage, NSString *cacheKey) {
//        
//        if (drawnImage && [self.key isEqualToString:cacheKey]) {
//            self.layer.contents = (id)drawnImage.CGImage;
//        }
//        else
//            self.layer.contents = nil;
//    }];
}

@end

@interface ETTableViewCell()
{

}

@end

@implementation ETTableViewCell

@synthesize indexPath = _indexPath;
@synthesize item = _item;
@synthesize delegate = _delegate;
@synthesize useDrawing = _useDrawing;




- (void)setItem:(id)item
{
    _item = item;
    self.key = [NSString stringWithFormat:@"%@-%d",[self class],self.indexPath.row];
}


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _item = nil;
    _delegate = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellCanvas = [[ETTableViewCellView alloc] initWithFrame:self.contentView.bounds];
        [self.textLabel removeFromSuperview];
        [self.imageView removeFromSuperview];
        [self.detailTextLabel removeFromSuperview];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath
{
    ETTableViewItem* tableviewItem = (ETTableViewItem*)item;
    
    if (tableviewItem.itemHeight > 0) {
        return tableviewItem.itemHeight;
    }
    else
        return ETDEFAULT_CELL_HEIGHT;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.useDrawing) {
        
        _cellCanvas.frame = CGRectZero;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.useDrawing) {
        
        _cellCanvas.frame = self.bounds;
        
        if (CGSizeEqualToSize(self.frame.size, CGSizeZero))
        {
            return;
        }
        
//        [[ETAsyncDrawingCache sharedInstance] drawViewAsyncWithCacheKey:self.key size:self.frame.size backgroundColor:self.backgroundColor targetView:self.cellCanvas completionBlock:^(UIImage *drawnImage, NSString *cacheKey) {
//            
//            if (drawnImage && [self.key isEqualToString:cacheKey]) {
//                self.layer.contents = (id)drawnImage.CGImage;
//            }
//            else
//                self.layer.contents = nil;
//        }];
    }

}

- (void)drawContentView:(CGRect)rect
{
   
}

@end
