//
//  RecipeExampleItem.m
//  ZHGreenFuture
//
//  Created by elvis on 10/7/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeExampleItem.h"
#import "ZHMyProductModel.h"

@interface RecipeExampleItem()
@property (nonatomic,strong) UIImageView*       image;
@property (nonatomic,strong) UIView*            line;
@property (nonatomic,strong) UILabel*           titleLabel;
@property (nonatomic,strong) UILabel*           createDateLabel;
@property (nonatomic,strong) UILabel*           author;
@property (nonatomic,strong) UIControl*         mask;

@end

@implementation RecipeExampleItem

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self loadContent];
    }
    return self;
}

-(void)loadContent{
    self.backgroundColor = GRAY_LINE;
    [self addSubview:self.image];
    
    [self addSubview:self.line];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.createDateLabel];
    
    [self addSubview:self.author];
    
    [self addSubview:self.mask];
}

-(UIControl *)mask{
    if (!_mask) {
        _mask = [[UIControl alloc]initWithFrame:self.bounds];
        
        _mask.backgroundColor = [UIColor clearColor];
        
        __block __typeof(self)weakSelf = self;
        [_mask setTouchUpInsideBlock:^(UIControl *ctl) {
            if (!isEmptyString(weakSelf.model.workId)){
                ZHMyProductItem* item = [[ZHMyProductItem alloc]init];
                item.workId = weakSelf.model.workId;
                item.followName = weakSelf.model.content;
                
                NSDictionary* info = @{@"controller":@"ZHMyProductDetailVC",@"userinfo":item};
                [[MessageCenter instance]performActionWithUserInfo:info];
            }
        }];
    }
    return _mask;
}

-(UIImageView *)image{
    
    if (!_image){
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-40)];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    
    return _image;
}

-(UIView *)line{
    
    if (!_line){
        _line = [[UIView alloc]initWithFrame:CGRectMake(self.image.left, self.image.height-1, self.image.width, 1)];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _line;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(5, self.image.height-20, self.image.width, 20);
    }
    
    return _titleLabel;
}

-(UILabel *)createDateLabel{
    
    if (!_createDateLabel) {
        _createDateLabel = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _createDateLabel.frame = self.titleLabel.frame;
        _createDateLabel.top = self.titleLabel.bottom;
    }
    
    return _createDateLabel;
}

-(UILabel *)author{
    
    if (!_author) {
        _author = [UILabel labelWithText:@"" font:FONT(14) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _author.frame = _createDateLabel.frame;
        _author.top = _createDateLabel.bottom-10;
    }
    
    return _author;
}

-(void)setModel:(RecipeExampleImageContent *)model{
    if (!model){
        return;
    }
    _model = model;
    [self.image setImageWithUrlString:model.url placeholderImage:nil];
    self.titleLabel.text = model.content;
    self.createDateLabel.text = model.creataDate;
    self.author.text = model.nickName;
}
@end
