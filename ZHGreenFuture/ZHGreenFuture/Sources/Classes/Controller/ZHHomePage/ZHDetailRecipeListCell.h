//
//  ZHDetailRecipeListCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHMoreItemClickedBlock)(id sender);


@interface ZHDetailRecipeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recipeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreRecipeButton;
@property (weak, nonatomic) IBOutlet FEScrollPageView *recipeListView;
+ (instancetype)tableViewCell;
+ (CGFloat)height;
- (void)setMoreItemClickedBlock:(ZHMoreItemClickedBlock)moreItemClickedBlock;

@end
