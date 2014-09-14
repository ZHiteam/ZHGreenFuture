//
//  ZHOrderStatusCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderStatusCell.h"

@implementation ZHOrderStatusCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Method
+ (instancetype)tableViewCell{
    id obj =  [self instanceWithNibName:@"ZHOrderStatusCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHOrderStatusCell class]]) {
        ZHOrderStatusCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, [UIScreen mainScreen].bounds.size.width, 0.5)];
        topView.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:topView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, cell.bounds.size.height-1, [UIScreen mainScreen].bounds.size.width - 24, 0.5)];
        view.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:view];
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 40.0f;
}

@end
