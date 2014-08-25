//
//  FELocalStorageUtil.h
//  FETestCategory
//
//  Created by xxx on 13-9-27.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FELocalStorageUtil : NSObject
- (void)writeMutableArray:(NSMutableArray*)array withKey:(NSString*)key;
- (NSMutableArray*)readMutableArrayForKey:(NSString*)key;
@end
