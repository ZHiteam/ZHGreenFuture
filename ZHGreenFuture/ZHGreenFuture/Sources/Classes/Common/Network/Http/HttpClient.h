//
//  HttpClient.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject

+(void)requestData;

+(void)requestDataWithURL:(NSString*)url
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

+(void)postDataWithURL:(NSString*)url
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
@end
