//
//  NSDictionary+HKWF.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZHitem)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data;

-(id)objectForIndexKey:(NSInteger)index;

-(NSData*)toData;
@end

@interface NSMutableDictionary(ZHitem)

-(void)setObject:(id)object forIndexKey:(NSInteger)index;

-(void)removeObjectForIndexKey:(NSInteger)indexKey;

@end