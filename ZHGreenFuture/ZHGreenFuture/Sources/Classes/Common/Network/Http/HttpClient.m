//
//  HttpClient.m
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworkReachabilityManager.h"

#import "AFHTTPRequestOperationManager.h"

@interface HttpClient(){
    AFHTTPRequestOperationManager*  _client;
}
@end


@implementation HttpClient

-(id)init{
    self = [super init];
    
    if (self) {

        NSURL* url = [NSURL URLWithString:@"http://115.29.207.63:8080/greenFuture/"];
        _client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
        _client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _client.requestSerializer.timeoutInterval = kTimeoutInterval;
    }
    
    return self;
}

+(HttpClient*)instance{
    return [HttpClient instanceWithCLass:[HttpClient class]];
}

-(void)prepareData{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        ZHLOG(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                ZHLOG(@"网络切换到未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                ZHLOG(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                ZHLOG(@"使用2G/3G网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                ZHLOG(@"使用wifi网络");
                break;
            default:
                break;
        }
    }];
}

+(void)requestDataWithURL:(NSString*)url paramers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client->_client GET:url parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+(void)postDataWithURL:(NSString*)url paramers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client->_client POST:url parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    [operation start];
}

+(void)upLoadDataWithURL:(NSString*)url
                paramers:(NSDictionary*)paramers
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress{
    AFHTTPRequestOperationManager*  httpClient = [HttpClient instance]->_client;
    
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
//    }];
    
    NSMutableURLRequest *request = [httpClient.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:httpClient.baseURL] absoluteString] parameters:paramers error:nil];
    AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure){
            failure(error);
        }
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        ZHLOG(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        if (progress){
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    [operation start];  

    
}
@end
