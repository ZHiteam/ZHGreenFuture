//
//  ZHOrderSummaryCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHOrderSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
