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
    model.state = [NSString stringWithFormat:@"%d", [dic[@"result"]boolValue]] ;
    
    return model;
}
@end
