//
//  NSDictionary+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-9-17.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FEExtension)
- (BOOL)boolForKey:(NSString *)keyName;
- (float)floatForKey:(NSString *)keyName;     
- (CGSize)sizeForKey:(NSString *)keyName;        
- (CGRect)rectForKey:(NSString *)keyName;        
- (CGRect)rectForKeyTheme:(NSString *)keyName;   
- (CGPoint)pointForKey:(NSString *)keyName;      
- (NSInteger)integerForKey:(NSString *)keyName;
- (NSString *)stringForKey:(NSString *)keyName;
- (NSDictionary *)dictionaryForKey:(NSString *)keyName;
-(void)setBool:(BOOL)value forKey:(NSString*)keyName;
-(void)setInteger:(NSInteger)value forKey:(NSString*)keyName;

+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query;
- (NSString *)URLQuery;
@end
