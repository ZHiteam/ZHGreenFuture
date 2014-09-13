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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    
    if (_author){
        _author = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        
        _author.frame = CGRectMake(5, 205, 30, 20);
    }
    return _author;
}

-(UILabel *)madeCount{
    
    if (_madeCount){
        _madeCount = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentRight];
        _madeCount.frame = CGRectMake(self.width-40, self.author.top, 35, self.author.height);
    }
    
    return _madeCount;
}

-(UILabel *)recipeNeed{
    
    if (!_recipeNeed){
        UILabel* label = [[UILabel alloc]init];
        label.font = FONT(13);
        label.textColor = WHITE_TEXT;
        label.textAlignment = NSTextAlignmentLeft;
        _recipeNeed = label;
    }
    
    return _recipeNeed;
}

#pragma -mark getter end


+(CGFloat)viewHeightWithContent:(NSString *)content{
    
    CGSize size = [content sizeWithFont:FONT(12)
                                       constrainedToSize:CGSizeMake(FULL_WIDTH , MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    return 240+40+size.height+10;
}
@end
