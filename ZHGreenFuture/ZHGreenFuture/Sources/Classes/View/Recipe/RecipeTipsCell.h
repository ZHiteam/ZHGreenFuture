//
//  RecipeTipsCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeItemDetailModel.h"

@interface RecipeTipsCell : UITableViewCell

@property (nonatomic,assign)RecipeItemDetailModel*  model;
+(CGFloat)viewHeightWithContent:(NSString*)content;
@end
