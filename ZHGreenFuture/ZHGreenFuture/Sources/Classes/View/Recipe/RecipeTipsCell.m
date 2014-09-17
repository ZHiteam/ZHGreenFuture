//
//  RecipeTipsCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeTipsCell.h"

@interface RecipeTipsCell()
@property (nonatomic,strong) UIView*        bgPanel;
@property (nonatomic,strong) UILabel*       titleLabel;
@property (nonatomic,strong) UILabel*       tips;
@end

@implementation RecipeTipsCell

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
    
    [self addSubview:self.bgPanel];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.tips];
}

-(UIView *)bgPanel{
    
    if (!_bgPanel){
        _bgPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-10)];
        _bgPanel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _bgPanel;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"小贴士" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 0, self.width-5, 25);
        _titleLabel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _titleLabel;
}

-(UILabel *)tips{
    
    if (!_tips){
        UILabel* label = [[UILabel alloc]init];
        label.font = FONT(13);
        label.textColor = BLACK_TEXT;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;

        _tips = label;
        
        _tips.frame = CGRectMake(5, self.titleLabel.bottom+5, self.titleLabel.width, self.height-self.titleLabel.bottom-10);
    }
    
    return _tips;
}

-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model){
        return;
    }
    
    self.tips.text = model.tips;
    
    CGFloat height = [RecipeTipsCell viewHeightWithContent:model.tips];
    
    self.tips.height = height-45;
    
    self.bgPanel.height = height-10;
}

+(CGFloat)viewHeightWithContent:(NSString *)content{
    CGFloat height = 25+5.0;
    
    CGSize size = [content sizeWithFont:FONT(14) constrainedToSize:CGSizeMake(FULL_WIDTH-10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    height += size.height+5.0;
    
    return height+10;
}
@end
