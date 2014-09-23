//
//  CatagoryModel.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "CatagoryModel.h"

@implementation CatagoryModel

+(id)praserModelWithInfo:(id)info{
    CatagoryModel* model = [[CatagoryModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    NSDictionary* dic = (NSDictionary*)info;
    
    model.title                 = dic[@"title"];
    model.subtitle              = dic[@"title"];
    model.backgourndImageUrl    = dic[@"iconURL"];
    model.categoryId            = dic[@"categoryId"];
    
    id val = dic[@"shortTitles"];
    if ([val isKindOfClass:[NSArray class]]){
        NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:((NSArray*)val).count];
        for (id value in val){
            SecondCatagoryModel* scModel = (SecondCatagoryModel*)[SecondCatagoryModel praserModelWithInfo:value];
            [array addObject:scModel];
        }
        
        model.productList = array;
    }
    
    return model;
}

@end
