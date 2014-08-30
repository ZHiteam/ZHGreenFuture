//
//  NSObject+Instance.m
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "NSObject+Instance.h"

@implementation NSObject (Instance)

+(id)instanceWithCLass:(Class)aClass;{
    if (!aClass) {
        return nil;
    }
    
    if ([MemoryStorage valueForKey:NSStringFromClass(aClass)]) {
        return [MemoryStorage valueForKey:NSStringFromClass(aClass)];
    }
    
    __block id val = nil;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        val = [[aClass alloc]init];
        [MemoryStorage setValue:val forKey:NSStringFromClass(aClass)];
//    });
    
    return val;
}


@end
