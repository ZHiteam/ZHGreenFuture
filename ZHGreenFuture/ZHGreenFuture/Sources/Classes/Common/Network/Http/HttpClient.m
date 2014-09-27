//
//  HttpClient.m
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

@interface HttpClient(){
    AFHTTPRequestOperationManager*  _client;
}
@end


@implementation HttpClient

-(id)init{
    self = [super init];
    
    if (self) {

        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_SITE]];
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

+(void)requestDataWithParamers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client->_client GET:@"/greenFuture/serverAPI.action" parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+(void)postDataWithParamers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client->_client POST:@"/greenFuture/serverAPI.action" parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+(void)upLoadDataWithParamers:(NSDictionary*)paramers
                   datas:(NSDictionary*)datas
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress{
    
    AFHTTPRequestOperationManager*  httpClient = [HttpClient instance]->_client;    
    AFHTTPRequestOperation* op = [httpClient POST:@"/greenFuture/serverAPI.action" parameters:@{@"scene":@"27",@"userId":@"1"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString* name in datas.allKeys){
            [formData appendPartWithFileData:datas[name] name:name fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure){
            failure(error);
        }
    }];
    
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld",totalBytesWritten,totalBytesExpectedToWrite);
        if (progress){
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
}
@end
