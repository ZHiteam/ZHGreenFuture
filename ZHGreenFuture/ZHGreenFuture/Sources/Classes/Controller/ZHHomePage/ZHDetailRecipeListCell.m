//
//  ZHDetailRecipeListCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailRecipeListCell.h"


@interface ZHDetailRecipeListCell ()
@property (copy, nonatomic)ZHMoreItemClickedBlock moreItemClickedBlock;

@end

@implementation ZHDetailRecipeListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




#pragma mark - Public Method
+ (instancetype)tableViewCell{
    id obj =  [self instanceWithNibName:@"ZHDetailRecipeListCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailRecipeListCell class]]) {
        ZHDetailRecipeListCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *seperateLineview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
        seperateLineview.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [cell.contentView addSubview:seperateLineview];
        [cell.moreRecipeButton addTarget:cell action:@selector(moreItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.recipeListView.edgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);//左右间距
        cell.recipeListView.margin    = 8.0;                            //每个item之间的间距
        cell.recipeListView.itemWidth = 92.0;                           //每个item的宽度
        cell.recipeListView.titleLabelRect = CGRectMake(0, 74, 90, 16); //每个item 的title Label的位置
        
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 144.0f;
}

- (void)moreItemPressed:(id)sender{
    if (self.moreItemClickedBlock) {
        self.moreItemClickedBlock(sender);
    }
}

- (void)setMoreItemClickedBlock:(ZHMoreItemClickedBlock)moreItemClickedBlock{
    _moreItemClickedBlock = [moreItemClickedBlock copy];
}



@end
