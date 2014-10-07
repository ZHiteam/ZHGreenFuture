//
//  RecipeExampleCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeExampleCell.h"
#import "RecipeExampleItem.h"

@interface RecipeExampleCell()

@property (nonatomic,strong) UILabel*   titleLabel;
@property (nonatomic,strong) UIScrollView*  contentImageView;
@end

@implementation RecipeExampleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadContent];
    }
    return self;
}

-(void)loadContent{
    self.backgroundColor = [UIColor clearColor];
    
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.top, self.width, 120)];
    bg.backgroundColor = WHITE_BACKGROUND;
    bg.left= 0;
    [self addSubview:bg];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.contentImageView];
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"大家照着菜谱做" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 0.0f, self.width-5, 25);
        _titleLabel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _titleLabel;
}

-(UIScrollView *)contentImageView{
    
    if (!_contentImageView){
        _contentImageView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom+5, self.width, [RecipeExampleCell viewHeightWithContent:nil]-40)];
        _contentImageView.backgroundColor = WHITE_BACKGROUND;
        _contentImageView.showsHorizontalScrollIndicator = NO;
        _contentImageView.pagingEnabled = YES;
    }
    
    return _contentImageView;
}

-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model) {
        return;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"大家照着菜谱做 (%@)",model.example.count];
    
    [self.contentImageView removeAllSubviews];
    CGFloat xOffset = 10;
    CGFloat height = self.contentImageView.height-10;
    for (int i =0; i < model.example.images.count; ++i){
        RecipeExampleItem* item = [[RecipeExampleItem alloc]initWithFrame:CGRectMake(xOffset, 0, height-40, height)];
        [item setModel:model.example.images[i]];
        [self.contentImageView addSubview:item];
        xOffset += 10+item.width;
    }
    
    self.contentImageView.contentSize = CGSizeMake(xOffset, self.contentImageView.height);
//    [self.contentImageView setImageItems:model.example.images selectedBlock:nil isAutoPlay:NO];
//    [self.contentImageView updateLayout];
    
}

+(CGFloat)viewHeightWithContent:(id)content{
    return 160+10.0f;
}
@end
