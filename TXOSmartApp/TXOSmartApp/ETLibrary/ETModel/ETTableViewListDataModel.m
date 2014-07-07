//
//  ETTableViewListDataModel.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//


#import "ETTableViewListDataModel.h"

@interface ETTableViewListDataModel()
{
 
}

@end

@implementation ETTableViewListDataModel

@synthesize dataArray               = _dataArray;
@synthesize totalCount              = _totalCount;



/////////////////////////////////////////////////////////////////////////////////
#pragma mark - getter

- (NSInteger)nextPageStartIndex
{
    return self.currentPageNumber*self.pageSize;
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",[self class]);
    
    _dataArray = nil;
    
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _currentPageNumber  = 1;
        _dataArray          = [NSMutableArray new];
            
    }
    return self;
}

- (NSString*)description
{
    NSString* key = self.tagName;
    int number = self.sectionNumber;
    
    return [NSString stringWithFormat:@"[%@]-->{key:%@,section:%@}",[self class],key,@(number)];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETBaseMOdel

- (void)load
{
    if (self.pageSize == 0) {
        return;
    }
    else
    {
        [super load];
    }
    
}
- (void)reload
{
    if (self.pageSize == 0) {
        return;
    }
    else
        [super reload];
}

- (void)loadMore
{
    if (self.pageSize == 0) {
        return;
    }
    else
        [super loadMore];
}

- (void)reset
{
    [_dataArray removeAllObjects];
    _currentPageNumber = 1;
    
    [super reset];
    

}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETHttpModel

- (ETModelParserStatus)responseFromModel:(id)response
{
    NSMutableArray* array = [self parseJsonResponse:response];
    
    if(!array)
        return ETModelParserFailed;
    
    else
    {
        [_dataArray addObjectsFromArray:[array mutableCopy]];
        
        //翻页逻辑
        
        if (self.loadmoreStrategy == kDefault)
        {
            if (array.count > 0)
            {
//                if (self.modelAction == kModelActionLoadMore || self.modelAction == kModelActionLoad) {
//                    self->_currentPageNumber ++;
//                }
//                if (self.modelAction == kModelActionReload) {
//                    self->_currentPageNumber  = 1;
//                }
                self->_currentPageNumber++;
                self.totalCount = _dataArray.count + 1;
            }
            else
                self.totalCount = _dataArray.count;
        }
        
        
        //需要比较return count和 pagesize
        if (self.loadmoreStrategy == kReturnCount)
        {
            if (array.count > 0)
            {
                if (array.count < self.pageSize) {
                    self.totalCount = _dataArray.count;
                }
                else
                {
//                    if (self.modelAction == kModelActionLoadMore || self.modelAction == kModelActionLoad) {
//                        self->_currentPageNumber ++;
//                    }
//                    
//                    if (self.modelAction == kModelActionReload) {
//                        self->_currentPageNumber  = 1;
//                    }
                    self->_currentPageNumber ++;
                    self.totalCount = _dataArray.count + 1;
                }
            }
            else
                self.totalCount = _dataArray.count;
        }
        
        //自己指定totalcount
        if (self.loadmoreStrategy == kCustomize)
        {
       
            if(self.pageSize*_currentPageNumber >= self.totalCount)
            {
                self.totalCount = _dataArray.count;
            }
            else
            {
//                if (self.modelAction == kModelActionLoadMore || self.modelAction == kModelActionLoad) {
//                    self->_currentPageNumber ++;
//                }
//                if (self.modelAction == kModelActionReload) {
//                    self->_currentPageNumber  = 1;
//                }
                self->_currentPageNumber ++ ;
            }
        }

        return ETModelParserFinished;
    }
}

- (NSMutableArray*)parseJsonResponse:(id)JSON
{
    return nil;
}

@end
