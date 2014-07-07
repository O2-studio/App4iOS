//
//  ETModelViewController.m
//  etaoshopping
//
//  Created by moxin.xt on 12-10-13.
//
//

#import "ETModelViewController.h"


@interface ETModelViewController ()
{
    BOOL _isUpdatingView;
}

@end

@implementation ETModelViewController

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)modelDictionary
{
    return [_modelDictInternal copy];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life circle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self = [self init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _modelDictInternal = [NSMutableDictionary new];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    [_modelDictInternal removeAllObjects];
    _modelDictInternal    = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ETUIViewController


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - model interface

- (void)registerModel:(ETBaseModel *)model{
    
    model.modelDelegate = self;
    [_modelDictInternal setObject:model forKey:model.tagName];
}

- (void)unRegisterModel:(ETBaseModel *)model{
    [_modelDictInternal removeObjectForKey:model.tagName];
}

/*
 *  load model
 */
- (void)load
{
   [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
       ETBaseModel *model = (ETBaseModel*)obj;
       [model load];
   }];
}
/**
 * reload model
 */
- (void)reload
{
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        ETBaseModel *model = (ETBaseModel*)obj;
        [model reload];
    }];
}
/**
 * loadmore
 */
- (void)loadMore
{
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        ETBaseModel *model = (ETBaseModel*)obj;
        [model loadMore];
    }];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - model delegate

- (void)modelRequestDidStartToLoad:(ETBaseModel *)model
{
    [self showLoading:model];
    
}
- (void)modelRequestDidFinish:(ETBaseModel *)model
{
    
    [self didLoadModel:model];
    
    if ([self canShowModel:model]) {
        [self showModel:model];
    }
    else
        [self showEmpty:model];
}

- (void)model:(ETBaseModel *)model RequestDidFailWithError:(NSError *)error
{
    [self showError:error withModel:model];
}

- (void)  modelRequestDidCancel:(ETBaseModel *)model
{
    [self showEmpty:model];
}

@end

@implementation ETModelViewController(Subclassing)


- (void)didLoadModel:(ETBaseModel*)model{
}

- (BOOL)canShowModel:(ETBaseModel*)model
{
    return YES;
}

- (void)showModel:(ETBaseModel *)model{
}

- (void)showEmpty:(ETBaseModel *)model {
}

- (void)showLoading:(ETBaseModel*)model{
    //subclass
}

- (void)showError:(NSError *)error withModel:(ETBaseModel*)model
{
    
}


@end
