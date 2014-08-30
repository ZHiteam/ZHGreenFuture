//
//  LocalSotrage.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-17.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "LocalSotrage.h"
#import "NSData+AESEncryption.h"

@implementation LocalSotrage

+(void)writeData:(NSData *)data fileName:(NSString *)fileName{
    NSString* path = [NSString stringWithFormat:@"%@%@",[Config rootPath],fileName];
    
    NSError* error;
    [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
    
    if (data){
        NSData* encryptData = [data AES256EncryptWithKey:DATA_SEC_KEY];
        if (encryptData) {
            [encryptData writeToFile:path atomically:YES];
        }
    }

    
//    WFATCLOG(@"decrypt:\n%@", [LocalSotrage dataWithFileName:fileName]);
}

+(NSData *)dataWithFileName:(NSString *)fileName{
    NSString* path = [NSString stringWithFormat:@"%@%@",[Config rootPath],fileName];
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSData* decrypt = [data AES256DecryptWithKey:DATA_SEC_KEY];
        if (decrypt) {
            return decrypt;
        }
    }
    
    return nil;
}

+(BOOL)existFile:(NSString*)fileName{
    NSString* path = [NSString stringWithFormat:@"%@%@",[Config rootPath],fileName];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+(void)removeWithFileName:(NSString *)fileName{
    NSString* path = [NSString stringWithFormat:@"%@%@",[Config rootPath],fileName];
    NSError* error;
    [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
}
@end
