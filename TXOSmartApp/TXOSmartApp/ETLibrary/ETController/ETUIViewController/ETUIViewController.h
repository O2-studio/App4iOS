//
//  ETUIViewController.h
//  ETSDK
//
//  Created by moxin on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ETUIViewController : UIViewController
{

}

/**
 ios7 flag
 */
@property(nonatomic,assign) BOOL isiOS7above;
/**
 * controller 的contentView
 */
@property(nonatomic,strong) UIView* contentView;


@end

