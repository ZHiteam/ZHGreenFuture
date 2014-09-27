//
//  HttpClient.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject

/// GET方法请求
+(void)requestDataWithParamers:(NSDictionary*)paramers
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/// POST方法请求
+(void)postDataWithParamers:(NSDictionary*)paramers
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/// 上传数据，并监控进度
+(void)upLoadDataWithParamers:(NSDictionary*)paramers
                   datas:(NSDictionary*)datas
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;
@end
