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
        NSString* serverAddr = [[Config config]configForKey:HTTP_SERVER];

        if ( isEmptyString(serverAddr)) {
            ZHLOG(@"%@",@"服务器地址不可用");
        }
        else{
            NSURL *url = [NSURL URLWithString:serverAddr];
            _client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
            _client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        }
    }
    
    return self;
}

+(id)instance{
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


+(void)requestData{
    HttpClient* client = [HttpClient instance];
    
    [client->_client POST:@"/ZHiteam/test.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
}
@end
