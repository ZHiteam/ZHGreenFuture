//
//  BaseModel.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VALIDATE_VALUE(val) [BaseModel validateStringValue:val];

@interface BaseModel : NSObject

@property (nonatomic,strong) NSString* state;

+(id)praserModelWithInfo:(id)info;

+(NSString*)validateStringValue:(id)val;
@end
