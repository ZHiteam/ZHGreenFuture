//
//  RecpieExampleModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecpieExampleModel.h"

@implementation RecpieExampleModel

@end


@implementation RecipeExampleImageContent

+(id)praserModelWithInfo:(id)info{
    RecipeExampleImageContent* model = [[RecipeExampleImageContent alloc]init];
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.content = dic[@"title"];
    model.url = [dic[@"imageURL"] greenFutureURLStr];
    model.creataDate = dic[@"createDate"];
    model.nickName = dic[@"userNickName"];
    
    return model;
}
@end