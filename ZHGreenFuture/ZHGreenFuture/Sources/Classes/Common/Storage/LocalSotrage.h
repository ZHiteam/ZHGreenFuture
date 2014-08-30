//
//  LocalSotrage.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-17.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSotrage : NSObject

+(void)writeData:(NSData*)data fileName:(NSString*)fileName;

+(NSData*)dataWithFileName:(NSString*)fileName;

+(BOOL)existFile:(NSString*)fileName;

+(void)removeWithFileName:(NSString *)fileName;
@end
