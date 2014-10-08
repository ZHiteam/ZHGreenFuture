//
//  MaterialModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "MaterialModel.h"

@implementation MaterialModel

+(id)praserModelWithInfo:(id)info{
    MaterialModel* model = [[MaterialModel alloc]init];
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.title     = VALIDATE_VALUE(dic[@"title"]);
    model.weight    = VALIDATE_VALUE(dic[@"weight"]);
    
    return model;
}

@end
