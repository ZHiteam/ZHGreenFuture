//
//  ZHOrderTableViewCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderTableViewCell.h"
#import "ZHOrderBadgeView.h"

@implementation ZHOrderTableViewCell

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
    id obj =  [self instanceWithNibName:@"ZHOrderTableViewCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHOrderTableViewCell class]]) {
        ZHOrderTableViewCell *cell = obj;
        cell.contentView.backgroundColor   = [UIColor whiteColor];
        cell.waitPayLabel.backgroundColor  = [UIColor clearColor];
        cell.waitDeliverLabel.backgroundColor  = [UIColor clearColor];
        cell.waitReceiveLabel.backgroundColor  = [UIColor clearColor];
        cell.waitCommentLabel.backgroundColor  = [UIColor clearColor];
        cell.orderServiceLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 60.0f;
}

@end
