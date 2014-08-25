//
//  NSString+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FEExtension)
#pragma mark - URL Encode & Decode
/**
	返回url 编码后的字符串
	@returns 返回url 编码后的字符串
 */
- (NSString *)URLEncodedString;

/**
	返回对url编码的解码
	@returns 返回对url编码的解码字符串
 */
- (NSString *)URLDecodedString;

#pragma mark - HTMLEntities
/**
	解析html格式字符串
	@returns 解析后的字符串
 */
- (NSString *)decodingHTMLEntities;
#pragma mark - CommonDigest
/**
	md5 数字签名
	@returns 签名后的字符串
 */
- (NSString *)md5;

/**
	sha1 数字签名
	@returns 签名后的字符串
 */
- (NSString *)SHA1;

#pragma mark －　Other
/**
	是否是空串
	@returns 
 */
- (BOOL)isBlank;

/**
	过滤头尾的空格
	@returns 过滤后的字符串    
 */
- (NSString*)trimWhiteSpaceAtBeginAndEnd;

/**
	过滤头尾的空格和回车
	@returns 过滤后的字符串
 */
- (NSString*)trimWhiteSpaceAndNewlineAtBeginAndEnd;

#pragma mark - 是否是邮箱
/**
	判断字符串是否是合法的email地址
	@returns 合法email地址返回YES，否则返回NO
 */
- (BOOL) validateEmail: (NSString *) candidate;

@end
