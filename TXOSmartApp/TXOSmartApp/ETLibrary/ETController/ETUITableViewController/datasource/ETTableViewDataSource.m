//
//  ETTableViewDataSource.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//

#import "ETTableViewItem.h"
#import "ETTableViewCell.h"
#import "ETTableViewErrorCell.h"
#import "ETTableViewLoadingCell.h"
#import "ETTableViewLabelCell.h"
#import "ETTableViewListDataModel.h"
#import "ETTableViewController.h"
#import "ETTableViewDelegate.h"
#import "ETTableViewDataSource.h"


@interface ETTableViewDataSource()
{
    //CFMutableDictionaryRef _modelMap;
    NSMutableDictionary* _itemsForSectionInternal;
    NSMutableDictionary* _totalCountForSectionInternal;
  
}

@end

@implementation ETTableViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)itemsForSection
{
    return [_itemsForSectionInternal copy];
}

- (NSDictionary*)totalCountForSection
{
    return [_totalCountForSectionInternal copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    
    if (self) {
        _itemsForSectionInternal      = [NSMutableDictionary new];
        _totalCountForSectionInternal = [NSMutableDictionary new];
    }
    return self;
}
- (void)dealloc
{
    [_itemsForSectionInternal removeAllObjects];
    _itemsForSectionInternal = nil;
    
    [_totalCountForSectionInternal removeAllObjects];
    _totalCountForSectionInternal = nil;
    NSLog(@"[%@]--->dealloc",self.class);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)setItems:(NSArray*)items ForSection:(NSInteger)n
{
    if(n>=0)
       [_itemsForSectionInternal setObject:items forKey:@(n)];
}
- (void)removeItemsForSection:(NSInteger)n
{
    if (n>=0) {
        [_itemsForSectionInternal removeObjectForKey:@(n)];
    }
}
- (void)removeAllItems
{
    [_itemsForSectionInternal removeAllObjects];

}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView's dataSource

//子类重载
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* items = _itemsForSectionInternal[@(section)];
    return items.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.controller tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //拿到当前的item
    ETTableViewItem *item = [self itemForCellAtIndexPath:indexPath];
    //拿到当前cell的类型
    Class cellClass = [self cellClassForItem:item AtIndex:indexPath];
    //拿到name
    NSString* identifier = NSStringFromClass(cellClass);
    //创建cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //绑定cell和item
    if ([cell isKindOfClass:[ETTableViewCell class]])
    {
        ETTableViewCell* customCell = (ETTableViewCell*)cell;
        customCell.indexPath = indexPath;
        customCell.delegate  = (id<ETTableViewCellDelegate>)tableView.delegate;
        
        if (item)
        {
            //为cell,item绑定index
            item.indexPath = indexPath;
            [(ETTableViewCell *)cell setItem:item];
        }
        else
        {
            //moxin:
            /**
             *  @dicussion:
             *
             *  These codes are never supposed to be executed.
             *  If it does, it probably means something goes wrong.
             *  For some unpredictable error we display an empty cell with 44 pixel height
             */
            
            ETTableViewItem* item = [ETTableViewItem new];
            item.itemType = kItem_Normal;
            item.itemHeight = 44;
            item.indexPath = indexPath;
            [(ETTableViewCell *)cell setItem:item];
        }
    }
    
    
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (UITableViewCell*)tableView:(UITableView *)tableView initCellAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// item for index
- (ETTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* items = _itemsForSectionInternal[@(indexPath.section)];
    
    ETTableViewItem* item = nil;
    
    if (indexPath.row < items.count) {
        
        item = items[indexPath.row];
    }
    else
    {
        item = [ETTableViewItem new];
    }
    return item;
    
}
// cell for index
- (Class)cellClassForItem:(ETTableViewItem*)item AtIndex:(NSIndexPath *)indexPath
{
    if (item.itemType == kItem_Normal) {
        return [ETTableViewCell class];
    }
    else if (item.itemType == kItem_Loading) {
        return [ETTableViewLoadingCell class];
    }
    else if (item.itemType == kItem_Error)
    {
        return [ETTableViewErrorCell class];
    }
    else if(item.itemType == kItem_Customize)
    {
        return [ETTableViewLabelCell class];
    }
    else
        return [ETTableViewCell class];
}
// bind model
- (void)tableViewControllerDidLoadModel:(ETTableViewListDataModel*)model ForSection:(NSInteger)section
{
    
    // set totoal count
    [_totalCountForSectionInternal setObject:@(model.totalCount) forKey:@(section)];
    
    // set data
    //NSMutableArray* items = [model.dataArray mutableCopy];
    NSArray* items = [model.dataArray copy];
    [self setItems:items ForSection:section];
 
}






@end
