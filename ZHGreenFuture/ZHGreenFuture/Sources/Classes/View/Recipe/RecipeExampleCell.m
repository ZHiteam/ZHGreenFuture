//
//  RecipeExampleCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeExampleCell.h"

@interface RecipeExampleCell()

@property (nonatomic,strong) UILabel*   titleLabel;
@property (nonatomic,strong) FEScrollPageView*  contentImageView;
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

-(FEScrollPageView *)contentImageView{
    
    if (!_contentImageView){
        _contentImageView = [[FEScrollPageView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom+5, self.width, self.height-40) imageItems:nil selectedBlock:nil isAutoPlay:NO];
        _contentImageView.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _contentImageView;
}

-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model) {
        return;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"大家照着菜谱做 (%@)",model.example.count];
    
    [self.contentImageView setImageItems:model.example.images selectedBlock:nil isAutoPlay:NO];
    [self.contentImageView updateLayout];
    
}

+(CGFloat)viewHeightWithContent:(id)content{
    return 120+10.0f;
}
@end
