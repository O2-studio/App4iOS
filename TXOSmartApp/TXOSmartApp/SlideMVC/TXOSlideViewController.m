//
// TXOSlideViewController.m
// iCoupon
//
// Created by Lua2objc.
// Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TXOSlideViewController.h"
#import "TBCitySBModel.h"
#import "TXOSlideModel.h"
#import "TXOSlideDataSource.h"
#import "TXOSlideDelegate.h"
#import "TXOAnimator.h"


@interface TXOSlideViewController ()<UIViewControllerTransitioningDelegate>

@property(nonatomic,strong) TXOSlideModel* model;
@property(nonatomic,strong) TXOSlideDataSource* ds;
@property(nonatomic,strong) TXOSlideDelegate* dl;

@end

@implementation TXOSlideViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

- (TXOSlideModel* )model
{
    if (!_model) {
        _model = [TXOSlideModel new];
        _model.key = @"__TXOSlideModel__";
        _model.requestType = 1;
    }
    return _model;
}

- (TXOSlideDataSource* )ds{

  if (!_ds) {
      _ds = [TXOSlideDataSource new];
   }
   return _ds;
}

- (TXOSlideDelegate* )dl{

  if (!_dl) {
      _dl = [TXOSlideDelegate new];
   }
   return _dl;
}

//////////////////////////////////////////////////////////// 
#pragma mark - life cycle 

- (void)loadView{ 

    [super loadView]; 



}

- (void)viewDidLoad{ 

    [super viewDidLoad]; 

    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = 1;

    //2,set some properties:下拉刷新，自动翻页
    self.bNeedLoadMore = NO;
    self.bNeedPullRefresh = NO;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4, set data
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"tags"];
    NSArray* list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self.ds setItems:list ForSection:0];
    [self.tableView reloadData];

    //nil footerview
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning{ 

    [super didReceiveMemoryWarning]; 



}

- (void)dealloc{ 

}

//////////////////////////////////////////////////////////// 
#pragma mark - TBCitySBViewController 



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  //todo:... 
    NSLog(@"aaa");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TXOAnimator* transition = [TXOAnimator new];
    transition.duration = 1.0f;
    transition.bPresenting = NO;
    return transition;
    
}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



//////////////////////////////////////////////////////////// 
#pragma mark - private method 




@end