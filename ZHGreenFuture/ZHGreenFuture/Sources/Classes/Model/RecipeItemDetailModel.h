//
//  RecipeItemDetailModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/13/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"
#import "MaterialModel.h"
#import "MadeStepModel.h"
#import "CommentModel.h"
#import "RecpieExampleModel.h"

@interface RecipeItemDetailModel : BaseModel

@property (nonatomic,strong) NSString*      backgroundImage;    /// 背景图片
@property (nonatomic,strong) NSString*      recipeName;         /// 食谱名称
@property (nonatomic,strong) NSString*      author;             /// 作者
@property (nonatomic,strong) NSString*      done;               /// 多少人做过
@property (nonatomic,strong) NSString*      health;             /// 养生必读
@property (nonatomic,strong) NSString*      tips;               /// 小贴士
@property (nonatomic,strong) NSArray*       material;           /// 养生数组
@property (nonatomic,strong) NSArray*       practice;           /// 做法对象
@property (nonatomic,strong) RecpieExampleModel*       example;            /// 菜谱案例
@property (nonatomic,strong) NSString*      commentCount;       /// 评论总数
@property (nonatomic,strong) NSArray*       commentList;        /// 评论列表

@end