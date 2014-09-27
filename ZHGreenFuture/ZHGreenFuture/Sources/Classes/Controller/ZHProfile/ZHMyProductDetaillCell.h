//
//  ZHMyProductDetaillCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHMyProductDetaillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
