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
@property (nonatomic,strong) UIControl*    mask;
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
        FELOG(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                FELOG(@"网络切换到未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                FELOG(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                FELOG(@"使用2G/3G网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                FELOG(@"使用wifi网络");
                break;
            default:
                break;
        }
    }];
}

+(void)requestDataWithParamers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client startAnimation];
    [client->_client GET:@"/greenFuture/serverAPI.action" parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [client stopAnimation];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [client stopAnimation];
        failure(error);
    }];
}

+(void)postDataWithParamers:(NSDictionary*)paramers success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    HttpClient* client = [HttpClient instance];
    [client startAnimation];
    [client->_client POST:@"/greenFuture/serverAPI.action" parameters:paramers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [client stopAnimation];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [client stopAnimation];
        failure(error);
    }];
}

+(void)upLoadDataWithParamers:(NSDictionary*)paramers
                   datas:(NSDictionary*)datas
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress{
    
    HttpClient* client = [HttpClient instance];
    AFHTTPRequestOperationManager*  httpClient = client->_client;
    
    httpClient.requestSerializer.timeoutInterval = 10;
    AFHTTPRequestOperation* op = [httpClient POST:@"/greenFuture/serverAPI.action" parameters:paramers constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString* name in datas.allKeys){
            id val = datas[name];
            if ([val isKindOfClass:[NSData class]]){
                [formData appendPartWithFileData:val
                                            name:name
                                        fileName:@"image.jpg"
                                        mimeType:@"image/jpeg"];
            }
            else if ([val isKindOfClass:[NSArray class]]){
                for (id value in val){
                    if ([value isKindOfClass:[NSData class]]){
                        [formData appendPartWithFileData:value
                                                    name:name
                                                fileName:@"image.jpg"
                                                mimeType:@"image/jpeg"];
                    }
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [client stopAnimation];
        if (success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [client stopAnimation];
        if (failure){
            failure(error);
        }
    }];
    [client startAnimationWithProgress:0];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld",totalBytesWritten,totalBytesExpectedToWrite);
        if (progress){
            [client startAnimationWithProgress:(totalBytesWritten*1.0/totalBytesExpectedToWrite)];
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
}

-(UIView*)mainView{
    UIView* mainView = [UIApplication sharedApplication].keyWindow;
    if (!mainView){
        mainView = ((NavigationViewController*)[MemoryStorage valueForKey:k_NAVIGATIONCTL]).view;
    }
    
    return mainView;
}

-(UIControl *)mask{
    if (!_mask){
        _mask = [[UIControl alloc]initWithFrame:self.mainView.bounds];
        _mask.backgroundColor = [UIColor clearColor];
    }
    return _mask;
}

-(void)startAnimation{
    [[self mainView] addSubview:self.mask];
    [SVProgressHUD showWithStatus:@"加载中..."];
}

-(void)stopAnimation{
    [self.mask removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)startAnimationWithProgress:(CGFloat)progress{
    [self.mask removeFromSuperview];
    [SVProgressHUD showProgress:progress status:@"上传中..."];
}
@end
