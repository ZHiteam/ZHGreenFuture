//
//  ZHOrderTableViewCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHOrderBadgeView;
@interface ZHOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ZHOrderBadgeView *waitPayLabel;
@property (weak, nonatomic) IBOutlet ZHOrderBadgeView *waitDeliverLabel;
@property (weak, nonatomic) IBOutlet ZHOrderBadgeView *waitReceiveLabel;
@property (weak, nonatomic) IBOutlet ZHOrderBadgeView *waitCommentLabel;
@property (weak, nonatomic) IBOutlet ZHOrderBadgeView *orderServiceLabel;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
