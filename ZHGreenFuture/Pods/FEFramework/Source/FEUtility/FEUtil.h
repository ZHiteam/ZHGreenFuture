//
//  FEUtil.h
//  FETestCategory
//
//  Created by xxx on 13-9-30.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEUtil : NSObject
/**
	产生随机数，支持正负，（终止-起始）幅度不能超过0x1000000000
	@param fromFloat 起始范围
	@param toFloat 终止范围
	@returns 随机数
 */
+ (CGFloat)randomFloatFrom:(CGFloat)fromFloat to:(CGFloat)toFloat;

/**
 *  将NSString 转为 UIEdgeInsets
 *
 *  @param string 字符串
 *
 *  @return UIEdgeInsets
 */
+ (UIEdgeInsets)edgeInsetsFromString:(NSString*)string;


#pragma mark - Unzip
/**
 *  解压zip文件到指定目录
 *
 *  @param zipFilePath zip压缩文件所在路径
 *  @param path        解压后文件位置
 *
 *  @return 是否成功
 */
+ (BOOL)unzipFilePath:(NSString *)zipFilePath toPath:(NSString *)path;

@end
