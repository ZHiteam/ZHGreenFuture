//
//  ZHDetailProductCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDetailProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *leftOverLayerView;
@property (weak, nonatomic) IBOutlet UIView *rightOverLayerView;
+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
