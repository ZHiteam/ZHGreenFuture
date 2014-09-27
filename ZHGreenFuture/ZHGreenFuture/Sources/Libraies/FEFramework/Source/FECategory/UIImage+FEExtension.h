//
//  UIImage+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-9-17.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FELineType){
	kLeftLine,
	kRightLine,
	kTopLine,
	kBottomLine,
	KRectLine,
	KLeftAndRightLine,
};

#define SCALE_TYPE_TOPLEFT 0		//从左上角开始绘制，无拉伸
#define SCALE_TYPE_FILL    1		//填充满整个区域
#define SCALE_TYPE_TILE    3		//平铺
#define SCALE_TYPE_FILLWITHSCALE 4  //按比例拉伸至整个区域
#define SCALE_TYPE_CENTER   5		//居中绘制
#define SCALE_TYPE_NINE_SCALE 9		//九宫拉伸

@interface UIImage (FEExtension)

/**
	解码图片
	@param image 图片
	@returns 解码过的图片
 */
+ (UIImage *)imageNormalized:(UIImage *)image;

/**
 *	@brief	以backColor填充背景，然后绘制image图片，仅当image有透明区域时可看出效果不同
 *
 *	@param 	image     图片
 *	@param 	backColor 填充的背景颜色
 *
 *	@return	填充背景后的图片
 */
+ (UIImage*)imageWithImage:(UIImage*)image backColor:(UIColor*)backColor;

/**
	由色块产生一张图
	@param rect 大小
	@returns 图片
 */
+ (UIImage *)imageWithColor:(UIColor*) color rect:(CGRect)rect;

/**
	从图片种截取其中一块
	@param image 源图片
	@param rect 截图区域
	@returns 截取图片
 */
+ (UIImage *)imageWithSource:(UIImage *)image rect:(CGRect)rect;


/**
	将图片等比拉伸到size大小
	@param image 原图
	@param size 目标大小
	@returns 处理后的图片
 */
+ (UIImage *)imageWithImage:(UIImage *)image size:(CGSize)size;

/**
	前景背景合成一张图
	@param back 背景图
	@param fore 前景图
	@param size 目标大小
	@returns 合成后的图片
 */
+ (UIImage *)imageWithBack:(UIImage *)back fore:(UIImage *)fore size:(CGSize)size;

//拉伸
+ (UIImage *)stretchImage:(UIImage *)image leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight destSize:(CGSize)size;
+ (UIImage *)stretchImage:(UIImage *)image leftCapWidth:(NSInteger)leftCapWidth rightCapWidth:(NSInteger)rightCapWidth topCapHeight:(NSInteger)topCapHeight bottomCapHeight:(NSInteger)bottomCapHeight destSize:(CGSize)size;
//九宫拉伸
+ (UIImage *)stretchImageH3V3:(UIImage *)image sourceRect:(CGRect)sourceRect innerRect:(CGRect)innerRect1 size:(CGSize)size;


#pragma mark - UIImage NSData 转换
+ (UIImage *)imageWithData:(void *)data size:(CGSize)size;

+ (UIImage *)imageWithCFData:(CFDataRef)dataRef size:(CGSize)size;

+ (UIImage *)imageWithDataProvider:(CGDataProviderRef)providerRef size:(CGSize)size;

+ (CFDataRef)copyDataFromImage:(UIImage*)image;

+(const UInt8*)rawDataFromImage:(UIImage*) image;

+(UIImage*) imageFromRawData:(const UInt8*) data size:(CGSize) size;

+ (UIImage*)imageWithBackground:(UIColor*)backColor size:(CGSize) size;

#pragma mark - Mask
+(UIImage *)grayImage:(UIImage *)source;

+(UIImage *)maskColor:(UIColor *)color withMask:(UIImage *)maskImage normalMethod:(BOOL)isNormalMethod;

+(UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage normalMethod:(BOOL)isNormalMethod;

+(UIImage *)maskImage:(UIImage *)image withMask:(UIImage*)maskImage backColor:(UIColor *)color;

+(UIImage *)imageFromText:(NSString*)text textFont:(UIFont*)textFont fontColor:(UIColor*)color  underLineFlag:(BOOL)flag;

+ (UIImage *)imageWithColor:(UIColor*) color rect:(CGRect)rect lineType:(FELineType)lineType  lineOffset:(CGFloat)offset lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor;

+ (UIImage *)imageWithColor:(UIColor*)backColor maskImage:(UIImage *)maskImage type:(NSInteger)type;

+ (UIImage *)imageWithScale:(UIImage *)image scaleRect:(CGRect)rect;
/*
 实现指定各种拉伸
 ０：从左上角开始绘制，无拉伸
 １：填充满整个区域
 ３：平铺
 ４：按比例拉伸至整个区域
 ５：居中绘制
 ９：九宫拉伸
 */
+ (UIImage *)imageWithScaleType:(NSInteger)scale image:(UIImage*)image innerRect:(CGRect)innerRect destSize:(CGSize)size;


+ (UIImage* )image:(UIImage*)image blendWithColor:(UIColor*)color mode:(CGBlendMode)mode;

/**
 *	@brief	从图中返回某些像素的颜色值
 *
 *	@param 	image 	源图片
 *  @param 	point   取图片颜色的起始点
 *	@param 	count 	取颜色的个数
 *
 *	@return	从图片image中点point开始的count点的颜色值UIColor的数组
 */
+ (NSArray*)getRGBAsFromImage:(UIImage*)image startPoint:(CGPoint) point  count:(int)count;


+(void)imageDebugOutput:(UIImage*)image;


@end
