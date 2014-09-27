//
//  FEUtil.m
//  FETestCategory
//
//  Created by xxx on 13-9-30.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "FEUtil.h"
#import "FEMacroDefine.h"
#import "FEZip.h"

#define kBufferSize 4096


@implementation FEUtil
+ (CGFloat)randomFloatFrom:(CGFloat)fromFloat to:(CGFloat)toFloat {
    if (fromFloat > toFloat) {
        CGFloat tempFloat = fromFloat;
        fromFloat = toFloat;
        toFloat = tempFloat;
    }
    CGFloat difference = toFloat - fromFloat;
    return ((double)arc4random() / 0x1000000000) * difference + fromFloat;
}

+ (UIEdgeInsets)edgeInsetsFromString:(NSString*)string{
    if (string && [string isKindOfClass:[NSString class]]) {
        NSArray* value = [string componentsSeparatedByString:@","];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake([FEObjectAtIndex(value, 0) floatValue], [FEObjectAtIndex(value, 1) floatValue], [FEObjectAtIndex(value, 2) floatValue], [FEObjectAtIndex(value, 3) floatValue]);
        return edgeInsets;
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Unzip
+ (BOOL)unzipFilePath:(NSString *)zipFilePath toPath:(NSString *)path{
    if (zipFilePath==nil || path ==nil){
		return NO;
	}
	
	FE_UnzFile unzSkinFile = FEUnzOpen((const char*)[zipFilePath UTF8String]);
	if(!unzSkinFile){
        return NO;
	}
    
	int ret = FEUnzGoToFirstFile(unzSkinFile);
	if(kUnzOK != ret){
        return NO;
	}
    
    unsigned char  buffer[kBufferSize] = {0};
    NSFileManager* defautFileManager   = [NSFileManager   defaultManager];
	do {
        ret = FEUnzOpenCurrentFile(unzSkinFile);
		if(kUnzOK != ret){
			break;
		}
        
		FE_UnzFileInfo fileInfo = {0};
		ret = FEUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if(kUnzOK != ret){
			FEUnzCloseCurrentFile(unzSkinFile);
			break;
		}
        
		char* filename = (char*)malloc(fileInfo.size_filename +1);
		FEUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
        NSString* filePath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
        if(NSNotFound != [filePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\\"]].location){
			filePath = [filePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
        
        BOOL isDirectory = [[filePath substringFromIndex:filePath.length - 1] isEqualToString:@"/"];
        filePath = [path stringByAppendingPathComponent:filePath];
        free(filename);
        
        
        if ([defautFileManager fileExistsAtPath:filePath isDirectory:nil]){ //Always overwrite the file
            [defautFileManager removeItemAtPath:filePath error:nil];
        }
        
        if (isDirectory){
            [defautFileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else{
            [defautFileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            
            FILE* fp = fopen((const char*)[filePath UTF8String], "wb");
            while(fp){
                int read = FEUnzReadCurrentFile(unzSkinFile, buffer, kBufferSize);
                if(read > 0){
                    fwrite(buffer, read, 1, fp);
                }
                else{
                    break;
                }
            }
            
            if(fp){
                fclose(fp);
                
                NSCalendar*       gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents* dateComponents    = [[NSDateComponents alloc] init];
                dateComponents.second = fileInfo.tmu_date.tm_sec;
                dateComponents.minute = fileInfo.tmu_date.tm_min;
                dateComponents.hour   = fileInfo.tmu_date.tm_hour;
                dateComponents.day    = fileInfo.tmu_date.tm_mday;
                dateComponents.month  = fileInfo.tmu_date.tm_mon + 1;
                dateComponents.year   = fileInfo.tmu_date.tm_year;
                NSDate* modificationDate = [gregorianCalendar dateFromComponents:dateComponents];
                //                [dateComponents    release];
                //                [gregorianCalendar release];
                
                NSDictionary* attributes = [NSDictionary dictionaryWithObject:modificationDate forKey:NSFileModificationDate];
                [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:filePath error:nil];
            }
        }
        
		FEUnzCloseCurrentFile(unzSkinFile);
		ret = FEUnzGoToNextFile(unzSkinFile);
	} while(ret == kUnzOK && ret != kUnzEndOfListOfFile);
    return kUnzOK == FEUnzClose(unzSkinFile) && kUnzEndOfListOfFile == ret;
}


@end
