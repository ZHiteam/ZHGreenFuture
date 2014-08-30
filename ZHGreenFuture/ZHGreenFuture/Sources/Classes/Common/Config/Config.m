//
//  Config.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "Config.h"
#import "NSDictionary+ZHitem.h"
#import "NSData+AESEncryption.h"

#define SYSTEM_PATHAT(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:nil]

@interface Config(){
    NSMutableDictionary*    _sysConfigs;
    NSMutableDictionary*    _userConfigs;
}

-(void)loadConfigs;

@end

@implementation Config

+(Config *)config{
    return [Config instanceWithCLass:[Config class]];
}

-(id)init{
    if ((self = [super init])) {        
        [self loadConfigs];
    }
    return self;
}

-(void)loadConfigs{
    BOOL needFlash = NO;
    NSString* curVersion = [[NSUserDefaults standardUserDefaults]valueForKey:VERSION_KEY];
    if(![curVersion isEqualToString:VERSION]){
        needFlash = YES;
        [[NSUserDefaults standardUserDefaults]setValue:VERSION forKey:VERSION_KEY];
    }
    
    NSString* rootPath = [Config rootPath];
    
    NSString* sysConfigPath = [NSString stringWithFormat:@"%@%@", rootPath,SYS_CONFIG_PATH];
    NSString* userConfigPath = [NSString stringWithFormat:@"%@%@",rootPath,USER_CONFIG_PATH];
    NSString* sslCert = [NSString stringWithFormat:@"%@%@",rootPath,SSL_CERT];
    
//    [self loadLangConfig:needFlash];
    
    /// 系统文件
    [self copyAtPath:SYSTEM_PATHAT(SYS_CONFIG_PATH) toDest:sysConfigPath refresh:needFlash];

    /// 用户文件
    [self copyAtPath:SYSTEM_PATHAT(USER_CONFIG_PATH) toDest:userConfigPath refresh:needFlash];
    
    /// ssl证书
    [self copyAtPath:SYSTEM_PATHAT(SSL_CERT) toDest:sslCert refresh:needFlash];
    
//    /// 语言文件
//    [self copyAtPath:SYSTEM_PATHAT(langPath) toDest:langFile refresh:needFlash];
    
    NSData* encryptData = [NSData dataWithContentsOfFile:sysConfigPath];
    NSData* decryptData = [encryptData AES256DecryptWithKey:DATA_SEC_KEY];
    _sysConfigs = [[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryWithContentsOfData:decryptData]];
    
    encryptData = [NSData dataWithContentsOfFile:userConfigPath];
    decryptData = [encryptData AES256DecryptWithKey:DATA_SEC_KEY];
    _userConfigs = [[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryWithContentsOfData:decryptData]];
}

-(void)copyAtPath:(NSString*)source toDest:(NSString*)dest refresh:(BOOL)refresh{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSError* error;
    
    if (![manager fileExistsAtPath:source]) {
        return;
    }
    
    if (![manager fileExistsAtPath:dest]) {
        [manager copyItemAtPath:source toPath:dest error:&error];
    }
    else if(refresh){
        if ([manager fileExistsAtPath:dest]) {
            [manager removeItemAtPath:dest error:&error];
        }
        
        [manager copyItemAtPath:source toPath:dest error:&error];
    }
}


-(id)configForKey:(NSString *)key{
    id value = nil;
    /// 优先读取用户配置
    if (_userConfigs) {
        value = [_userConfigs objectForKey:key];
    }
    if (!value) {
        value = [_sysConfigs objectForKey:key];
    }
    return value;
}

-(void)setConfig:(id)value forKey:(NSString*)key{
    if (!value || isEmptyString(key)) {
        return;
    }
    if (!_userConfigs) {
        _userConfigs = [[NSMutableDictionary alloc]initWithCapacity:1];
    }
    [_userConfigs setValue:value forKey:key];
    
    [self _saveUserConfigs];
}

-(void)_saveUserConfigs{
    
    if (!_userConfigs) {
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@%@",[Config rootPath],USER_CONFIG_PATH];
    
    NSData* data = [_userConfigs toData];
    data = [data AES256EncryptWithKey:DATA_SEC_KEY];
    [data writeToFile:path atomically:YES];
}

+(NSString *)rootPath{
    NSString* rootpath = [MemoryStorage valueForKey:k_ROOT_PATH];
    
    if (isEmptyString(rootpath)) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                           , NSUserDomainMask
                                                           , YES);
        
        NSString* path = [paths objectAtIndex:0];
        
        rootpath = [path hasSuffix:@"/"]?[NSString stringWithFormat:@"%@%@",path,ROOT_FLODER]:[NSString stringWithFormat:@"%@/%@",path,ROOT_FLODER];
        
        NSError* error;
        if (![[NSFileManager defaultManager]fileExistsAtPath:rootpath]) {
            [[NSFileManager defaultManager]createDirectoryAtPath:rootpath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        if (!error && !isEmptyString(rootpath)) {
            
            if (![rootpath hasSuffix:@"/"]) {
                rootpath = [rootpath stringByAppendingString:@"/"];
            }
            
            [MemoryStorage setValue:rootpath forKey:k_ROOT_PATH];
        }
    }
    
    return rootpath;
}

//-(NSString*)loadLangConfig:(BOOL)needFresh{
//    NSString* rootPath = [Config rootPath];
//    
//    NSString* langFile = nil;
//    NSString* destPath = @"";
//    NSString* bundlePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingString:@"/lang"];
//    NSString* langPath = @"";
//    
//    NSFileManager* manager = [NSFileManager defaultManager];
//
//    NSDirectoryEnumerator* dirEnum = nil;
//    
//    
//    NSString* path = [rootPath stringByAppendingString:@"lang"];
//    
//    if (needFresh) {
//        dirEnum = [manager enumeratorAtPath:path];
//        
//        while ((langFile = [dirEnum nextObject]) != nil) {
//            langFile = [path stringByAppendingFormat:@"/%@",langFile];
//            [manager removeItemAtPath:langFile error:nil];
//        }
//    }
//    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    
//    dirEnum = [manager enumeratorAtPath:bundlePath];
//    ////
//    while ((langPath = [dirEnum nextObject]) != nil)
//    {
//        langFile = [bundlePath stringByAppendingFormat:@"/%@",langPath];
//        
//        destPath = [NSString stringWithFormat:@"%@lang/%@",rootPath,langPath];
//        
//        [self copyAtPath:langFile toDest:destPath refresh:needFresh];
//        
////        NSLog(@"%@\n%@",langFile,destPath);
//    }
//    
//    return langFile;
//}

@end
