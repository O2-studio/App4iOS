//
//  ETImageFocusController.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-6-3.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ETImageFocusVCOrientation) {
    OrientationPortrait = 0,
    OrientationLandscapeLeft = 1,
    OrientationPortraitUpsideDown = 2,
    OrientationLandscapeRight = 3
};

@interface ETImageFocusController : UIViewController

@property (nonatomic, strong) UIImage*     focusedImage;
@property (nonatomic, strong) UIView*      focusedView;
//@property (nonatomic, strong) UIImageView* focusedImageView;


- (id)initWithImages:(NSArray*)images defaultSelectedIndex:(NSInteger)index;
- (id)initWithImages:(NSArray *)images downloadImages:(NSArray*)urlArray defaultSelectedIndex:(NSInteger)index;


@end
