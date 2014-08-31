//
//  ZHRecommendTableViewCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHRecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *calenderView;
@property (weak, nonatomic) IBOutlet UIImageView *surpriseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *creditsImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
