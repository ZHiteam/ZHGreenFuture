//
//  NSArray+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "NSArray+FEExtension.h"
#import <objc/message.h>
#import "FEMacroDefine.h"

@implementation NSArray (FEExtension)

- (id) firstObject{
    return [self count] >0 ? [self objectAtIndex:0] : nil;
}

- (NSArray *) uniqueMembers{
	NSMutableArray *mutArray = [self mutableCopy];
	for (id object in self){
		[mutArray removeObjectIdenticalTo:object];//删除所有与object 地址相同的对象
		[mutArray addObject:object];
	}
	return [mutArray copy];
}


- (NSArray *) unionWithArray:(NSArray *) anArray{
    if (![anArray count]) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSArray *) intersectionWithArray:(NSArray *) anArray{
    if (![anArray count]) return self;
	NSMutableArray *mutArray = [self mutableCopy];
	for (id object in self)
		if (![anArray containsObject:object])
			[mutArray removeObjectIdenticalTo:object];
	return [[mutArray copy] uniqueMembers];
}

- (NSArray*) xorWithArray:(NSArray*)anArray{
    if (![anArray count]) return self;
	NSMutableArray *mutArray = [self mutableCopy];
    [mutArray removeObjectsInArray:anArray];
    return [mutArray copy];
}

- (NSArray *)filterUsingBlock:(BOOL (^)(id obj))block{
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block) {
            if(block(obj)){
                [resultArray addObject:obj];
            };
        }
    }];
    return [resultArray copy];
}

- (NSData*)toData{
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    if (error) {
        NSLog(@">>>[NSArray toData] Error:%@",error);
    }
    return data;
    //NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (NSArray*)fromData:(NSData*)data
{
    NSError *error;
    NSArray* array = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:&error];
    //NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (![array isKindOfClass:[NSArray class]]) {
        NSLog(@">>>[NSArray toData] Warning:object is %@",array);
    }
    return array;
}


#pragma mark - Getter Base Type
/**
 返回Bool值
 @param index 索引值
 @returns 返回Bool值
 */
- (BOOL)boolAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) boolValue];
}

/**
 返回NSInteger值
 @param index 索引值
 @returns 返回NSInteger值
 */
- (NSInteger)integerAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) integerValue];
}

/**
 返回CGFloat值
 @param index 索引值
 @returns 返回CGFloat值
 */
- (CGFloat)floatAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) floatValue];
}

/**
 返回CGPoint
 @param index 索引值
 @returns 返回CGPoint
 */
- (CGPoint)pointAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) CGPointValue];
}

/**
 返回CGFloat值
 @param index 索引值
 @returns 返回CGSize
 */
- (CGSize)sizeAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) CGSizeValue];
}

/**
 返回CGRect值
 @param index 索引值
 @returns 返回CGRect
 */
- (CGRect)rectAtIndex:(NSUInteger)index{
    return [FEObjectAtIndex(self, index) CGRectValue];
}

@end

@implementation NSMutableArray(FEStack)
- (NSMutableArray*)push:(id)object{
    return [self pushObject:object];
}

- (id)pop{
    return [self popObject];
}

- (NSMutableArray *) pushObject:(id)object{
    if (!object) return self;
    [self addObject:object];
	return self;
}

- (NSMutableArray *) pushObjects:(id)object,...{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do{
		[self addObject:obj];
		obj = va_arg(objects, id);
	} while (obj);
	va_end(objects);
	return self;
}
- (id) popObject{
	if (![self count]) return nil;
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}


@end

#pragma mark - Setter Base Type
@implementation NSMutableArray (FEBaseType)

- (void)addObjectEx:(NSValue*)value{
    if (value) {
        [self addObject:value];
    }
}
- (void)addBool:(BOOL)value{
    [self addObjectEx:[NSNumber numberWithBool:value]];
}

- (void)addInteger:(NSInteger)value{
    [self addObjectEx:[NSNumber numberWithInteger:value]];
}

- (void)addFloat:(CGFloat)value{
    [self addObjectEx:[NSNumber numberWithFloat:value]];
}

- (void)addCGPoint:(CGPoint)point{
    [self addObjectEx:[NSValue valueWithCGPoint:point]];
}

- (void)addCGSize:(CGSize)size{
    [self addObjectEx:[NSValue valueWithCGSize:size]];
}

- (void)addCGRect:(CGRect)rect{
    [self addObjectEx:[NSValue valueWithCGRect:rect]];
}

- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index{
    if (index < [self count]) {
        [self insertObject:[NSNumber numberWithInteger:value] atIndex:index];
    }
}

@end

#pragma mark - shuffle
@implementation NSMutableArray (FEShuffle)
- (void)shuffle
{
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
