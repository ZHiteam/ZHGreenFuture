//
//  NSData+AESEncryption.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESEncryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)aesBase64encode:(NSString*)str;           //同上64编码

@end
