//
//  RecipeItemModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeItemModel.h"

@implementation RecipeItemModel
+(id)praserModelWithInfo:(id)info{
    RecipeItemModel* model = [[RecipeItemModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    NSDictionary* dic = (NSDictionary*)info;
    
    model.backgroundImageUrl        = VALIDATE_VALUE(dic[@"imageURL"]);
    model.title                     = VALIDATE_VALUE(dic[@"title"]);
    model.subTitle                  = VALIDATE_VALUE(dic[@"subTitle"]);
    model.done                      = VALIDATE_VALUE(dic[@"done"]);
    model.comment                   = VALIDATE_VALUE(dic[@"comment"]);
    model.recipeId                  = VALIDATE_VALUE(dic[@"recipeId"]);
    
    return model;
}
@end
