//
//  ZHDetailBannerCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailBannerCell.h"

@implementation ZHDetailBannerCell

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
    id obj =  [self instanceWithNibName:@"ZHDetailBannerCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailBannerCell class]]) {
        ZHDetailBannerCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.bannerBlurBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 320.0f;
}


@end
