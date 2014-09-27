//
//  ZHMyProductDetaillCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHMyProductDetaillCell.h"

@implementation ZHMyProductDetaillCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tableViewCell{
    id obj =  [self instanceWithNibName:@"ZHMyProductDetaillCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHMyProductDetaillCell class]]) {
        ZHMyProductDetaillCell *cell = obj;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.contentView.alpha = 0.5;
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 80;
}

@end
