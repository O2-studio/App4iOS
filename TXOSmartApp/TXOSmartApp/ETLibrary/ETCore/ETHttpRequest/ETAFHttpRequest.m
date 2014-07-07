//
//  ETAFHttpRequest.m
//  etaoshopping
//
//  Created by LionQ on 12-12-7.
//
//

#import "ETAFHttpRequest.h"
#import "ETAFHttpRequestClient.h"

@interface ETAFHttpRequest (){
    
}
@property (nonatomic,strong)ETAFHttpRequestClient *client;

@end

@implementation ETAFHttpRequest

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark getter methods

- (ETAFHttpRequestClient *)client{
    if (_client == nil){
        _client = [ETAFHttpRequestClient sharedInstance];
    }
    return _client;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark --
#pragma mark public methods

- (void)upLoadWithUrlString:(NSString *)urlString withParams:(NSMutableDictionary *)params withPrepare:(UpLoadPrepareBlock)prepareBlock withProgress:(UploadProgressBlock)progressBlock{
    NSData *uploadData = nil;
    for (NSString *key in [params allKeys]){
        if ([key isEqualToString:@"imagefile"]){
            uploadData = (NSData *)[params objectForKey:key];
            [params removeObjectForKey:key];
        }
    }
    ETLog(@"urlString = %@  , param = %@",urlString,params);
    NSMutableURLRequest *request = [self.client multipartFormRequestWithMethod:@"POST" path:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (uploadData) {
            [formData appendPartWithFileData:uploadData
                                        name:@"imagefile"
                                    fileName:@"photo.jpg"
                                    mimeType:@"image/jpeg"];
        }
    }];
    //NSLog(@"%@",request.URL.absoluteString);
    AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"[ETAFHttpRequest]-->responseObject:%@",responseObject);
        
        self.response = responseObject;
        
        [self requestSuccessWithResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailedWithError:error];
    }];
    if (progressBlock) {
        [operation setUploadProgressBlock:progressBlock];
    }
    if (prepareBlock) {
        prepareBlock(operation);
    }
}

- (void) load:(NSString*)url
{
    self.urlString = url;
    ETLog(@"[ETAFHttpRequest]-->load:%@",url);
    
    NSMutableURLRequest *request = [self.client requestWithMethod:@"GET" path:url parameters:nil];
    if (!self.timeoutValue) {
        self.timeoutValue = 10;
    }
    [request setTimeoutInterval:self.timeoutValue];
    AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.urlResponseString = operation.responseString;
        self.urlResponseData = operation.responseData;
        
        //交给父类
        [self requestSuccessWithResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        self.urlResponseString = operation.responseString;
        self.urlResponseData = operation.responseData;
        
        //交给父类
        [self requestFailedWithError:error];
    }];
    
    
    [self.client enqueueHTTPRequestOperation:operation];
}

- (void)cancel
{
    ETLog(@"cancel");
    [super cancel];
    
    if (self.urlString)
    {
        [self.client cancelAllHTTPOperationsWithMethod:@"GET" path:self.urlString];
    }
}



@end
