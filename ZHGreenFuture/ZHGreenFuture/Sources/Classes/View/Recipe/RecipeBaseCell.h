//
//  RecipeBaseCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeItemDetailModel.h"

@interface RecipeBaseCell : UITableViewCell

@property (nonatomic,assign)RecipeItemDetailModel*  model;

+(CGFloat)viewHeightWithContent:(id)content;

@end
