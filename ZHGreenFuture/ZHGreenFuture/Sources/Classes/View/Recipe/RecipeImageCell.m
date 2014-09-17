//
//  RecipeImageView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/11/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeImageCell.h"
#import "UIView+ZHiteam.h"

#define IMAGE_HEIGHT    240

@interface RecipeImageCell()

@property (nonatomic,strong)    UIImageView*    imagePanel;              /// 图片
@property (nonatomic,strong)    UILabel*        author;             /// 作者
@property (nonatomic,strong)    UILabel*        madeCount;          /// 做过
@property (nonatomic,strong)    UILabel*        collectCount;       /// 收藏

@property (nonatomic,strong)    UIView*         contentPanel;       /// 养生必读区块
@property (nonatomic,strong)    UILabel*        healthLabel;
@property (nonatomic,strong)    UILabel*        recipeNeed;         /// 养生必读

@end

@implementation RecipeImageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        [self loadContent];

    }
    return self;
}

-(void)loadContent{
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.imagePanel];
    
    [self addSubview:self.contentPanel];
    
    [self addSubview:self.healthLabel];
    
    [self addSubview:self.recipeNeed];
}

#pragma -mark getter
-(UIImageView *)imagePanel{
    
    if (!_imagePanel){
        _imagePanel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, IMAGE_HEIGHT)];
        
        [_imagePanel addSubview:self.author];
        
        [_imagePanel addSubview:self.madeCount];
    }
    
    return _imagePanel;
}

-(UILabel *)author{
    
    if (!_author){
        _author = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        
        _author.frame = CGRectMake(5, 205, 60, 20);
    }
    return _author;
}

-(UILabel *)madeCount{
    
    if (!_madeCount){
        _madeCount = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentRight];
        _madeCount.frame = CGRectMake(self.width-70, self.author.top, 60, self.author.height);
    }
    
    return _madeCount;
}

-(UIView *)contentPanel{
    
    if (!_contentPanel){
        _contentPanel = [[UIView alloc]initWithFrame:CGRectMake(0, self.imagePanel.bottom, self.width, self.height-self.imagePanel.bottom-10)];
        _contentPanel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _contentPanel;
}

-(UILabel *)healthLabel{
    if (!_healthLabel){
        _healthLabel = [UILabel labelWithText:@"养生必读" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        
        _healthLabel.frame = CGRectMake(10, self.contentPanel.top+5, self.width-5, 20);
        
    }
    return _healthLabel;
}

-(UILabel *)recipeNeed{
    
    if (!_recipeNeed){
        UILabel* label = [[UILabel alloc]init];
        label.font = FONT(13);
        label.textColor = BLACK_TEXT;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        _recipeNeed = label;
        
        _recipeNeed.frame = CGRectMake(10, self.healthLabel.bottom+5, self.width, self.contentPanel.height-self.healthLabel.height-10);
    }
    return _recipeNeed;
}

#pragma -mark getter end
-(void)setModel:(RecipeItemDetailModel *)model{
    [self.imagePanel setImageWithUrlString:model.backgroundImage placeHodlerImage:[UIImage themeImageNamed:@"temp_recipe_banner@2x"]];
    
    self.author.text = [NSString stringWithFormat:@"by %@",model.author];
    self.madeCount.text = [NSString stringWithFormat:@"%@ 人做过",model.done];
    
    self.recipeNeed.text = model.health;
    
    CGFloat height = [model.health sizeWithFont:FONT(12)
                                constrainedToSize:CGSizeMake(FULL_WIDTH , MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping].height;
    
    self.contentPanel.frame = CGRectMake(0, self.imagePanel.bottom, self.width, height+40);
    
    self.healthLabel.top = self.contentPanel.top+5;
    
    self.recipeNeed.frame = CGRectMake(5, self.healthLabel.bottom+5, self.contentPanel.width, height);
}

+(CGFloat)viewHeightWithContent:(NSString *)content{
    
    CGSize size = [content sizeWithFont:FONT(12)
                                       constrainedToSize:CGSizeMake(FULL_WIDTH , MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    return 240+40+size.height+10;
}
@end
