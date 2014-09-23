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
    
    model.backgroundImageUrl        = dic[@"imageURL"];
    model.title                     = dic[@"title"];
    model.subTitle                  = dic[@"subTitle"];
    model.done                      = [NSString stringWithFormat:@"%d",[dic[@"done"]intValue]];
    model.comment                   = [NSString stringWithFormat:@"%d",[dic[@"comment"]intValue]];
    model.recipeId                  = [NSString stringWithFormat:@"%d" ,[dic[@"recipeId"]intValue]];
    
    return model;
}
@end
