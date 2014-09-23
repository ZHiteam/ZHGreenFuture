//
//  RecipeModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeModel.h"

@implementation RecipeModel

+(id)praserModelWithInfo:(id)info{
    RecipeModel* model = [[RecipeModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    id val = info[@"tagList"];
    if ([val isKindOfClass:[NSArray class]]){
        NSMutableArray* tagList = [[NSMutableArray alloc]initWithCapacity:((NSArray*)val).count];
        for (id dic in val) {
            TagModel* tag = (TagModel*)[TagModel praserModelWithInfo:dic];
            [tagList addObject:tag];
        }
        model.tags = [tagList mutableCopy];
    }
    
    val = info[@"recipeList"];
    if ([val isKindOfClass:[NSArray class]]){
        NSMutableArray* recipeList = [[NSMutableArray alloc]initWithCapacity:((NSArray*)val).count];
        for (id dic in val) {
            RecipeItemModel* tag = (RecipeItemModel*)[RecipeItemModel praserModelWithInfo:dic];
            [recipeList addObject:tag];
        }
        model.recipeItemList = [recipeList mutableCopy];
    }
    
    return model;
}
@end
