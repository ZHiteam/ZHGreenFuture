//
//  BaseModel.m
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+(id)praserModelWithInfo:(id)info{
    BaseModel* model = [[BaseModel alloc]init];
    if (! [info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    model.state = VALIDATE_VALUE(dic[@"result"]);

    return model;
}

+(NSString *)validateStringValue:(id)val{
    if ([val isKindOfClass:[NSNull class]]){
        return @"";
    }
    
    if ([val isKindOfClass:[NSString class]]){
        return val;
    }
    
    if ([val isKindOfClass:[NSNumber class]]){
        return [val descriptionWithLocale:nil];
    }
    
    return @"";
}
@end
