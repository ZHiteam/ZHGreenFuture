//
//  ZHDetailSKUInfoCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-7.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailSKUInfoCell.h"

@interface ZHDetailSKUInfoCell ()<ZHSegmentViewDelegate>
@property (copy, nonatomic)ZHSegmentControlClickedBlock segmentClickedBlock;
@end

@implementation ZHDetailSKUInfoCell

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
    id obj =  [self instanceWithNibName:@"ZHDetailSKUInfoCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailSKUInfoCell class]]) {
        ZHDetailSKUInfoCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.segmentControl setSegmentItems:@[@"产地故事",@"宝贝详情",@"服务承诺"]];
        //[cell.segmentControl setFrame:CGRectMake(12, 12, 280, 28)];
        cell.segmentControl.segmentDelegate = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoImageView.contentMode = UIViewContentModeScaleToFill;
        cell.contentView.clipsToBounds = YES;
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 960.0f;
}

- (void)setSegmentControlClickedBlock:(ZHSegmentControlClickedBlock)segmentClickedBlock{
    self.segmentClickedBlock = segmentClickedBlock;
}

#pragma mark - ZHSegmentViewDelegate
-(void)segment:(ZHSegmentView*)segment selectAtIndex:(NSInteger)index{
    if (self.segmentClickedBlock) {
        self.segmentClickedBlock(index);
    }
}

@end
