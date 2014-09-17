//
//  RecipeItemModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface RecipeItemModel : BaseModel

@property (nonatomic,strong) NSString*      backgroundImageUrl;
@property (nonatomic,strong) NSString*      title;
@property (nonatomic,strong) NSString*      subTitle;
@property (nonatomic,strong) NSString*      done;
@property (nonatomic,strong) NSString*      comment;
@property (nonatomic,strong) NSString*      recipeId;

@end
