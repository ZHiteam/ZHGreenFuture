//
//  NSFileManager+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-10-8.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "NSFileManager+FEExtension.h"

@implementation NSFileManager (FEExtension)
+ (NSString *)resourcePath{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString*)documentsPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
}

+ (NSString*)tmpPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
}

+ (BOOL)isFilePathExist:(NSString *)filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)isDirectory:(NSString *)filePath{
    BOOL isDir;
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && isDir);
}

+ (NSString *)uniquePathWithNumber:(NSString *)path{
   static  NSInteger index = 1;
    NSString *uniquePath = path;
    NSString *prefixPath = nil, *pathExtension = nil;
    
    while([self isFilePathExist:uniquePath]) {
        if (!prefixPath) prefixPath = [path stringByDeletingPathExtension];
        if (!pathExtension) pathExtension = [path pathExtension];
        uniquePath = [NSString stringWithFormat:@"%@-%d%@", prefixPath, index, pathExtension];
        index++;
    }
    return uniquePath;
}

+ (BOOL)ensureDirectoryExists:(NSString *)directory{
    if (![self isFilePathExist:directory]) {
		BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
		return success;
	} else if (![self isDirectory:directory]) {
		NSLog(@">>>Path exists but is not a directory");
		return NO;
	} else {
		// Path existed and was a directory
		return YES;
	}

}

+ (NSNumber *)fileSize:(NSString *)filePath error:(NSError **)error{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:error];
        if (fileAttributes)
            return [fileAttributes objectForKey:NSFileSize];
    }
    return nil;
}

@end
