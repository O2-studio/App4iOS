//
// TXORootViewController.m
// iCoupon
//
// Created by Lua2objc.
// Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TXORootViewController.h"
#import "TBCitySBModel.h"
#import "TXRootRecentModel.h"
#import "TXORootDataSource.h"
#import "TXORootDelegate.h"
#import "TXORootItem.h"
#import "TXOSlideViewController.h"
#import "TXOAnimator.h"


@interface TXORootViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>


@property(nonatomic,strong) TXORootDataSource* ds;
@property(nonatomic,strong) TXORootDelegate* dl;
@property(nonatomic,strong) TXRootRecentModel* model;

@end

@implementation TXORootViewController
{
   
}

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

- (TXRootRecentModel* )model
{
    if (!_model) {
        _model = [TXRootRecentModel new];
        _model.key = @"__TXRootRecentModel__";
        _model.requestType = 1;
    }
    return _model;
}


- (TXORootDataSource* )ds{

  if (!_ds) {
      _ds = [TXORootDataSource new];
   }
   return _ds;
}

- (TXORootDelegate* )dl{

  if (!_dl) {
      _dl = [TXORootDelegate new];
   }
   return _dl;
}

//////////////////////////////////////////////////////////// 
#pragma mark - life cycle 

- (void)loadView{ 

    [super loadView]; 

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"slide" style:UIBarButtonItemStylePlain target:self action:@selector(onOpenSlide:) ];
}



- (void)viewDidLoad{ 

    [super viewDidLoad]; 

    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;

    //2,set some properties:下拉刷新，自动翻页
    self.bNeedLoadMore = NO;
    self.bNeedPullRefresh = YES;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.model;

    //5,REQUIRED:register model to parent view controller
    [self registerModel:self.model];

    //6,load model
    [self load];

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
    NSLog(@"nnn");

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 


////////////////////////////////////////////////////////////
#pragma mark - navigation controller callback

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
  
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    TXOAnimator* transition = [TXOAnimator new];
    transition.duration = 1.0f;
    transition.bPresenting = YES;

    return transition;

}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
   // self.navigationController.view.frame = CGRectMake(100, self.view.frame.origin.y, 320, self.view.frame.size.height);
    TXOAnimator* transition = [TXOAnimator new];
    transition.duration = 1.0f;
    transition.bPresenting = NO;
    
    return transition;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



- (void)onOpenSlide:(UIView* )sender
{
    sender.tag = !sender.tag;

    TXOSlideViewController* slideVC = [TXOSlideViewController new];
    slideVC.transitioningDelegate = self;
    slideVC.modalPresentationStyle = UIModalPresentationCustom;
    
    if (sender.tag) {
        [self presentViewController:slideVC animated:YES completion:nil];
    }
    else
    {
        TXOSlideViewController* vc = (TXOSlideViewController* )self.presentedViewController;
        vc.transitioningDelegate = self;
        [self dismissViewControllerAnimated:YES completion:nil];
       // [vc dismiss];
    }
        //

}

//////////////////////////////////////////////////////////// 
#pragma mark - private method 




@end