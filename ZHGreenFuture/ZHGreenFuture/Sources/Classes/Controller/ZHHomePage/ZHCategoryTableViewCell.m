//
//  ZHCategoryTableViewCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHCategoryTableViewCell.h"
#import "ZHHomePageModel.h"

@interface ZHCategoryButton : UIButton
@end

@implementation ZHCategoryButton
- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *imageView = [self imageView];
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.x = (int)((self.frame.size.width - imageFrame.size.width)/ 2);
    imageFrame.origin.y = 12.0;
    imageView.frame = imageFrame;
    
    UILabel *titleLabel = [self titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.frame = CGRectMake(0, 57, self.width, titleLabel.height);
}
@end


@interface ZHCategoryTableViewCell()
@property(nonatomic, copy)void (^clickedBlock)(NSInteger index);
@property(nonatomic, strong)UIView *seperateLineView;
@property(nonatomic, strong)UIView *seperateMarginView;

@end

@implementation ZHCategoryTableViewCell

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
    id obj =  [self instanceWithNibName:@"ZHCategoryTableViewCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHCategoryTableViewCell class]]) {
        ZHCategoryTableViewCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        cell.seperateLineView.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:cell.seperateLineView];
        
        cell.seperateMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, 148, [UIScreen mainScreen].bounds.size.width, 12)];
        cell.seperateMarginView.backgroundColor = RGB(234, 234, 234);
        [cell.contentView addSubview:cell.seperateMarginView];
        
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 160.0f;
}

- (void)layoutWithCategoryItem:(NSArray*)categoryItems clickedBlock:(void (^)(NSInteger index)) block{
    self.clickedBlock = block;

    [self.contentView removeAllSubviews];
    [self.contentView addSubview:self.seperateLineView];
    [self.contentView addSubview:self.seperateMarginView];
    NSInteger index = 0, maxPerRow;
    CGFloat originX=0.0 , originY=0.0 , itemWidth=80.0 , itemHeight=74.0;
    maxPerRow  = [UIScreen mainScreen].bounds.size.width/ itemWidth;
    
    for (ZHCategoryItem *item in categoryItems) {
        if ([item isKindOfClass:[ZHCategoryItem class]]) {
            originX = itemWidth * (index % maxPerRow);
            originY = itemHeight * (index / maxPerRow);
            index ++ ;
            ZHCategoryButton * button = [[ZHCategoryButton alloc] initWithFrame:CGRectMake(originX , originY, itemWidth, itemHeight)];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            button.tag = index;
            [button setImageWithURL:[NSURL URLWithString:item.iconURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"rice"]];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:RGB(119, 119, 119) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
}

#pragma mark - Privte Method
- (void)buttonPressed:(UIButton*)sender{
    if (self.clickedBlock) {
        self.clickedBlock(sender.tag);
    }
}


@end
