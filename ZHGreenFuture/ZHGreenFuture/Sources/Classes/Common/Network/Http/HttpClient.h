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
+(void)requestDataWithURL:(NSString*)url
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/// POST方法请求
+(void)postDataWithURL:(NSString*)url
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/// 上传数据，并监控进度
//+(void)upLoadDataWithURL:(NSString*)url
//                paramers:(NSDictionary*)paramers
//                 success:(void (^)(id responseObject))success
//                 failure:(void (^)(NSError *error))failure
//                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;

+(void)upLoadDataWithURL:(NSString*)url
                paramers:(NSDictionary*)paramers
                   datas:(NSDictionary*)datas
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;
@end
