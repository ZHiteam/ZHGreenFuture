//
//  ZHShoppingChartCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHShoppingChartCell.h"
#import "ZHCheckbox.h"
#import "ZHLineLabel.h"
#import "ZHEditCountView.h"

@interface ZHShoppingChartCell()

@property (nonatomic,strong) ZHCheckbox*        checkBox;
@property (nonatomic,strong) UIImageView*       productImage;
@property (nonatomic,strong) UILabel*           nameLabel;
@property (nonatomic,strong) UILabel*           standardLabel;
@property (nonatomic,strong) ZHLineLabel*       priceLabel;
@property (nonatomic,strong) UILabel*           promotionPriceLabel;
@property (nonatomic,strong) UILabel*           buyCountLabel;
@property (nonatomic,strong) ZHEditCountView*   editCountView;

@end;

@implementation ZHShoppingChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadContent];
        self.showCheckBox = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadContent{
    [self addSubview:self.checkBox];
    
    [self addSubview:self.productImage];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.standardLabel];
    
    [self addSubview:self.promotionPriceLabel];
    
    [self addSubview:self.priceLabel];
    
    [self addSubview:self.buyCountLabel];
    
    [self addSubview:self.editCountView];
}

-(ZHCheckbox *)checkBox{
    
    if (!_checkBox){
        _checkBox = [[ZHCheckbox alloc]initWithFrame:CGRectMake(10, ([ZHShoppingChartCell cellHeight]-20)/2, 20, 20)];
        
        __block ZHShoppingChartCell* cell = self;
        [_checkBox setCheckBlock:^(BOOL checked){
            [cell extraCheckAction:checked];
        }];
    }
    
    return _checkBox;
}

-(UIImageView *)productImage{
    
    if (!_productImage){
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.checkBox.right+10, ([ZHShoppingChartCell cellHeight]-60)/2, 60, 60)];
        _productImage.image = [UIImage themeImageNamed:@"temp_recipe_placehold"];
        _productImage.contentMode = UIViewContentModeScaleAspectFill;
        _productImage.clipsToBounds = YES;
        _productImage.layer.borderColor = GRAY_LINE.CGColor;
        _productImage.layer.borderWidth = 1;
    }
    
    return _productImage;
}

-(UILabel *)nameLabel{
    
    if (!_nameLabel){
        _nameLabel  =[[UILabel alloc]initWithFrame:CGRectMake(self.productImage.right+10, self.productImage.top, 130, 36)];

        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = BLACK_TEXT;
        _nameLabel.font = FONT(14);
        
        _nameLabel.numberOfLines = 0;
    }
    
    return _nameLabel;
}

-(UILabel *)standardLabel{
    
    if (!_standardLabel){
        _standardLabel = [UILabel labelWithText:@"" font:FONT(14) color:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        _standardLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 18);
    }
    
    return _standardLabel;
}

-(UILabel *)promotionPriceLabel{
    
    if (!_promotionPriceLabel){
        _promotionPriceLabel = [UILabel labelWithText:@"" font:FONT(16) color:BLACK_TEXT textAlignment:NSTextAlignmentRight];
        
        _promotionPriceLabel.frame = CGRectMake(self.nameLabel.right, self.nameLabel.top, self.width-self.nameLabel.right-10, 15);
        
        _promotionPriceLabel.text = @"￥9.89";
    }
    
    return _promotionPriceLabel;
}

-(ZHLineLabel *)priceLabel{
    
    if (!_priceLabel){
        _priceLabel = [[ZHLineLabel alloc]initWithFrame:CGRectMake(self.promotionPriceLabel.left, self.promotionPriceLabel.bottom+5, self.promotionPriceLabel.width, self.promotionPriceLabel.height)];
        _priceLabel.textColor = [UIColor lightGrayColor];
        
        _priceLabel.lineColor = _priceLabel.textColor;
        _priceLabel.lineType = LineTypeMiddle;
        _priceLabel.font = FONT(16);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.text = @"￥19.89";
    }
    
    return _priceLabel;
}

-(UILabel *)buyCountLabel{
    
    if (!_buyCountLabel){
        _buyCountLabel = [UILabel labelWithText:@"" font:FONT(16) color:BLACK_TEXT textAlignment:NSTextAlignmentRight];
        _buyCountLabel.frame = CGRectMake(self.priceLabel.left, self.priceLabel.bottom+5, self.priceLabel.width, self.priceLabel.height);
        
    }
    
    return _buyCountLabel;
}

-(ZHEditCountView *)editCountView{
    
    if (!_editCountView){
        
        _editCountView = [[ZHEditCountView alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.top, self.nameLabel.width, self.productImage.height/2)];
        
        _editCountView.hidden = YES;
    }
    
    return _editCountView;
}

#pragma -mark
#pragma -mark show checkBox
-(void)setShowCheckBox:(BOOL)showCheckBox{
    _showCheckBox = showCheckBox;
    
    if (!showCheckBox){
        self.checkBox.hidden = YES;
        
        
        self.productImage.left = self.checkBox.left;
        
        self.nameLabel.frame = CGRectMake(self.productImage.right+10,
                                          self.productImage.top,
                                          self.priceLabel.left-self.productImage.right-10,
                                          self.nameLabel.height);
        
        self.standardLabel.frame = CGRectMake(self.nameLabel.left,
                                              self.standardLabel.top,
                                              self.nameLabel.width,
                                              self.standardLabel.height);
    }
    
}

#pragma -mark
#pragma -mark editing model
-(void)setChartEditing:(BOOL)chartEditing{
    
    if (_chartEditing == chartEditing || !self.showCheckBox){
        return;
    }
    
    _chartEditing = chartEditing;
    
    if (chartEditing){
        self.nameLabel.hidden = YES;
//        self.standardLabel.hidden = YES;
        self.editCountView.hidden = NO;
    }
    else{
        self.nameLabel.hidden = NO;
//        self.standardLabel.hidden = NO;
        self.editCountView.hidden = YES;
    }
}

#pragma -mark check action
-(void)setChecked:(BOOL)checked{
    [self.checkBox setChecked:checked];
    [self extraCheckAction:checked];
}

-(BOOL)checked{
    return self.checkBox.selected;
}

-(void)extraCheckAction:(BOOL)check{
    self.model.checked = check;
}
#pragma -mark check action end

+(CGFloat)cellHeight{
    return 90;
}


-(void)setModel:(ShoppingChartModel *)model{
    if (!model){
        return;
    }
    _model = model;
    
    self.nameLabel.text = model.title;
    self.standardLabel.text = model.skuInfo;
    self.priceLabel.text = model.marketPrice;
    self.promotionPriceLabel.text = model.promotionPrice;
    self.buyCountLabel.text = [NSString stringWithFormat:@"x %@",model.buyCout];
    self.editCountView.count = model.buyCout;
    
    self.checkBox.checked = model.checked;
    

    
}
@end
