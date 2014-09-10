//
//  RecipeCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeItemModel.h"

@interface RecipeCell : UITableViewCell

@property (nonatomic,strong) RecipeItemModel*   recipeItem;

@property (nonatomic,strong) UIImageView*       imageContent;
@property (nonatomic,strong) UILabel*           titleLabel;
@property (nonatomic,strong) UILabel*           descLabel;
@property (nonatomic,strong) UIView*            discussPanel;

@property (nonatomic,strong) UILabel*           madeCountLabel;
@property (nonatomic,strong) UILabel*           disussCountLabel;
@property (nonatomic,strong) UILabel*           likeCountLabe;

+(CGFloat)cellHeight;
@end
