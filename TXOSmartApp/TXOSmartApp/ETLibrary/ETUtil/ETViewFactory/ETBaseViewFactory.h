//
//  ETBaseViewFactory.h
//  etaoshopping
//
//  Created by moxin on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ETBaseViewFactory : NSObject

/*
 *footview
 */
+ (id)getClickableFooterView:(CGRect)frame Text:(NSString*)text Target:(id)target Action:(SEL)action;
+ (id)getNormalFooterView:(CGRect)frame Text:(NSString*)text;
+ (id)getLoadingFooterView:(CGRect)frame Text:(NSString*)text;
+ (id)getErrorFooterView:(CGRect)frame Text:(NSString*)text;



@end
