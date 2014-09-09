//
//  RecipeCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadContent];
    }
    
    return self;
}

-(void)loadContent{
    UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage themeImageNamed:@"gradient_layer"]];
    bg.frame = CGRectMake(0, 0, self.width, [RecipeCell cellHeight]);
    [self.contentView addSubview:bg];
    
    [self.contentView addSubview:self.imageContent];
    
    [self.imageContent addSubview:self.titleLabel];
    [self.imageContent addSubview:self.descLabel];
    
    [self.contentView addSubview:self.discussPanel];
    
    [self.discussPanel addSubview:self.madeCountLabel];
    [self.discussPanel addSubview:self.disussCountLabel];
    
    UIImageView* bannerMask = [[UIImageView alloc]initWithImage:[UIImage themeImageNamed:@"banner_mask"]];
    bannerMask.frame = self.imageContent.frame;
    [self addSubview:bannerMask];
    
#warning TEST placehold
    self.imageContent.image = [UIImage themeImageNamed:@"temp_recipe_placehold"];
    self.titleLabel.text = @"香肠蒸糯米饭";
    self.descLabel.text = @"扩张血管、促进生长、发育、增强免疫系统";
    self.madeCountLabel.text = @"18 人做过";
    self.disussCountLabel.text = @"16";
}

#pragma -mark getter
-(UIImageView *)imageContent{
    if (!_imageContent){
        _imageContent = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width-20, 150)];
    }
    
    return _imageContent;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"" font:FONT(20) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 105, self.imageContent.width-10, 20);
        
        
        //设置阴影
        _titleLabel.shadowColor = [UIColor grayColor];
        _titleLabel.shadowOffset = CGSizeMake(1.0,1.0);
    }
    
    return _titleLabel;
}

-(UILabel *)descLabel{
    
    if (!_descLabel){
        _descLabel = [UILabel labelWithText:@"" font:FONT(12) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _descLabel.frame = CGRectMake(10, 125, self.titleLabel.width, self.titleLabel.height);
        
        //设置阴影
        _descLabel.shadowColor = [UIColor grayColor];
        _descLabel.shadowOffset = CGSizeMake(1.0,1.0);
    }
    
    return _descLabel;
}

-(UIView *)discussPanel{
    if (!_discussPanel){
        _discussPanel = [[UIView alloc]initWithFrame:CGRectMake(self.imageContent.left, self.imageContent.bottom, self.imageContent.width, 30)];
        _discussPanel.backgroundColor = GRAY_LINE;
    }
    
    return _discussPanel;
}

-(UILabel *)madeCountLabel{
    if (!_madeCountLabel) {
        _madeCountLabel = [UILabel labelWithText:@"" font:FONT(10) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
        _madeCountLabel.frame = CGRectMake(10, 0, 60, 30);
    }
    return _madeCountLabel;
}

-(UILabel *)disussCountLabel{
    if (!_disussCountLabel){
        _disussCountLabel = [UILabel labelWithText:@"" font:FONT(10) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
        _disussCountLabel.frame = CGRectMake(self.discussPanel.width-30, 0, 30, 30);
        
        UIImageView* dicImage = [[UIImageView alloc]initWithImage:[UIImage themeImageNamed:@"btn_discuss"]];
        dicImage.frame = CGRectMake(_disussCountLabel.left-14, 10, 12, 11);
        [self.discussPanel addSubview:dicImage];
    }
    return _disussCountLabel;
}
#pragma -mark getter end

+(CGFloat)cellHeight{
    return 200.0f;
}
@end
