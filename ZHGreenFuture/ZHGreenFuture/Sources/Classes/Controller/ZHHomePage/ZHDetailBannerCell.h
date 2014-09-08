//
//  ZHDetailBannerCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDetailBannerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet FEScrollPageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIView *bannerBlurBackView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitleLabel;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
