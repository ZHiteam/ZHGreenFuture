//
//  RecipeImageView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/11/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeImageView.h"

#define IMAGE_HEIGHT    240

@interface RecipeImageView()

@property (nonatomic,strong)    UIImageView*    image;              /// 图片
@property (nonatomic,strong)    UILabel*        author;             /// 作者
@property (nonatomic,strong)    UILabel*        madeCount;          /// 做过
@property (nonatomic,strong)    UILabel*        collectCount;       /// 收藏

@property (nonatomic,strong)    UIView*         contentPanel;       /// 养生必读区块
@property (nonatomic,strong)    UILabel*        recipeNeed;         /// 养生必读

@end

@implementation RecipeImageView

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        [self loadCount];
    }
    return self;
}

-(void)loadCount{
    [self addSubview:self.image];
    
    [self addSubview:self.contentPanel];
}

#pragma -mark getter
-(UIImageView *)image{
    
    if (!_image){
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, IMAGE_HEIGHT)];
        
        [_image addSubview:self.author];
        
        [_image addSubview:self.madeCount];
    }
    
    return _image;
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

-(UILabel *)recipeNeed{
    
    if (!_recipeNeed){
        UILabel* label = [[UILabel alloc]init];
        label.font = FONT(13);
        label.textColor = BLACK_TEXT;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        _recipeNeed = label;
    }
    return _recipeNeed;
}

-(UIView *)contentPanel{
    
    if (!_contentPanel){
        _contentPanel = [[UIView alloc]initWithFrame:CGRectMake(0, self.image.bottom, self.width, self.height-self.image.height-10)];
        
        UILabel* label = [UILabel labelWithText:@"养生必读" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        
        label.frame = CGRectMake(5, 5, self.width-5, 20);
        
        [_contentPanel addSubview:label];
        
        self.recipeNeed.frame = CGRectMake(label.left, label.bottom+5, label.width, _contentPanel.height-label.bottom-10);
        
        [_contentPanel addSubview:self.recipeNeed];
    }
    
    return _contentPanel;
}

#pragma -mark getter end
-(void)setModel:(RecipeItemDetailModel *)model{
    [self.image setImageWithUrl:model.backgroundImage placeHodlerImage:[UIImage themeImageNamed:@"temp_recipe_banner@2x"]];
    
    self.author.text = [NSString stringWithFormat:@"by %@",model.author];
    self.madeCount.text = [NSString stringWithFormat:@"%@ 人做过",model.done];
    
    self.recipeNeed.text = model.health;
    
    self.recipeNeed.height = [model.health sizeWithFont:FONT(12)
                                constrainedToSize:CGSizeMake(FULL_WIDTH , MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping].height;
    
    self.contentPanel.height = self.recipeNeed.height+40;
}

+(CGFloat)viewHeightWithContent:(NSString *)content{
    
    CGSize size = [content sizeWithFont:FONT(12)
                                       constrainedToSize:CGSizeMake(FULL_WIDTH , MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    return 240+40+size.height+10;
}
@end
