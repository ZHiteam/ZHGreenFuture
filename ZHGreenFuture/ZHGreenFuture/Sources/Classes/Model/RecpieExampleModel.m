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
    
    model.content       = VALIDATE_VALUE(dic[@"title"]);
    model.url           = VALIDATE_VALUE([dic[@"imageURL"] greenFutureURLStr]);
    model.creataDate    = VALIDATE_VALUE(dic[@"createDate"]);
    model.nickName      = VALIDATE_VALUE(dic[@"userNickName"]);
    model.workId        = VALIDATE_VALUE(dic[@"workId"]);

    
    return model;
}
@end