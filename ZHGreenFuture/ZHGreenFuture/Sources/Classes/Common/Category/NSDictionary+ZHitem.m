//
//  NSDictionary+HKWF.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "NSDictionary+ZHitem.h"

@implementation NSDictionary (ZHitem)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data
{
	// uses toll-free bridging for data into CFDataRef and CFPropertyList into NSDictionary
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data,
															   kCFPropertyListImmutable,
															   NULL);
	// we check if it is the correct type and only return it if it is
	if ([(__bridge id)plist isKindOfClass:[NSDictionary class]])
	{
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:(__bridge NSDictionary *)plist];
        
        CFRelease(plist);
        
		return dict;
	}
	else
	{
		// clean up ref
        if (plist) {
            CFRelease(plist);
            return nil;
        }
	}
    
    return nil;
}

-(id)objectForIndexKey:(NSInteger)index{
    return [self objectForKey:[NSString stringWithFormat:@"%d",index]];
}

-(NSData*)toData{
    CFDataRef dataRef = CFPropertyListCreateXMLData(kCFAllocatorDefault, (__bridge CFPropertyListRef)(self));
    
    NSData* data = [[NSData alloc]initWithData:(__bridge NSData *)(dataRef)];
    
    CFRelease(dataRef);
    
    return data;
}
@end

@implementation NSMutableDictionary(ZHitem)

-(void)setObject:(id)object forIndexKey:(NSInteger)index{
    if (!object) {
        return;
    }
    NSString* strIndex = [[NSString alloc]initWithFormat:@"%d",index];
    
    [self setObject:object forKey:strIndex];
}

-(void)removeObjectForIndexKey:(NSInteger)indexKey{
    [self removeObjectForKey:[NSString stringWithFormat:@"%d",indexKey]];
}

@end