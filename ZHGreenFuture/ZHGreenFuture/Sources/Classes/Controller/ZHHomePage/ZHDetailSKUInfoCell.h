//
//  ZHDetailSKUInfoCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHSegmentView.h"

typedef void(^ZHSegmentControlClickedBlock)(NSInteger index);

@interface ZHDetailSKUInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ZHSegmentView *segmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
+ (instancetype)tableViewCell;
+ (CGFloat)height;
- (void)setSegmentControlClickedBlock:(ZHSegmentControlClickedBlock)segmentClickedBlock;
@end
