//
//  NSFileManager+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-10-8.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FEExtension)
/**
	返回resourcePath 路径
	@returns 返回resourcePath 路径
 */
+ (NSString*)resourcePath;

/**
	Documents 目录路径
	@returns 返回Documents路径
 */
+ (NSString*)documentsPath;

/**
	tmp 目录路径
	@returns 返回tmp路径
 */
+ (NSString*)tmpPath;

/**
	判断filePath文件是否存在
	@param filePath 文件路径
	@returns 是否存在
 */
+ (BOOL)isFilePathExist:(NSString *)filePath;

/**
	判断filePath是否是目录
	@param filePath 文件目录
	@returns 是否是目录
 */
+ (BOOL)isDirectory:(NSString *)filePath;

/**
	对path 做唯一化操作，添加计数
	@param path 待处理的路径
	@returns 处理后的路径
 */
+ (NSString *)uniquePathWithNumber:(NSString *)path;

/**
	确保目录存在，若不存在则创建
	@param path 目录路径
	@returns 处理后，若存在返回YES，非目录，返回NO
 */
+ (BOOL)ensureDirectoryExists:(NSString *)directory;

/**
	文件大小
	@param filePath 文件路径
	@param error 错误信息
	@returns 文件大小
 */
+ (NSNumber *)fileSize:(NSString *)filePath error:(NSError **)error;
@end

