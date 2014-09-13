//
//  RecipeImageView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/11/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeItemModel.h"

@interface RecipeImageView : UIView

@property (nonatomic,strong) RecipeItemModel*   item;

+(CGFloat)viewHeightWithContent:(NSString*)content;
@end
