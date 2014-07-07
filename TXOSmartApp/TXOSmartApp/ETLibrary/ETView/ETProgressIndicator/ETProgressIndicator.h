//
//  ETProgressIndicator.h
//  ETShopping
//
//  Created by moxin.xt on 13-8-15.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ETProgressIndicatorDelegate <NSObject>

- (void)refreshIndicatorDidStartRefresh:(id)refreshView;

@end

@interface ETProgressIndicator : UIView


@property(nonatomic,weak) UIScrollView* scrollview;
@property(nonatomic,assign) BOOL isRefreshing;
@property(nonatomic,assign) NSRange offsetRange;
@property(nonatomic,strong) UIColor* circleColor;
@property(nonatomic,weak) id<ETProgressIndicatorDelegate> delegate;


- (void)beginRefreshing;
- (void)endRefreshing;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDraging:(UIScrollView *)scrollView;


@end

