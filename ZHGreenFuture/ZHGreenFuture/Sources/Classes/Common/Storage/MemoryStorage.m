//
//  MemoryStorage.m
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "MemoryStorage.h"

@interface MemoryStorage()

@property (nonatomic, strong) NSMutableDictionary*      keyMap;

+(MemoryStorage*)_instance;
@end

@implementation MemoryStorage

+(MemoryStorage*)shareInstance{
    return [MemoryStorage _instance];
}

+(MemoryStorage*)_instance{
    static MemoryStorage* _instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MemoryStorage alloc]init];
        
        _instance.keyMap = [[NSMutableDictionary alloc]initWithCapacity:1];
    });
    
    return _instance;
}

+(void)setValue:(id)value forKey:(id)key{
    if (!key || !value) {
        return;
    }
    
    MemoryStorage* _instance = [MemoryStorage _instance];

    if ( nil == value && [[_instance.keyMap allKeys]containsObject:key]) {
        [_instance.keyMap removeObjectForKey:key];
    }
    else{
        [_instance.keyMap setValue:value forKey:key];
    }
    
}

+(id)valueForKey:(id<NSCopying>)key{
    return [[MemoryStorage _instance].keyMap objectForKey:key];
}

@end
