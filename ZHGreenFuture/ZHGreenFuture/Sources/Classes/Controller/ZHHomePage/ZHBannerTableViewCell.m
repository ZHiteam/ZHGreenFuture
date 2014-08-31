//
//  ZHBannerTableViewCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHBannerTableViewCell.h"
#import "FEScrollPageView.h"

@interface ZHBannerTableViewCell()
@end

@implementation ZHBannerTableViewCell

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
    id obj =  [self instanceWithNibName:@"ZHBannerTableViewCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHBannerTableViewCell class]]) {
        ZHBannerTableViewCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.bannerScrollView.palceHoldImage = @"bannerPlaceholder.png";
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 100.0f;
}
@end
