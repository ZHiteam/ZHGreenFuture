//
//  UIImage+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-9-17.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIImage+FEExtension.h"
#import "FEMacroDefine.h"

static BOOL gIsRetinaSkin = NO;
BOOL FESkinIsRetina()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gIsRetinaSkin = [UIScreen mainScreen].scale > 1.0;
    });
    return gIsRetinaSkin;
}

@implementation UIImage (FEExtension)
/**
 解码图片
 @param image 图片
 @returns 解码过的图片
 */
+ (UIImage *)imageNormalized:(UIImage *)image
{
    NSInteger width  = image.size.width  * image.scale;
	NSInteger height = image.size.height * image.scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, (4 * width), colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
	CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return imageRet;
}

/**
 *	@brief	以backColor填充背景，然后绘制image图片，仅当image有透明区域时可看出效果不同
 *
 *	@param 	image     图片
 *	@param 	backColor 填充的背景颜色
 *
 *	@return	填充背景后的图片
 */
+ (UIImage*)imageWithImage:(UIImage*)image backColor:(UIColor*)backColor
{
	UIImage   *imageRet = nil;
	if (image&&backColor)
	{
		CGSize size = image.size;
		NSInteger scale = FESkinIsRetina() ? 2 : 1;
		if (scale > 1)
		{
			size = CGSizeScale(size, scale);
		}
		
		NSInteger width  = size.width;
		NSInteger height = size.height;
		CGRect imageRect = CGRectMake(0,0, size.width,size.height);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, (4 * width), colorSpace, (CGBitmapInfo)(CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        
		CGContextSetFillColorWithColor(context, backColor.CGColor);
		CGContextFillRect(context, CGRectMake(0,0,size.width,size.height));
		CGContextDrawImage(context, imageRect, image.CGImage);
        
		CGImageRef imageRef = CGBitmapContextCreateImage(context);
		imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		CGImageRelease(imageRef);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
	}
    return  imageRet;
}

/**
 由色块产生一张图
 @param rect 大小
 @returns 图片
 */
+ (UIImage *)imageWithColor:(UIColor*) color rect:(CGRect)rect
{
	color = color==nil?[UIColor clearColor]:color;
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
        rect = CGRectScale(rect,scale);
    }
    NSInteger width  = rect.size.width;
    NSInteger height = rect.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)(CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	CGContextSetFillColorWithColor(context,color.CGColor);
	CGContextFillRect(context,rect);
	CGImageRef imageRef2 = CGBitmapContextCreateImage(context);
    UIImage   *imageRet  = [UIImage imageWithCGImage:imageRef2 scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef2);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	return imageRet;
}

/**
 从图片种截取其中一块
 @param image 源图片
 @param rect 截图区域
 @returns 截取图片
 */
+ (UIImage *)imageWithSource:(UIImage *)image rect:(CGRect)rect
{
	
	if (image==nil||CGSizeEqualToSize(CGSizeZero, rect.size))
	{
		return nil;
	}
	if (CGSizeEqualToSize(image.size, rect.size))
	{
		return image;
	}
    
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
        rect = CGRectScale(rect, scale);
    }
    
    NSInteger width  = rect.size.width;
    NSInteger height = rect.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	CGImageRef imageRef1 = CGImageCreateWithImageInRect([image CGImage], rect);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef1);
	CGImageRef imageRef2 = CGBitmapContextCreateImage(context);
    UIImage   *imageRet  = [UIImage imageWithCGImage:imageRef2 scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef1);
    CGImageRelease(imageRef2);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	return imageRet;
}

/**
 将图片等比拉伸到size大小
 @param image 原图
 @param size 目标大小
 @returns 处理后的图片
 */
+ (UIImage *)imageWithImage:(UIImage *)image size:(CGSize)size
{
	UIImage   *imageRet = nil;
	if (image&&CGSizeEqualToSize(size, CGSizeZero)==NO)
	{
		NSInteger scale = FESkinIsRetina() ? 2 : 1;
		if (scale > 1)
		{
			size = CGSizeScale(size, scale);
		}
		NSInteger width  = size.width;
		NSInteger height = size.height;
		
		CGRect imageRect = CGRectMake(0,0, size.width,size.height);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, (4 * width), colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
		CGContextDrawImage(context, imageRect, image.CGImage);
		CGImageRef imageRef = CGBitmapContextCreateImage(context);
		imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		CGImageRelease(imageRef);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
	}
    return imageRet;
}

/**
 前景背景合成一张图
 @param back 背景图
 @param fore 前景图
 @param size 目标大小
 @returns 合成后的图片
 */
+ (UIImage *)imageWithBack:(UIImage *)back fore:(UIImage *)fore size:(CGSize)size
{
	if (CGSizeEqualToSize(size, CGSizeZero))
	{
		return nil;
	}
	CGFloat originX = roundf((size.width - back.size.width) / 2);
	CGFloat originY = roundf((size.height - back.size.height) / 2);
	CGFloat width = MIN(size.width,back.size.width);
	CGFloat height= MIN(size.height,back.size.height);
	originX = originX<0?0:originX;
	originY = originY<0?0:originY;
    CGRect rect1 = CGRectMake(originX,originY,width, height);
	originX = roundf((size.width - fore.size.width) / 2);
	originY = roundf((size.height - fore.size.height) / 2);
	width = MIN(size.width,fore.size.width);
	height= MIN(size.height,fore.size.height);
	originX = originX<0?0:originX;
	originY = originY<0?0:originY;
    CGRect rect2 = CGRectMake(originX,originY,width,height);
    if (size.width<=fore.size.width+2)
	{
		rect2 = CGRectInset(rect2, 1, 0);
	}
	if (size.height<fore.size.height)
	{
		rect2 = CGRectInset(rect2, 0, 1);
	}
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
        rect1 = CGRectScale(rect1, scale);
        rect2 = CGRectScale(rect2, scale);
        size  = CGSizeScale(size,  scale);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate (NULL, size.width, size.height, 8, size.width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, rect1, back.CGImage);
    CGContextDrawImage(context, rect2, fore.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return imageRet;
}

+ (UIImage *)stretchImage:(UIImage *)image leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight destSize:(CGSize)size
{
	return  [[self class] stretchImage:image leftCapWidth:leftCapWidth rightCapWidth:leftCapWidth topCapHeight:topCapHeight bottomCapHeight:topCapHeight destSize:size];
}

+ (UIImage *)stretchImage:(UIImage *)image leftCapWidth:(NSInteger)leftCapWidth rightCapWidth:(NSInteger)rightCapWidth topCapHeight:(NSInteger)topCapHeight bottomCapHeight:(NSInteger)bottomCapHeight destSize:(CGSize)size
{
	NSInteger scale = FESkinIsRetina() ? 2 : 1;
	CGSize imageSize = [image size];
    CGFloat offsetX   = leftCapWidth;
    CGFloat offsetY   = topCapHeight;
    CGFloat offsetXR = rightCapWidth;
    CGFloat offsetYB = bottomCapHeight;
    CGRect  outerRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGRect  innerRect = CGRectMake(offsetX, offsetY, imageSize.width-offsetX-offsetXR, imageSize.height-offsetY-offsetYB);
    
    if (scale > 1)
    {
        outerRect = CGRectScale(outerRect, scale);
        innerRect = CGRectScale(innerRect, scale);
        size      = CGSizeScale(size, scale);
    }
    
    NSInteger width  = size.width;
    NSInteger height = size.height;
    
	if (imageSize.width<leftCapWidth+rightCapWidth||imageSize.height<topCapHeight+bottomCapHeight||size.height==0)
	{
		return nil;
	}
    else if (imageSize.width == leftCapWidth+rightCapWidth||leftCapWidth+rightCapWidth==0){
        CGRect  srcRect[3];
        CGFloat srcH1 = innerRect.origin.y; CGFloat srcH2 = innerRect.size.height; CGFloat srcH3 = outerRect.size.height - srcH1 - srcH2;
        CGFloat srcY1 = 0; CGFloat srcY2 = srcH1; CGFloat srcY3 = srcH1 + srcH2;
        CGFloat srcX  = 0; CGFloat srcW = outerRect.size.width;
        srcRect[2] = CGRectMake(srcX, srcY1, srcW, srcH1);
        srcRect[1] = CGRectMake(srcX, srcY2, srcW, srcH2);
        srcRect[0] = CGRectMake(srcX, srcY3, srcW, srcH3);
        
        CGRect  dstRect[3];
        CGFloat dstH1 = srcH3; CGFloat dstH2 = height - srcH1 - srcH3; CGFloat dstH3 = srcH1;
        CGFloat dstY1 = 0; CGFloat dstY2 = dstH1; CGFloat dstY3 = dstH1 + dstH2;
        dstRect[0] = CGRectMake(srcX, dstY1, srcW, dstH1);
        dstRect[1] = CGRectMake(srcX, dstY2, srcW, dstH2);
        dstRect[2] = CGRectMake(srcX, dstY3, srcW, dstH3);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        for (int i = 0; i < 3; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], srcRect[i]);
            CGContextDrawImage(context, dstRect[i], imageRef);
            CGImageRelease(imageRef);
        }
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return imageRet;
    }
    else if (imageSize.height == topCapHeight+bottomCapHeight || topCapHeight+bottomCapHeight == 0){
        CGRect  srcRect[3];
        CGFloat srcW1 = innerRect.origin.x; CGFloat srcW2 = innerRect.size.width; CGFloat srcW3 = outerRect.size.width  - srcW1 - srcW2;
        CGFloat srcX1 = 0; CGFloat srcX2 = srcW1; CGFloat srcX3 = srcW1 + srcW2;
        CGFloat srcY  = 0; CGFloat srcH  = outerRect.size.height;
        srcRect[0] = CGRectMake(srcX1, srcY, srcW1, srcH);
        srcRect[1] = CGRectMake(srcX2, srcY, srcW2, srcH);
        srcRect[2] = CGRectMake(srcX3, srcY, srcW3, srcH);
        
        CGRect  dstRect[3];
        CGFloat dstW1 = srcW1; CGFloat dstW2 = width  - srcW1 - srcW3; CGFloat dstW3 = srcW3;
        CGFloat dstX1 = 0; CGFloat dstX2 = dstW1; CGFloat dstX3 = dstW1 + dstW2;
        dstRect[0] = CGRectMake(dstX1, srcY, dstW1, srcH);
        dstRect[1] = CGRectMake(dstX2, srcY, dstW2, srcH);
        dstRect[2] = CGRectMake(dstX3, srcY, dstW3, srcH);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        for (int i = 0; i < 3; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], srcRect[i]);
            CGContextDrawImage(context, dstRect[i], imageRef);
            CGImageRelease(imageRef);
            
        }
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return imageRet;
    }
    else{
        CGRect  srcRect[9];
        CGFloat srcW1 = innerRect.origin.x; CGFloat srcW2 = innerRect.size.width;  CGFloat srcW3 = outerRect.size.width  - srcW1 - srcW2;
        CGFloat srcH1 = innerRect.origin.y; CGFloat srcH2 = innerRect.size.height; CGFloat srcH3 = outerRect.size.height - srcH1 - srcH2;
        CGFloat srcX1 = 0; CGFloat srcX2 = srcW1; CGFloat srcX3 = srcW1 + srcW2;
        CGFloat srcY1 = 0; CGFloat srcY2 = srcH1; CGFloat srcY3 = srcH1 + srcH2;
        srcRect[6] = CGRectMake(srcX1, srcY1, srcW1, srcH1);
        srcRect[7] = CGRectMake(srcX2, srcY1, srcW2, srcH1);
        srcRect[8] = CGRectMake(srcX3, srcY1, srcW3, srcH1);
        srcRect[3] = CGRectMake(srcX1, srcY2, srcW1, srcH2);
        srcRect[4] = CGRectMake(srcX2, srcY2, srcW2, srcH2);
        srcRect[5] = CGRectMake(srcX3, srcY2, srcW3, srcH2);
        srcRect[0] = CGRectMake(srcX1, srcY3, srcW1, srcH3);
        srcRect[1] = CGRectMake(srcX2, srcY3, srcW2, srcH3);
        srcRect[2] = CGRectMake(srcX3, srcY3, srcW3, srcH3);
        
        CGRect  dstRect[9];
        CGFloat dstW1 = srcW1; CGFloat dstW2 = width  - srcW1 - srcW3; CGFloat dstW3 = srcW3;
        CGFloat dstH1 = srcH3; CGFloat dstH2 = height - srcH1 - srcH3; CGFloat dstH3 = srcH1;
        CGFloat dstX1 = 0; CGFloat dstX2 = dstW1; CGFloat dstX3 = dstW1 + dstW2;
        CGFloat dstY1 = 0; CGFloat dstY2 = dstH1; CGFloat dstY3 = dstH1 + dstH2;
        dstRect[0] = CGRectMake(dstX1, dstY1, dstW1, dstH1);
        dstRect[1] = CGRectMake(dstX2, dstY1, dstW2, dstH1);
        dstRect[2] = CGRectMake(dstX3, dstY1, dstW3, dstH1);
        dstRect[3] = CGRectMake(dstX1, dstY2, dstW1, dstH2);
        dstRect[4] = CGRectMake(dstX2, dstY2, dstW2, dstH2);
        dstRect[5] = CGRectMake(dstX3, dstY2, dstW3, dstH2);
        dstRect[6] = CGRectMake(dstX1, dstY3, dstW1, dstH3);
        dstRect[7] = CGRectMake(dstX2, dstY3, dstW2, dstH3);
        dstRect[8] = CGRectMake(dstX3, dstY3, dstW3, dstH3);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        for (int i = 0; i < 9; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], srcRect[i]);
            CGContextDrawImage(context, dstRect[i], imageRef);
            CGImageRelease(imageRef);
        }
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        //UIImage   *imageRet = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return imageRet;
    }
}


+ (UIImage *)stretchImageH3V3:(UIImage *)image sourceRect:(CGRect)sourceRect innerRect:(CGRect)innerRect1 size:(CGSize)size
{
	if (CGRectIsEmpty(innerRect1))
	{
		return image;
	}
	//解决皮肤定义的拉伸区域错误（少了一个像素）苹果风格布局皮肤
	if ((sourceRect.origin.y+sourceRect.size.height)==innerRect1.origin.y)
	{
		CGRect rect =  innerRect1;
		rect.origin.y  = rect.origin.y-1;
		innerRect1 = rect;
	}
    
    // _w1___w2____w3_
	//|  0    1    2 |
    //h1|              |
	//|              |
    //h2|  3    4    5 |
	//|              |
    //h3|              |
	//|__6____7____8_|
	//
    
    NSInteger scale   = FESkinIsRetina() ? 2 : 1;
    CGFloat offsetX   = innerRect1.origin.x - sourceRect.origin.x;
    CGFloat offsetY   = innerRect1.origin.y - sourceRect.origin.y;
    CGRect  outerRect = CGRectMake(0, 0, sourceRect.size.width, sourceRect.size.height);
    CGRect  innerRect = CGRectMake(offsetX, offsetY, innerRect1.size.width, innerRect1.size.height);
    if (scale > 1)
    {
        outerRect = CGRectScale(outerRect, scale);
        innerRect = CGRectScale(innerRect, scale);
        size      = CGSizeScale(size, scale);
    }
    
    NSInteger width  = size.width;
    NSInteger height = size.height;
    
    CGRect  srcRect[9];
    CGFloat srcW1 = innerRect.origin.x; CGFloat srcW2 = innerRect.size.width;  CGFloat srcW3 = outerRect.size.width  - srcW1 - srcW2;
    CGFloat srcH1 = innerRect.origin.y; CGFloat srcH2 = innerRect.size.height; CGFloat srcH3 = outerRect.size.height - srcH1 - srcH2;
    CGFloat srcX1 = 0; CGFloat srcX2 = srcW1; CGFloat srcX3 = srcW1 + srcW2;
    CGFloat srcY1 = 0; CGFloat srcY2 = srcH1; CGFloat srcY3 = srcH1 + srcH2;
	srcRect[6] = CGRectMake(srcX1, srcY1, srcW1, srcH1);
	srcRect[7] = CGRectMake(srcX2, srcY1, srcW2, srcH1);
	srcRect[8] = CGRectMake(srcX3, srcY1, srcW3, srcH1);
	srcRect[3] = CGRectMake(srcX1, srcY2, srcW1, srcH2);
	srcRect[4] = CGRectMake(srcX2, srcY2, srcW2, srcH2);
	srcRect[5] = CGRectMake(srcX3, srcY2, srcW3, srcH2);
	srcRect[0] = CGRectMake(srcX1, srcY3, srcW1, srcH3);
	srcRect[1] = CGRectMake(srcX2, srcY3, srcW2, srcH3);
	srcRect[2] = CGRectMake(srcX3, srcY3, srcW3, srcH3);
    
    CGRect  dstRect[9];
    CGFloat dstW1 = srcW1; CGFloat dstW2 = width  - srcW1 - srcW3; CGFloat dstW3 = srcW3;
    CGFloat dstH1 = srcH3; CGFloat dstH2 = height - srcH1 - srcH3; CGFloat dstH3 = srcH1;
    CGFloat dstX1 = 0; CGFloat dstX2 = dstW1; CGFloat dstX3 = dstW1 + dstW2;
    CGFloat dstY1 = 0; CGFloat dstY2 = dstH1; CGFloat dstY3 = dstH1 + dstH2;
	dstRect[0] = CGRectMake(dstX1, dstY1, dstW1, dstH1);
	dstRect[1] = CGRectMake(dstX2, dstY1, dstW2, dstH1);
	dstRect[2] = CGRectMake(dstX3, dstY1, dstW3, dstH1);
	dstRect[3] = CGRectMake(dstX1, dstY2, dstW1, dstH2);
	dstRect[4] = CGRectMake(dstX2, dstY2, dstW2, dstH2);
	dstRect[5] = CGRectMake(dstX3, dstY2, dstW3, dstH2);
	dstRect[6] = CGRectMake(dstX1, dstY3, dstW1, dstH3);
	dstRect[7] = CGRectMake(dstX2, dstY3, dstW2, dstH3);
	dstRect[8] = CGRectMake(dstX3, dstY3, dstW3, dstH3);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	for (int i = 0; i < 9; i++)
    {
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], srcRect[i]);
        CGContextDrawImage(context, dstRect[i], imageRef);
        CGImageRelease(imageRef);
	}
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return imageRet;
}

#pragma mark - UIImage NSData 转换

+ (UIImage *)imageWithData:(void *)data size:(CGSize)size
{
    NSInteger length   = size.width * size.height * (FESkinIsRetina() ? 16 : 4);
    CFDataRef dataRef  = CFDataCreate(NULL, data, length);
    UIImage  *imageRet = [[self class]  imageWithCFData:dataRef size:size];
    CFRelease(dataRef);
    return imageRet;
}

+ (UIImage *)imageWithCFData:(CFDataRef)dataRef size:(CGSize)size
{
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    UIImage *imageRet = [[self class]  imageWithDataProvider:provider size:size];
    CGDataProviderRelease(provider);
    return imageRet;
}

+ (UIImage *)imageWithDataProvider:(CGDataProviderRef)providerRef size:(CGSize)size
{
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
        size = CGSizeScale(size, scale);
    }
    
    size_t width  = size.width;
    size_t height = size.height;
    
    CGColorSpaceRef   colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst, providerRef, nil, NO, kCGRenderingIntentDefault);
    UIImage   *imageRet  = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return imageRet;
}

+ (CFDataRef)copyDataFromImage:(UIImage *)image
{
    return CGDataProviderCopyData(CGImageGetDataProvider([image CGImage]));
}

//+ (UInt8 *)copyDataFromUIImage:(UIImage *)image
//{
//    if(image == nil)
//    {
//        return nil;
//    }
//
//    size_t width  = CGImageGetWidth(image.CGImage);
//    size_t height = CGImageGetHeight(image.CGImage);
//    size_t length = 4 * width * height;
//    if(width == 0 || height == 0)
//    {
//        return nil;
//    }
//
//    UInt8* data = (UInt8 *)malloc(length);
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef    contextRef = CGBitmapContextCreate(data,
//                                            width, height,
//                                            8, width * 4,
//                                            colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage );
//    CGContextRelease(contextRef);
//    CGColorSpaceRelease(colorSpace);
//
//    return data;
//}


+(const UInt8*)rawDataFromImage:(UIImage*) image
{
    const UInt8* data = NULL;
    if (image) {
        CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
        data = CFDataGetBytePtr(pixelData);
        CFRelease(pixelData);
    }
    
    return  data;
}


+(UIImage*) imageFromRawData:(const UInt8*) data size:(CGSize) size
{
    UIImage* result = nil;
    if (data) {
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, size.width*size.height*4, NULL);
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo =    kCGBitmapByteOrderDefault | kCGImageAlphaLast;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        int bitsPerComponent = 8;
        int bitsPerPixel = 32;
        int bytesPerRow = 4 * size.width;
        CGImageRef imageRef = CGImageCreate(size.width, size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        result = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGDataProviderRelease(provider);
    }
    return result;
}

+ (UIImage*)imageWithBackground:(UIColor*)backColor size:(CGSize) size
{
    
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
        size = CGSizeScale(size, scale);
    }
    
    backColor = backColor==nil?[UIColor clearColor]:backColor;
    //CGColorRef colorRef = [backColor CGColor];
    //const CGFloat *components = CGColorGetComponents(colorRef);
    
    NSInteger width  = size.width;
	NSInteger height = size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, (4 * width), colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	CGContextSetFillColorWithColor(context, backColor.CGColor);
	CGContextFillRect(context, CGRectMake(0,0,size.width,size.height));
    //CGContextSetRGBFillColor(context, components[0],components[1],components[2], components[3]);
    //CGRect rect1 = CGRectMake(0,0,size.width,size.height);
    //CGContextAddRect(context,rect1);
    //CGContextFillPath(context);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
	CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return  imageRet;
}

+(UIImage *)grayImage:(UIImage *)source
{
    
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    CGSize size  = source.size;
    
    if (scale > 1)
    {
        size = CGSizeScale(size, scale);
    }
    
    int width = size.width;
    int height = size.height;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL)
    {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), source.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage: imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return grayImage;
}

+(UIImage *)maskColor:(UIColor *)color withMask:(UIImage *)maskImage normalMethod:(BOOL)isNormalMethod
{
	UIImage* image = nil;
	if (color&&maskImage)
	{
		image = [[self class]  imageWithBackground:color size:maskImage.size];
		image = [[self class]  maskImage:image withMask:maskImage normalMethod:YES];
	}
	return image;
}

+(UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage normalMethod:(BOOL)isNormalMethod
{
    CGImageRef imageRef = image.CGImage;
    CGImageRef maskRef = maskImage.CGImage;
    //tmp debug for new cloud iocn
    int bpx = CGImageGetBitsPerPixel(maskRef);
    
	if (!isNormalMethod)
	{
		if (bpx > 24) {  //has alpha channle
			maskRef =  [self grayImage:maskImage].CGImage;
		}
	}
    
    CGContextRef mainViewContentContext;
    CGColorSpaceRef colorSpace;
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    mainViewContentContext = CGBitmapContextCreate (NULL, width, height , 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, width, height), maskRef);
    
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    UIImage *theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext scale: (FESkinIsRetina() ? 2 : 1) orientation:UIImageOrientationUp];
    CGImageRelease(mainViewContentBitmapContext);
    return theImage;
}

+(UIImage *)maskImage:(UIImage *)image withMask:(UIImage*)maskImage backColor:(UIColor *)color
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSInteger width = CGImageGetWidth(image.CGImage);
    NSInteger height = CGImageGetHeight(image.CGImage);
    CGContextRef contextRef = CGBitmapContextCreate (NULL, width, height , 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    if (contextRef==NULL)
        return nil;
 	
    //	CGImageRef maskRef = maskImage.CGImage;
    //	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
    //                                        CGImageGetHeight(maskRef),
    //                                        CGImageGetBitsPerComponent(maskRef),
    //                                        CGImageGetBitsPerPixel(maskRef),
    //                                        CGImageGetBytesPerRow(maskRef),
    //                                        CGImageGetDataProvider(maskRef), NULL, false);
	
    CGContextClipToMask(contextRef, CGRectMake(0, 0, width, height), maskImage.CGImage);
	CGContextSetFillColorWithColor(contextRef, color.CGColor);
	CGContextFillRect(contextRef, CGRectMake(0, 0, width, height));
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
	
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    UIImage *theImage = [UIImage imageWithCGImage:imageRef scale: (FESkinIsRetina() ? 2 : 1) orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return theImage;
}


+ (UIImage *)imageFromText:(NSString*)text textFont:(UIFont*)textFont fontColor:(UIColor*)color  underLineFlag:(BOOL)flag
{
	UIImage *image = nil;
	if (textFont&&color)
	{
        CGFloat scale = FESkinIsRetina() ? 2.0 : 1.0;
        // set the font type and size
        UIFont *font = textFont;
        UIColor*fontColor = color==nil?[UIColor clearColor]:color;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, fontColor,NSForegroundColorAttributeName,nil];
        //CGSize size  = [text sizeWithFont:font];
        CGSize size  = [text sizeWithAttributes:attributes];

        
        // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
        if (UIGraphicsBeginImageContextWithOptions != NULL)
            UIGraphicsBeginImageContextWithOptions(size,NO,scale);
        else
            // iOS is < 4.0
            UIGraphicsBeginImageContext(size);
        
        // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
        //CGContextRef context = UIGraphicsGetCurrentContext();
        //CGContextSetShadowWithColor(context, CGSizeMake(0, kShadowOffset), kShadowOffset, fontColor.CGColor);
        
        // set text color
        [fontColor set];
        
        // draw in context, you can use also drawInRect:withFont:
        //[text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
        [text drawAtPoint:CGPointZero withAttributes:attributes];
        
        if (flag)
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextMoveToPoint(context, 0, size.height-2);
            CGContextAddLineToPoint(context, size.width, size.height-2);
            CGContextStrokePath(context);
        }
        // transfer image
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
	}
    return image;
}



+ (UIImage *)imageWithColor:(UIColor*) color rect:(CGRect)rect lineType:(FELineType)lineType lineOffset:(CGFloat)offset lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor
{
	if (CGRectIsEmpty(rect))
	{
		return nil;
	}
    CGFloat scale = FESkinIsRetina() ? 2.0 : 1.0;
	// check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(rect.size,NO,scale);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(rect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    
	CGContextSetFillColorWithColor(context,color.CGColor);
	CGContextFillRect(context,rect);
	if (lineColor&&lineWidth>0&&lineWidth<rect.size.height)
	{
		CGContextSetLineCap(context, kCGLineCapRound);
		CGContextSetLineWidth(context, lineWidth);
		CGContextSetStrokeColorWithColor(context,lineColor.CGColor);
		//CGContextSetShadowWithColor(context, CGSizeMake(0, kShadowOffset), kShadowOffset, lineColor.CGColor);
        
		switch (lineType)
		{
			case kLeftLine:
				CGContextMoveToPoint(context, rect.origin.x+0.5, rect.origin.y);
				CGContextAddLineToPoint(context, rect.origin.x+0.5, rect.origin.y+rect.size.height);
				break;
			case kRightLine:
				CGContextMoveToPoint(context, rect.origin.x+rect.size.width-0.5, rect.origin.y);
				CGContextAddLineToPoint(context, rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height);
				break;
			case kTopLine:
				CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+0.5);
				CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+0.5);
				break;
			case kBottomLine:
			{
				CGContextMoveToPoint(context, rect.origin.x+offset, rect.origin.y+rect.size.height-0.5);
				CGContextAddLineToPoint(context, rect.origin.x+rect.size.width-offset, rect.origin.y+rect.size.height-0.5);
			}
				break;
			case KRectLine:
			{
				CGRect rect1 = CGRectInset(rect, 0.5, 0.5);
				CGContextStrokeRect(context, rect1);
			}
			case KLeftAndRightLine:
				CGContextMoveToPoint(context, rect.origin.x+0.5, rect.origin.y);
				CGContextAddLineToPoint(context, rect.origin.x+0.5, rect.origin.y+rect.size.height);
				CGContextStrokePath(context);
				CGContextMoveToPoint(context, rect.origin.x+rect.size.width-0.5, rect.origin.y);
				CGContextAddLineToPoint(context, rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height);
				break;
			default:
				break;
		}
        
		CGContextStrokePath(context);
		
	}
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return image;
    
}

+ (UIImage *)imageWithColor:(UIColor*)backColor maskImage:(UIImage *)maskImage type:(NSInteger)type
{
	UIImage* image = nil;
	if (maskImage)
	{
		UIImage* back = [[self class]  imageWithBackground:backColor size:maskImage.size];
		image = [[self class]  maskImage:back withMask:maskImage normalMethod:YES];
	}
	return image;
}


+ (UIImage *)imageWithScale:(UIImage *)image scaleRect:(CGRect)rect
{
	
	if (CGSizeEqualToSize(image.size, rect.size))
	{
		return image;
	}
	
    NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
		rect = CGRectScale(rect, scale);
    }
    
    NSInteger width  = rect.size.width;
    NSInteger height = rect.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
	CGImageRef imageRef2 = CGBitmapContextCreateImage(context);
    UIImage   *imageRet  = [UIImage imageWithCGImage:imageRef2 scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef2);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	return imageRet;
}

+ (UIImage *)imageWithScaleType:(NSInteger)scale image:(UIImage*)image innerRect:(CGRect)innerRect destSize:(CGSize)size
{
	if (CGSizeEqualToSize(CGSizeZero, size)||image==nil)
	{
		return nil;
	}
	NSInteger width  = size.width;
    NSInteger height = size.height;
	
	CGFloat   retina  = FESkinIsRetina() ? 2.0 : 1.0;
	if (retina > 1.0)
	{
		width *=retina;
		height*=retina;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate (NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	
	switch (scale) {
		case SCALE_TYPE_TOPLEFT:
		{
			//[image drawAtPoint:CGPointMake(0, 0)];
			CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
		}
			break;
		case SCALE_TYPE_FILL:
		{
			CGContextDrawImage(context, CGRectMake(0, 0, width,height), image.CGImage);
		}
			break;
		case SCALE_TYPE_TILE:
		{
			if (CGRectIsEmpty(innerRect))
			{
				CGContextConcatCTM(context, CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, -height));
				CGContextDrawTiledImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
			}
		}
			break;
		case SCALE_TYPE_FILLWITHSCALE:
		{
			float x = width/image.size.width;
			float y = height/image.size.height;
			float maxScale = MAX(x, y);
			UIImage* newImage = [UIImage imageWithSource:image rect:CGRectMake(0, 0,image.size.width*x/maxScale, image.size.height*y/maxScale)];
			CGContextDrawImage(context, CGRectMake(0, 0, width,height), newImage.CGImage);
		}
			break;
		case SCALE_TYPE_CENTER:
		{
			CGPoint pt = CGPointMake((width-image.size.width)/2,(height-image.size.height)/2);
			CGContextDrawImage(context, CGRectMake(pt.x, pt.y, image.size.width, image.size.height), image.CGImage);
		}
			break;
		case SCALE_TYPE_NINE_SCALE:
		{
			if (CGRectIsEmpty(innerRect))
			{
				//容错
				CGContextDrawImage(context, CGRectMake(0, 0, width,height), image.CGImage);
			}
			else
			{
				CGRect sourceRect = CGRectMake(0, 0, image.size.width, image.size.height);
				CGFloat percent = 1.0/retina;
                UIImage* newImage =  [UIImage stretchImageH3V3:image sourceRect:sourceRect innerRect:innerRect size:CGSizeMake(width*percent,height*percent)];
				CGContextDrawImage(context, CGRectMake(0, 0, width,height), newImage.CGImage);
			}
		}
			break;
			
		default:
			//default is SCALE_TYPE_FILL
			CGContextDrawImage(context, CGRectMake(0, 0, width,height), image.CGImage);
			break;
	}
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage   *imageRet = [UIImage imageWithCGImage:imageRef scale:retina orientation:UIImageOrientationUp];
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
	return imageRet;
}


+ (UIImage* )image:(UIImage*)image blendWithColor:(UIColor*)color mode:(CGBlendMode)mode
{
	if (image==nil||color==nil)
	{
		return nil;
	}
	//UIColor* overlayColor = [UIColor blackColor];
	//CGBlendMode blendMode = kCGBlendModeMultiply;
	CGFloat width  = image.size.width;
	CGFloat height = image.size.height;
	NSInteger scale = FESkinIsRetina() ? 2 : 1;
    if (scale > 1)
    {
		width  = width*scale;
		height = height*scale;
    }
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGContextRef contextRef =  CGBitmapContextCreate(NULL, width, height, 8, width*4, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	
	CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
	CGContextClipToMask(contextRef,  CGRectMake(0, 0, width, height), image.CGImage);
	CGContextSetBlendMode(contextRef, mode);
	CGContextSetFillColorWithColor(contextRef, color.CGColor);
	//CGContextSetAlpha(contextRef, 0.5);
	CGContextFillRect(contextRef,  CGRectMake(0, 0, width, height));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
	UIImage* imageRet = [UIImage imageWithCGImage:imageRef  scale:scale orientation:UIImageOrientationUp];
	CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(contextRef);
	return imageRet;
}

+ (NSArray*)getRGBAsFromImage:(UIImage*)image startPoint:(CGPoint) point  count:(int)count
{
	//http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
	NSInteger yy = point.y;
	NSInteger xx = point.x;
	
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width  = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
	if (xx > width || yy > height || (yy * width + xx) > count)
	{
		NSLog(@"getRGBAsFromImage Error");
		return nil;
	}
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
		//NSLog(@">>>r = %d g=%d b=%d a=%d",rawData[byteIndex],rawData[byteIndex+1],rawData[byteIndex+2],rawData[byteIndex+3]);
        
		byteIndex += 4;
		
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
	
	free(rawData);
	return result;
}

+(void)imageDebugOutput:(UIImage*)image
{
#if TARGET_IPHONE_SIMULATOR		
	NSString* filePath =  [NSString stringWithFormat:@"%@/%f.png",[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"],[[NSDate date] timeIntervalSince1970]];
	NSData* imageData = UIImagePNGRepresentation(image);
	[imageData writeToFile:filePath atomically:YES];
#endif
}

@end
