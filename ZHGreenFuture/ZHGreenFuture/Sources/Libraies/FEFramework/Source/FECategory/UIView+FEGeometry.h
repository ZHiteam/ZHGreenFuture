//
//  UIView+FEGeometry.h
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FEGeometry)
/**
	获取x坐标
	@returns origin.x
 */
- (CGFloat)x;
/**
	获取y坐标
	@returns origin.y
 */
- (CGFloat)y;

/**
	获取宽度
	@returns size.width
 */
- (CGFloat)width;

/**
	获取高度
	@returns size.height
 */
- (CGFloat)height;

/**
	获取origin
	@returns frame.origin
 */
- (CGPoint)origin;

/**
	获取size
	@returns frame.size
 */
- (CGSize)size;

/**
    设置x坐标
    @param x origin.x
 */
- (void)setOriginX:(CGFloat)x;

/**
    设置y坐标
    @param y origin.y
 */
- (void)setOriginY:(CGFloat)y;

/**
	设置高度
	@param height size.height
 */
- (void)setHeight:(CGFloat)height;

/**
	设置宽度
	@param width size.width
 */
- (void)setWidth:(CGFloat)width;

/**
	设置origin
	@param origin frame.origin
 */
- (void)setOrigin:(CGPoint)origin;

/**
	设置size
	@param size frame.size
 */
- (void)setSize:(CGSize)size;

/**
	设置x,y坐标
	@param x origin.x
	@param y origin.y
 */
- (void)setOriginX:(CGFloat)x andY:(CGFloat)y;

/**
	设置width,height
	@param width size.width
	@param height size.height
 */
- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
