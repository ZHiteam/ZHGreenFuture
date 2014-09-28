//
//  NSDictionary+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-9-17.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "NSDictionary+FEExtension.h"

@implementation NSDictionary (FEExtension)
- (BOOL)boolForKey:(NSString *)keyName
{
    return [[self objectForKey:keyName] boolValue];
}

- (NSInteger)integerForKey:(NSString *)keyName
{
    return [[self objectForKey:keyName] intValue];
}

- (float)floatForKey:(NSString *)keyName
{
    return  [[self objectForKey:keyName] floatValue];
}

- (CGSize)sizeForKey:(NSString *)keyName
{
    CGSize    ret       = CGSizeZero;
    NSString *stringVal = [self objectForKey:keyName];
    NSArray  *componets = [stringVal componentsSeparatedByString:@","];
    if ([componets count] == 2){
        ret = CGSizeMake([[componets objectAtIndex:0] intValue], [[componets objectAtIndex:1] intValue]);
    }
    return ret;
}

- (CGRect)rectForKey:(NSString *)keyName
{
    CGRect    ret       = CGRectZero;
    NSString *stringVal = [self  objectForKey:keyName];
    NSArray  *componets = [stringVal componentsSeparatedByString:@","];
    if ([componets count] == 4){
        ret = CGRectMake([[componets objectAtIndex:0] intValue], [[componets objectAtIndex:1] intValue],
                         [[componets objectAtIndex:2] intValue], [[componets objectAtIndex:3] intValue]);
    }

    return ret;
}


- (CGRect)rectForKeyTheme:(NSString *)keyName
{
    CGRect    ret       = CGRectZero;
    NSString *stringVal = [self  objectForKey:keyName];
    NSArray  *componets = [stringVal componentsSeparatedByString:@","];
    if ([componets count] == 4){
        ret = CGRectMake([[componets objectAtIndex:0] intValue], [[componets objectAtIndex:1] intValue],
						 [[componets objectAtIndex:2] intValue], [[componets objectAtIndex:3] intValue]);
    }
    return ret;
}

- (CGPoint)pointForKey:(NSString *)keyName
{
    CGPoint   ret       = CGPointZero;
    NSString *stringVal = [self  objectForKey:keyName];
    NSArray  *componets = [stringVal componentsSeparatedByString:@","];
    if ([componets count] == 2){
        ret = CGPointMake([[componets objectAtIndex:0] intValue], [[componets objectAtIndex:1] intValue]);
    }
    return ret;
}

- (NSString *)stringForKey:(NSString *)keyName
{
    NSString *ret = [self objectForKey:keyName];
    return ret ? ret : [NSString string];
}

- (NSDictionary *)dictionaryForKey:(NSString *)keyName
{
    return [self objectForKey:keyName];
}

-(void)setBool:(BOOL)value forKey:(NSString*)keyName
{
    [self setValue:[NSNumber numberWithBool:value] forKey:keyName];
}

-(void)setInteger:(NSInteger)value forKey:(NSString*)keyName
{
    [self setValue:[NSNumber numberWithInt:value] forKey:keyName];
}


+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *parameters = [query componentsSeparatedByString:@"&"];
	for(NSString *parameter in parameters) {
		NSArray *contents = [parameter componentsSeparatedByString:@"="];
		if([contents count] == 2) {
			NSString *key = [contents objectAtIndex:0];
			NSString *value = [contents objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if (key && value) {
				[dict setObject:value forKey:key];
            }
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)URLQuery
{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
        CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[self objectForKey:key] description],
                                                                      NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8);
        [string appendFormat:@"%@=%@", key, escaped];
        CFRelease(escaped);
    }
    return string;
}
@end
