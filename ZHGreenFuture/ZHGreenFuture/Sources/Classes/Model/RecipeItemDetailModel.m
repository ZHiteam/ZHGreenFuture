//
//  RecipeItemDetailModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/13/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeItemDetailModel.h"

@implementation RecipeItemDetailModel
+(id)praserModelWithInfo:(id)info{
    
    RecipeItemDetailModel* model = [[RecipeItemDetailModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.backgroundImage       = dic[@"backgoundImageUrl"];
    model.recipeName            = dic[@"recipeName"];
    model.author                = dic[@"author"];
    model.health                = dic[@"health"];
    model.tips                  = dic[@"tips"];
    model.commentCount          = [NSString stringWithFormat:@"%d",[dic[@"commentCount"]intValue]];
    model.done                  = [NSString stringWithFormat:@"%d",[dic[@"done"]intValue]];
    
    
    if ([dic[@"material"] isKindOfClass:[NSArray class]]){
        NSArray* array = (NSArray*)dic[@"material"];
        NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
        
        for (id val in array){
            MaterialModel* item  =[MaterialModel praserModelWithInfo:val];
            if (item){
                [muData addObject:item];
            }
        }
        
        model.material = [muData mutableCopy];
    }
    
    /// 服务端对调了
    if ([dic[@"example"] isKindOfClass:[NSArray class]]){
        NSArray* array = (NSArray*)dic[@"example"];
        NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
        
        for (id val in array){
            MadeStepModel* item  =[MadeStepModel praserModelWithInfo:val];
            if (item){
                [muData addObject:item];
            }
        }
        
        model.practice = [muData mutableCopy];
    }
    
    if ([dic[@"practice"] isKindOfClass:[NSArray class]]){
        NSArray* array = (NSArray*)dic[@"practice"];
        NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
        
        for (id val in array){
            RecipeExampleImageContent* item  =[RecipeExampleImageContent praserModelWithInfo:val];
            if (item){
                [muData addObject:item];
            }
        }
        model.example = [[RecpieExampleModel alloc]init];
        model.example.images = [muData mutableCopy];
        model.example.count = [NSString stringWithFormat:@"%d", [dic[@"practiceCount"]intValue]];
    }
    
    if ([dic[@"commentList"] isKindOfClass:[NSArray class]]){
        NSArray* array = (NSArray*)dic[@"commentList"];
        NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
        
        for (id val in array){
            CommentModel* item  =[CommentModel praserModelWithInfo:val];
            if (item){
                [muData addObject:item];
            }
        }
        
        model.commentList = [muData mutableCopy];
    }
    
    
    return model;
}

@end
