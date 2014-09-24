//
//  RecipeCommentItemView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface RecipeCommentItemView : UITableViewCell

@property (nonatomic,strong) CommentModel*  model;
@property (nonatomic,assign) BOOL           lineTop;

+(CGFloat)itemHeight;
@end
