//
//  ModelManager.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ModelManager : NSObject

+(void)buildModelWithPath:(NSString*)path
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(NSArray* models))success
                  failure:(void (^)(NSError *error))failure;

@end
