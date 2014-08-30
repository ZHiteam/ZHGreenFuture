//
//  MemoryStorage.h
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryStorage : NSObject

+(MemoryStorage*)shareInstance;

/**
 * 存储内存变量
 */
+(void)setValue:(id)value forKey:(id<NSCopying>)key;

/**
 * 获取内存变量
 */
+(id)valueForKey:(id)key;

@end
