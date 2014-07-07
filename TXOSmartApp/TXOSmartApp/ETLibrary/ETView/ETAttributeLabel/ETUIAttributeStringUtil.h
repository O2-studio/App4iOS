//
//  ETUIAttributeStringUtil.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-29.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 *  moxin:
 *  this class is the fake "NSTextCheckingResult"
 */
@interface MXTextCheckingResult : NSObject<NSCoding>

@property(nonatomic) NSRange range;
@property(nonatomic) NSTextCheckingType resultType;
@property(nonatomic,strong) NSString* result;

@end

/*
 *  moxin:
 *  this class is holds the info of uiimage
 */

@interface ETUIAttributeImageParser : NSObject<NSCoding>

@property (nonatomic,assign) CGSize             size;
@property (nonatomic,assign)  NSRange           range;
@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, strong) UIImage*          image;
@property (nonatomic, assign) UIEdgeInsets      margins;
@property (nonatomic, assign, readonly) CGSize  boxSize; // imageSize + margins
@property (nonatomic,assign) NSTextAlignment    alignment;
//for ctrun use
@property (nonatomic, assign) CGFloat fontAscent;
@property (nonatomic, assign) CGFloat fontDescent;
@end


@interface ETUIAttributeStringUtil : NSObject



@end
