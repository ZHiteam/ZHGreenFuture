//
//  ZHDetailPriceCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDetailPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *promotionPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTagLabel;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
