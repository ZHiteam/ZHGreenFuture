//
//  ZHRecommendTableViewCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHRecommendTableViewCell.h"

@implementation ZHRecommendTableViewCell

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
    id obj =  [self instanceWithNibName:@"ZHRecommendTableViewCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHRecommendTableViewCell class]]) {
        ZHRecommendTableViewCell *cell = obj;
        cell.contentView.backgroundColor = RGB(234, 234, 234);
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 170.0f;
}


@end
