//
//  SecondCatagoryModel.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "SecondCatagoryModel.h"

@implementation SecondCatagoryModel

+(BaseModel *)praserModelWithInfo:(id)info{
    SecondCatagoryModel* model = [[SecondCatagoryModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    model.title = dic[@"name"];
    if (isEmptyString(model.title)){
        model.title = dic[@"title"];
    }
    
    model.categoryId = dic[@"categoryId"];
    model.descript = dic[@"description"];
    if (isEmptyString(model.descript)){
        model.descript = dic[@"subTitle"];
    }
    
    model.imageUrl = dic[@"backgourndImageUrl"];
    
    model.lastPage = [dic[@"lastPage"] boolValue];
    
    if ([dic[@"productList"] isKindOfClass:[NSArray class]]){
        NSArray* infoArray = (NSArray*)dic[@"productList"];
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:infoArray.count];
        
        for (id val in infoArray){
            if ([val isKindOfClass:[NSDictionary class]]){
                ZHProductItem* item = (ZHProductItem*)[ZHProductItem praserModelWithInfo:val];
                if (item){
                    [array addObject:item];
                }
            }
        }
        
        model.productList = [array mutableCopy];
    }
    
    return model;
}

@end
