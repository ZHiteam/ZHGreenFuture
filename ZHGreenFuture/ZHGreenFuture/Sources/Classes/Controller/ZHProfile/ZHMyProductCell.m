//
//  ZHMyProductCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHMyProductCell.h"

@implementation ZHMyProductCell

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
    id obj =  [self instanceWithNibName:@"ZHMyProductCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHMyProductCell class]]) {
        ZHMyProductCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        topView.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:topView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        bottomView.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:bottomView];
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 118.0f;
}
@end
