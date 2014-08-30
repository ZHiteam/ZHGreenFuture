//
//  Config.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Instance.h"

@interface Config : NSObject

+(Config*)config;

-(id)configForKey:(NSString *)key;

-(void)setConfig:(id)value forKey:(NSString*)key;

+(NSString*)rootPath;
@end
