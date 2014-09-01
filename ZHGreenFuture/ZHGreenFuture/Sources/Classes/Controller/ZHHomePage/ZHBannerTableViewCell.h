//
//  ZHBannerTableViewCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBannerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FEScrollPageView *bannerScrollView;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
