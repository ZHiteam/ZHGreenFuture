//
//  BaseModel.m
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forKey:(NSString *)key{
    
    NSString* keySet = [NSString stringWithFormat:@"set%@",[key capitalizedString]];
    if (![self respondsToSelector:NSSelectorFromString(keySet)] ) {
        return;
    }
    
    return [super setValue:value forKeyPath:key];
}

@end
