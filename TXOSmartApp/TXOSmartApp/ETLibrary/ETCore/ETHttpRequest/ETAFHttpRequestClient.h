//
//  ETAFHttpRequestClient.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-7-24.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"



@interface ETAFHttpRequestClient : AFHTTPClient

ET_SINGLETON(ETAFHttpRequestClient);

@property(nonatomic,strong) NSString* baseUrlString;


@end
