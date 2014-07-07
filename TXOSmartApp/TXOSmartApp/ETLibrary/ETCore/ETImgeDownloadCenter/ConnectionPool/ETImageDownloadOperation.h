//
//  ETImageDownloadOperation.h
//  ETImageDownloaderDemo
//
//  Created by moxin on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFImageRequestOperation.h"

/**
 moxin : support webP
 */


@interface ETImageDownloadOperation : AFImageRequestOperation
//user info
@property(nonatomic,strong) NSString* key;


@end
