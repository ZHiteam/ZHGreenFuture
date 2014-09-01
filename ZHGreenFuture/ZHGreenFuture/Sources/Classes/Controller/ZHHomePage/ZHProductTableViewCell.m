//
//  ZHProductTableViewCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProductTableViewCell.h"
@interface ZHProductTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *topSeperateLine;

@end

@implementation ZHProductTableViewCell

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
    id obj =  [self instanceWithNibName:@"ZHProductTableViewCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHProductTableViewCell class]]) {
        ZHProductTableViewCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.topSeperateLine.frame = CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width - 24, 0.5);
        cell.topSeperateLine.backgroundColor = RGB(204, 204, 204);//0xcccccc
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 114.0f;
}

- (void)updateBuyCountLabelPositon{
    CGSize size = [self.priceTitle.text sizeWithFontExact:self.priceTitle.font];
    CGRect rect = self.buyCount.frame;
    rect.origin.x = self.priceTitle.origin.x + size.width + 5;
    self.buyCount.frame = rect;
    self.priceTitle.width = size.width + 5;
}


@end
