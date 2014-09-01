//
//  ZHCategoryTableViewCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCategoryTableViewCell : UITableViewCell
+ (instancetype)tableViewCell;
+ (CGFloat)height;
- (void)layoutWithCategoryItem:(NSArray*)categoryItems clickedBlock:(void (^)(NSInteger index)) block;
@end
