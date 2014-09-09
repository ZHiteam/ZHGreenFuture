//
//  ZHDetailProductGuaranteeCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailProductGuaranteeCell.h"

@implementation ZHDetailProductGuaranteeCell

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
    id obj =  [self instanceWithNibName:@"ZHDetailProductGuaranteeCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailProductGuaranteeCell class]]) {
        ZHDetailProductGuaranteeCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *seperateLineview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
        seperateLineview.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [cell.contentView addSubview:seperateLineview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 36.0f;
}


@end
