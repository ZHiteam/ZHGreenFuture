//
//  NSArray+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FEExtension)
/**
	返回第一个元素
	@returns 返回第一个元素
 */
- (id) firstObject;

/**
	返回包含元素地址不同对象的集合，注意是“地址”，而非“内容”
	@returns 返回包含元素地址不同对象的集合
 */
- (NSArray *)uniqueMembers;

/**
	合并两个集合元素
	@param anArray 要合并的集合
	@returns 合并后的集合
 */
- (NSArray *)unionWithArray:(NSArray *)anArray;

/**
	两个集合交集的元素
	@returns 交集元素的集合
 */
- (NSArray *)intersectionWithArray:(NSArray *) anArray;

/**
	两个集合的差集
	@param anArray 要取差集的集合
	@returns 差集元素的集合
 */
- (NSArray*)xorWithArray:(NSArray*)anArray;
#if NS_BLOCKS_AVAILABLE
/**
	过滤集合元素，使用block
	@returns 过滤使用的block
 */
- (NSArray *)filterUsingBlock:(BOOL (^)(id obj))block;
#endif

#pragma mark - Serialization
/**
	使用NSPropertyListSerialization 序列化
	@returns 序列化后的数据
 */
- (NSData*)toData;

/**
	使用NSPropertyListSerialization 反序列化
	@param data 原始数据
	@returns 反序列化的集合
 */
+ (NSArray*)fromData:(NSData*)data;

#pragma mark - Getter Base Type
/**
	返回Bool值
	@param index 索引值
	@returns 返回Bool值
 */
- (BOOL)boolAtIndex:(NSUInteger)index;

/**
	返回NSInteger值
	@param index 索引值
	@returns 返回NSInteger值
 */
- (NSInteger)integerAtIndex:(NSUInteger)index;

/**
	返回CGFloat值
	@param index 索引值
	@returns 返回CGFloat值
 */
- (CGFloat)floatAtIndex:(NSUInteger)index;

/**
	返回CGPoint
	@param index 索引值
	@returns 返回CGPoint
 */
- (CGPoint)pointAtIndex:(NSUInteger)index;

/**
    返回CGFloat值
	@param index 索引值
	@returns 返回CGSize
 */
- (CGSize)sizeAtIndex:(NSUInteger)index;

/**
	返回CGRect值
	@param index 索引值
	@returns 返回CGRect
 */
- (CGRect)rectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray(FEStack)
/**
	栈的push操作
	@param object 要加入栈的元素
	@returns 加入元素后的集合
 */
- (NSMutableArray*)push:(id)object;
/**
	栈的pop操作
	@returns 出栈元素
 */
- (id)pop;
/**
	栈的push操作
    @param object 要加入栈的元素
    @returns 加入元素后的集合
 */
- (NSMutableArray *) pushObject:(id)object;
/**
	栈的push操作，支持多个元素
	@param object 要加入栈的多个元素
	@returns 加入元素后的集合
 */
- (NSMutableArray *) pushObjects:(id)object,...;
/**
    栈的pop操作
    @returns 出栈元素
 */
- (id) popObject;

@end

#pragma mark - Setter Base Type
@interface NSMutableArray (FEBaseType)
- (void)addBool:(BOOL)value;
- (void)addInteger:(NSInteger)value;
- (void)addFloat:(CGFloat)value;
- (void)addCGPoint:(CGPoint)point;
- (void)addCGSize:(CGSize)size;
- (void)addCGRect:(CGRect)rect;
- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index;
@end

#pragma mark - shuffle
@interface NSMutableArray (FEShuffle)
/**
	洗牌，随机调整array中元素的位置
 */
- (void)shuffle;

@end

