//
//  FELocalStorageUtil.m
//  FETestCategory
//
//  Created by xxx on 13-9-27.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "FELocalStorageUtil.h"

@implementation FELocalStorageUtil
- (void)writeMutableArray:(NSMutableArray*)array withKey:(NSString*)key{
    if ([key length]>0) {
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:key];
        [userDefault synchronize];
    }
}

- (NSMutableArray*)readMutableArrayForKey:(NSString*)key{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefault objectForKey:key];
    NSMutableArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}
@end
