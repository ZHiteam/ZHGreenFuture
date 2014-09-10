//
//  RecipeModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"
#import "TagModel.h"
#import "RecipeItemModel.h"

@interface RecipeModel : BaseModel

@property (nonatomic,strong) NSArray*       tags;
@property (nonatomic,strong) NSArray*       recipeItemList;

@end
