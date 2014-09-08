//
//  ZHDetailProductCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailProductCell.h"

@implementation ZHDetailProductCell

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
    id obj =  [self instanceWithNibName:@"ZHDetailProductCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailProductCell class]]) {
        ZHDetailProductCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 220.0f;
}


@end
