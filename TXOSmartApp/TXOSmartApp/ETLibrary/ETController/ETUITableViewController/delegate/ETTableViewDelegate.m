//
//  ETTableViewDelegate.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-23.
//
//



#import "ETTableViewController.h"
#import "ETTableViewDelegate.h"
#import "ETTableViewDataSource.h"
#import "ETProgressIndicator.h"
#import "ETTableViewItem.h"
#import "ETTableViewCell.h"



@interface ETTableViewDefaultPullRefreshView : UIView<ETTableViewPullRefreshControllerDelegate,ETProgressIndicatorDelegate>

@property(nonatomic,weak) ETTableViewController* controller;

@end

@interface ETTableViewDelegate()

@property(nonatomic,strong) ETTableViewDefaultPullRefreshView* pullRefreshViewInternal;
@end

@implementation ETTableViewDelegate
{
  
}

@synthesize controller      = _controller;
@synthesize pullRefreshView = _pullRefreshView;
///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setPullRefreshView:(id<ETTableViewPullRefreshControllerDelegate>)pullRefreshView
{
    _pullRefreshView = pullRefreshView;
    [self.controller.tableView addSubview:(UIView*)_pullRefreshView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (ETTableViewDefaultPullRefreshView*)pullRefreshViewInternal
{
    if (!_pullRefreshViewInternal) {
        
        CGRect bounds = self.controller.tableView.bounds;
        _pullRefreshViewInternal=  [[ETTableViewDefaultPullRefreshView alloc]initWithFrame:CGRectMake(0, -44, bounds.size.width, 44)];
        _pullRefreshViewInternal.backgroundColor = self.controller.tableView.backgroundColor;
        _pullRefreshViewInternal.controller = self.controller;
        [self.controller.tableView addSubview:_pullRefreshViewInternal];
    }
    return _pullRefreshViewInternal;
}

- (id<ETTableViewPullRefreshControllerDelegate>)pullRefreshView
{
    if (_pullRefreshView) {
        return _pullRefreshView;
    }
    else
        return self.pullRefreshViewInternal;
}

- (id)initWithController:(ETTableViewController *)controller
{
    self = [super init];
    
    if(self)
    {
        _controller    = controller;

    }
    
    return self;

}

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _controller = nil;
    _pullRefreshView = nil;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)beginRefreshing
{
    if (self.controller.bNeedPullRefresh) {
        [self.pullRefreshView startRefreshing];
    }
}
- (void)endRefreshing
{
    if (self.controller.bNeedPullRefresh) {
        [self.pullRefreshView stopRefreshing];
    }

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - uitableView delegate

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class cls;
    
    if ([tableView.dataSource isKindOfClass:[ETTableViewDataSource class]]) {
        
        ETTableViewDataSource* dataSource = (ETTableViewDataSource*)tableView.dataSource;
        
        ETTableViewItem* item = [dataSource itemForCellAtIndexPath:indexPath];
        
        if (item.itemHeight > 0) {
            return item.itemHeight;
        }
        else
        {
            cls = [dataSource cellClassForItem:item AtIndex:indexPath];
            
            if ([cls isSubclassOfClass:[ETTableViewCell class]]) {
                
                return [cls tableView:tableView variantRowHeightForItem:item AtIndex:indexPath];
            }
            else
                return 44;
        }
    }
    else
        return 44;
  
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


/**
 show key model's footerview
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == self.controller.keyModel.sectionNumber)
    {
        ETTableViewDataSource* dataSource = (ETTableViewDataSource*)tableView.dataSource;
        NSArray* items = dataSource.itemsForSection[@(indexPath.section)];
        if (indexPath.row  == items.count - 1 )
            [self.controller loadMore];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.controller tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETUIViewController* controller = (ETUIViewController*)self.controller;
    
    if (controller.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    else
		return UITableViewCellEditingStyleDelete;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - scrollview's delegate


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    //下拉刷新
    if (self.controller.bNeedPullRefresh) {
        [self.pullRefreshView scrollviewDidEndDragging:scrollView];
        
    }
    
    [self.controller scrollViewDidEndDragging:scrollView willDecelerate:decelerate];	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    [self.controller scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.controller.bNeedPullRefresh) {
        
        [self.pullRefreshView scrollviewDidScroll:scrollView];
    }
    
    [self.controller scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.controller scrollViewWillBeginDragging:scrollView];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview delegate

- (void)onCellComponentClickedAtIndex:(NSIndexPath *)indexPath Bundle:(NSDictionary *)extra
{
    if(extra == nil)
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath];
    
    else
    {
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath component:extra];
    }
}

#pragma mark - private



@end

#define kRefreshViewHeight          44

typedef NS_ENUM(NSInteger, PullRefreshState)
{
    kIsIdle    = 0,
    kIsPulling,
    kIsLoading
};


@implementation  ETTableViewDefaultPullRefreshView
{
    PullRefreshState _state;
    ETProgressIndicator* _indicator;
    UILabel* _textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _state = kIsIdle;
        
        _textLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(80, 18, 160, 16)];
        _textLabel.font            = [UIFont systemFontOfSize:16.0f];
        _textLabel.textAlignment   = NSTextAlignmentCenter;
        _textLabel.textColor       = [UIColor redColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text            = @"下拉刷新";
        //[self addSubview:_textLabel];
        
        _indicator             = [[ETProgressIndicator alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
        _indicator.offsetRange = NSMakeRange(15, 60);
        _indicator.circleColor = [UIColor redColor];
        _indicator.delegate    = self;
        [self addSubview:_indicator];

    }
    return self;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollviewDidScroll:(UIScrollView *)scrollview
{
    //fix section header problem
    if(_indicator.isRefreshing)
    {
        if( scrollview.contentOffset.y >= 0 )
            scrollview.contentInset = UIEdgeInsetsZero;
        else
            scrollview.contentInset = UIEdgeInsetsMake( MIN( -scrollview.contentOffset.y, kRefreshViewHeight ), 0, 0, 0 );
    }
    
    [_indicator scrollViewDidScroll:scrollview];
}

- (void)scrollviewDidEndDragging:(UIScrollView *)scrollview
{
    [_indicator scrollViewDidEndDraging:scrollview];
    
    if (_indicator.isRefreshing) {
        
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            UIEdgeInsets inset = scrollView.contentInset;
            inset.top = kRefreshViewHeight;
            
            [UIView animateWithDuration:0.3 animations:^{
                 scrollView.contentInset = inset;
                
                           } completion:^(BOOL finished) {
                               //通知controller
                               [self.controller performSelector:@selector(pullRefreshDidTrigger) withObject:nil afterDelay:1.0f];

                           }];
        }

    }
}

- (void)startRefreshing
{
    if (!_indicator.isRefreshing) {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = kRefreshViewHeight;
        scrollView.contentInset = inset;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.contentInset = inset;
            
        } completion:^(BOOL finished) {
            
            [_indicator beginRefreshing];
        }];
        
    }
}

- (void)stopRefreshing
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    UIEdgeInsets inset = scrollView.contentInset;
    inset.top = 0;
    
    if (_indicator.isRefreshing) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.contentInset = inset;
            
        } completion:^(BOOL finished) {
            
            [_indicator endRefreshing];
            
        }];
        
    }
    else
        scrollView.contentInset = inset;
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)refreshIndicatorDidStartRefresh:(id)refreshView
{
    
}

@end
