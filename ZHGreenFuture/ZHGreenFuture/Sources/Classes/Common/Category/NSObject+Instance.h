//
//  NSObject+Instance.h
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Instance)

/**
 * 单例类基础方法，创建单例全部放置在instance的keymap中
 */
+(id)instanceWithCLass:(Class)aClass;

@end
