//
//  ZHDetailLogisticsInfoCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDetailLogisticsInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logisticsFreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *producingAreaLabel;
+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
