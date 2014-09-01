//
//  ZHProductTableViewCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageURL;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;
@property (weak, nonatomic) IBOutlet UILabel *buyCount;

+ (instancetype)tableViewCell;
+ (CGFloat)height;

- (void)updateBuyCountLabelPositon;
@end
