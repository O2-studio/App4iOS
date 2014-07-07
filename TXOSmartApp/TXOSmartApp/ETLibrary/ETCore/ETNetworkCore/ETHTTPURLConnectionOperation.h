//
//  ETHTTPURLConnectionOperation.h
//  ETLibDemo
//
//  Created by moxin.xt on 13-10-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ETHTTPURLConnectionOperation : ETHTTPRunloopOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate>



@property (readonly, nonatomic, strong) NSURLRequest *request;

@property (readonly, nonatomic, strong) NSURLResponse *response;

@property (readonly, nonatomic, strong) NSError *error;

@property (readonly, nonatomic, strong) NSData *responseData;

@property (readonly, nonatomic, copy) NSString *responseString;

@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;

@property (nonatomic, strong) NSInputStream *inputStream;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, assign) BOOL shouldUseCredentialStorage;


- (id)initWithRequest:(NSURLRequest *)urlRequest;

- (void)setHandleHTTPAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block;

- (void)setHandleRedirectResponseBlock:(NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))block;

- (void)setHandleCacheResponseBlock:(NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))block;

- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;

- (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

@end
