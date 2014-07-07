 //
//  ETTableViewController.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-21.
//
//

#import "ETTableViewController.h"
#import "ETTableViewListDataModel.h"
#import "ETTableViewItem.h"
#import "ETTableViewCusomizedItem.h"
#import "ETTableViewCell.h"
#import "ETTableViewDataSource.h"
#import "ETTableViewDelegate.h"


@interface ETTableViewController ()
{

    NSInteger _loadMoreSection;

}


/**
 *  不同状态的footerview
 */
@property(nonatomic,strong) UIView* footerViewNoResult;
@property(nonatomic,strong) UIView* footerViewLoading;
@property(nonatomic,strong) UIView* footerViewComplete;
@property(nonatomic,strong) UIView* footerViewEmpty;
@property(nonatomic,strong) UIView* footerViewError;

@end

@implementation ETTableViewController


@synthesize tableView       = _tableView;
@synthesize dataSource      = _dataSource;
@synthesize delegate        = _delegate;

@synthesize footerViewComplete = _footerViewComplete;
@synthesize footerViewEmpty    = _footerViewEmpty;
@synthesize footerViewError    = _footerViewError;
@synthesize footerViewLoading  = _footerViewLoading;
@synthesize footerViewNoResult = _footerViewNoResult;


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters


- (void)setDataSource:(ETTableViewDataSource*)dataSource
{

    if (dataSource != _dataSource)
    {
        _dataSource = dataSource;
        self.tableView.dataSource = dataSource;
        _dataSource.controller = self;

    }
}

- (void)setDelegate:(ETTableViewDelegate*)delegate
{
    if(delegate != _delegate)
    {
        _delegate = delegate;
        self.tableView.delegate = delegate;
        _delegate.controller = self;
    }
}

- (void)setKeyModel:(ETTableViewListDataModel *)keyModel
{
    _keyModel = keyModel;
    _loadMoreSection = keyModel.sectionNumber;
    
    //[super registerModel:keyModel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters


- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.opaque  = YES;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        
        [self.contentView addSubview:_tableView];
        
    }
    return _tableView;
}


- (ETTableViewDataSource* )dataSource
{
    if(!_dataSource)
    {
        _dataSource = [[ETTableViewDataSource alloc]init];

    }
    return _dataSource;
}

- (ETTableViewDelegate* )delegate
{
    if(!_delegate)
    {
        _delegate = [[ETTableViewDelegate alloc]init];

    }
    
    return _delegate;

}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);

    _tableView            = nil;
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    _delegate             = nil;
    _dataSource           = nil;
    
    [_modelDictInternal removeAllObjects];
    _modelDictInternal    = nil;
    
    _footerViewNoResult    = nil;
    _footerViewError       = nil;
    _footerViewEmpty       = nil;
    _footerViewComplete    = nil;
    _footerViewLoading     = nil;
 
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
       
        _loadmoreAutomatically = YES;
        _bNeedPullRefresh      = NO;
        _bNeedLoadMore         = NO;
        _modelDictInternal     = [NSMutableDictionary new];

    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _loadmoreAutomatically = YES;
        _bNeedPullRefresh      = NO;
        _bNeedLoadMore         = NO;
        _modelDictInternal     = [NSMutableDictionary new];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.footerViewNoResult = [ETBaseViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"没有结果"];
    self.footerViewLoading = [ETBaseViewFactory getLoadingFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"努力加载中..."];
    self.footerViewError   = [ETBaseViewFactory getErrorFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"加载失败"];
    self.footerViewEmpty   = [ETBaseViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 1) Text:@""];
    self.footerViewComplete = [ETBaseViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 1) Text:@""];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _tableView.tableFooterView = nil;
    _tableView.tableHeaderView = nil;
    _tableView  = nil;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETUIViewCOntroller


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETModelViewCOntroller

- (void)load
{
    NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
    [super load];
}

- (void)reload
{
     NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
    
    ////////////////////////////////////////////////////////////
    //@Dicsussion:重新load数据时，datasource的数据是否要清空
    /////////////////////////////////////////////////////////////
    [self.dataSource removeAllItems];
    [self showModel:nil];

    [super reload];
}

- (void)loadMore
{
    if (self.bNeedLoadMore) {
        
        NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
  
        if (self.loadmoreAutomatically) {
            [self.keyModel loadMore];
        }
        else
            [self showLoadMoreFooterView];
    }
}

- (void)didLoadModel:(ETTableViewListDataModel*)model{
    
    [self.dataSource tableViewControllerDidLoadModel:model ForSection:model.sectionNumber];

}

- (BOOL)canShowModel:(ETTableViewListDataModel*)model
{
    int numberOfRows = 0;
    int numberOfSections = 0;
    
    numberOfSections = [self.dataSource numberOfSectionsInTableView:self.tableView];
    
    if (!numberOfSections) {
        return NO;
    }
    
    numberOfRows = [self.dataSource tableView:self.tableView numberOfRowsInSection:model.sectionNumber];
    
    if (!numberOfRows) {
        return NO;
    }
    return YES;
}



- (void)showEmpty:(ETTableViewListDataModel *)model {
    
    ETLog(@"showEmpty:%@",model);
    
    [self endRefreshing];
    
    [self showNoResult:model];
}



- (void)showLoading:(ETTableViewListDataModel*)model{
   
    ETLog(@"showLoading:%@",model);

    
    if (model == _keyModel) {
        self.tableView.tableFooterView = self.footerViewLoading;
    }
    else
    {
        int section = model.sectionNumber;
        //创建一个loading item
        ETTableViewItem* item = [ETTableViewItem new];
        item.itemType = kItem_Loading;
        item.itemHeight = 44;
        [self.dataSource setItems:@[item] ForSection:section];
        [self showModel:model];
    }
}

- (void)showError:(NSError *)error withModel:(ETTableViewListDataModel*)model
{
    ETLog(@"showError:%@",model);
    
    [self endRefreshing];
    
    if (model == _keyModel) {
        self.tableView.tableFooterView = self.footerViewError;
    }
    else
    {
        //todo
        int section = model.sectionNumber;
        //创建一个loading item
        ETTableViewCusomizedItem* item = [ETTableViewCusomizedItem new];
        item.text = @"加载失败";
        item.itemType = kItem_Error;
        item.itemHeight = 44;
        [self.dataSource setItems:@[item] ForSection:section];
        [self showModel:model];
    }
    
   
    
}

- (void)showModel:(ETTableViewListDataModel *)model{
    
    ETLog(@"showModel:%@",model);
    
    //reload immediatly
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate   = self.delegate;
    [self.tableView reloadData];
    self.tableView.tableFooterView = self.footerViewComplete;
    
    //end refresh
    [self endRefreshing];


    //trigger datasource
//    int section = model.sectionNumber;
//    
//    if (model.modelAction == kModelActionLoad || model.modelAction==kModelActionReload) {
//        
//        [self.tableView beginUpdates];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationLeft];
//        [self.tableView endUpdates];
//        
//    }
//    else
//        [self.tableView reloadData];
//    
//    //end refreshing
//    if (self.bNeedPullRefresh) {
//        //stop refreshing
//        [self endRefreshing];
//    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETTableViewController



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

/**
 * 加载某个section的model
 */
- (void)loadModelForSection:(NSInteger)section
{
    //load model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        ETTableViewListDataModel* model = (ETTableViewListDataModel*)obj;
        
        if (section == model.sectionNumber) {
            [model load];
        }
    }];
}
/**
 * 重新加载某个section的model
 */
- (void)reloadModelForSection:(NSInteger)section
{
    //load model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        ETTableViewListDataModel* model = (ETTableViewListDataModel*)obj;
        
        if (section == model.sectionNumber) {
            
            [self.dataSource removeItemsForSection:section];
            [self showModel:model];
            [model reload];
        }
    }];
}

/**
 * 显示下拉刷新
 */
- (void)beginRefreshing
{
    [self.delegate beginRefreshing];
}
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing
{
    [self.delegate endRefreshing];
}
/**
 下拉刷新通知
 */
- (void)pullRefreshDidTrigger
{
    [self reload];
}
/**
 下拉刷新结束
 */
- (void)pullRefreshDidEnd
{
    [self.delegate endRefreshing];
}


@end



@implementation ETTableViewController(Subclassing)


- (void)showNoResult:(ETTableViewListDataModel *)model
{
    ETLog(@"showNoResult:%@",model);
    
    if (model == _keyModel) {
        self.tableView.tableFooterView = self.footerViewNoResult;
    }
    else
    {
        int section = model.sectionNumber;
        //创建一个customized item
        ETTableViewCusomizedItem* item = [ETTableViewCusomizedItem new];
        item.itemType = kItem_Customize;
        item.text = @"没有结果";
        item.itemHeight = 44;
        [self.dataSource setItems:@[item] ForSection:section];
        [self showModel:model];
    }

}
- (void)showComplete:(ETTableViewListDataModel *)model
{
    if (model == _keyModel) {
        self.tableView.tableFooterView = self.footerViewComplete;
    }
    else
    {
        //todo
    }
    
}
- (void)showLoadMoreFooterView
{
    if (self.tableView.tableFooterView == self.footerViewLoading) {
        return;
    }
    self.tableView.tableFooterView = [ETBaseViewFactory getClickableFooterView:CGRectMake(0, 0, self.tableView.frame.size.width, 44) Text:@"点一下加载更多" Target:self Action:@selector(clickToLoadMore:)];
}

- (void)clickToLoadMore:(id)sender
{
    [self loadMore];
    
}
@end

@implementation ETTableViewController(UIScrollView)


/*
 * tableView的相关操作
 */
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary*)bundle
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
