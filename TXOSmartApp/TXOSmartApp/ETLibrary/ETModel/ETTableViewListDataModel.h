//
//  ETTableViewListDataModel.h
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//

#import "ETHttpDataModel.h"


/**
 子类需要重写的方法
 */
@protocol TBCityTableViewListModel <NSObject>

@required
- (NSMutableArray*)parseJsonResponse:(id)JSON;

@end


/**
 三种翻页模式
 */
typedef NS_ENUM(int, MODE)
{
    //有item回来就翻页
    //没有item回来则停止翻页
    kDefault = 0,
    
    //有item回来，且item数量小于pagesize，则停止翻页
    //没有item回来，则停止翻页
    //有item回来，且item数量 = pagesize，则翻页
    kReturnCount = 1,
    
    //翻页依据自定义的totalCount，不依赖pagesize
    kCustomize = 2
    
};

@interface ETTableViewListDataModel : ETHttpDataModel<TBCityTableViewListModel>

/*
  当前页数
 */
@property(nonatomic,assign,readonly) NSInteger currentPageNumber;
/**
  当前页的起始index
 */
@property(nonatomic,assign,readonly) NSInteger nextPageStartIndex;
/**
  每页请求条数
 */
@property(nonatomic,assign) NSInteger pageSize;
/*
  列表总条数
 */
@property(nonatomic,assign) NSInteger  totalCount;
/*
  列表数据
 */
@property(nonatomic,strong,readonly) NSMutableArray* dataArray;
/**
  翻页模式
 */
@property(nonatomic,assign) MODE loadmoreStrategy;
/**
  对应的section
 */
@property(nonatomic,assign) NSInteger sectionNumber;




@end





