//
// TXOSlideDataSource.m
// iCoupon
//
// Created by Lua2objc.
// Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TXOSlideDataSource.h"
#import "TBCitySBTableViewCell.h"
#import "TXOSlideCell.h"


@interface TXOSlideDataSource ()


@end

@implementation TXOSlideDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    return [TXOSlideCell class];

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end