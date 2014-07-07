//
//  ETImageDownloadOperation.m
//  ETImageDownloaderDemo
//
//  Created by moxin on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ETImageDownloadOperation.h"
//#import "WebPImage.h"
#include <pthread.h>  

@implementation ETImageDownloadOperation

/**
 moxin:
 the operation needs to be retained on the heap!
 especially there are lots of connentions happened at the same time!
 */

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    
    self.completionBlock = ^ {
        
        if ([self isCancelled]) {
            return;
        }
        
        dispatch_async(image_request_operation_processing_queue(), ^(void) {
            if (self.error)
            {
                if (failure) {
                    dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else
            {
                if (success)
                {
  
                    NSData* imageData = self.responseData;
                    
                    NSString* url = self.request.URL.absoluteString;
                    UIImage* image = nil;
                    
//                    if ([url hasSuffix:@".webp"])
//                        image = [WebPImage loadWebPFromData:imageData];
//                    else
                        image = [UIImage imageWithData:imageData];
                    
                    
                    
                    dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                        
                        //add it by moxin
                        success(self, image);
                });
                }
            }
        });
    };
    
#pragma clang diagnostic pop
}

- (void)setImageProcessBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
{
    
}


@end




