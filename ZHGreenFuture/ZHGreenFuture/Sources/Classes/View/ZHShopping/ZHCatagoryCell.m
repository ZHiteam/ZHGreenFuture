//
//  ZHCatagoryCell.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCatagoryCell.h"

typedef enum keyPath{
    MASK_TAG = -101,
    CELL_TAG_START = -100,
}KeyPath;

@interface ZHCatagoryCell()
@property (nonatomic,strong) UIImageView*   catagoryImage;
@property (nonatomic,strong) UILabel*   catagoryLabel;
@property (nonatomic,strong) NSMutableArray*    subTitles;

@end

@implementation ZHCatagoryCell

-(void)reloadData{
    [self.contentView removeAllSubviews];
    
    /// image
    self.catagoryImage.frame = CGRectMake((self.width/4-50)/2, (self.height-CELL_BOTTOM_SPAN-72)/2, CELL_PER_HEIGHT, CELL_PER_HEIGHT);
    [self.contentView addSubview:_catagoryImage];
    [self.catagoryImage setImageWithUrlString:self.catagory.backgourndImageUrl placeHodlerImage:nil];
    
    /// label
    self.catagoryLabel.frame = CGRectMake(0, self.catagoryImage.bottom+3, self.width/4, 28);
    [self.contentView addSubview:_catagoryLabel];
    [self.catagoryLabel setText:self.catagory.title];
    
    /// mask
    UIControl* mask = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.width/4,self.height-CELL_BOTTOM_SPAN)];
    mask.backgroundColor = [UIColor clearColor];
    mask.tag = MASK_TAG;
    [mask addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:mask];
    
    
    
    /// 底部灰色块
    UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-CELL_BOTTOM_SPAN, self.width, CELL_BOTTOM_SPAN)];
    
    sep.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:sep];
    
    /// 竖线分割线
    CGFloat xOffset = self.width/4;
    for (int i = 0 ;i < 3; ++i){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(xOffset, 8, 0.5, self.height-CELL_BOTTOM_SPAN-16)];
        line.backgroundColor = GRAY_LINE;
        [self.contentView addSubview:line];
        
        xOffset += self.width/4;
    }
    
    /// 横线分割线
    int count = self.catagory.productList.count/3 + ((self.catagory.productList.count%3 == 0)?0:1)-1;
    
    if (count < 1){
        count = 1;
    }
    CGFloat xStart = self.width/4+0.5, width = xOffset-xStart;
    CGFloat yOffset = CELL_HEIGHT_SPAN + CELL_PER_HEIGHT;
    for( int i = 0 ; i < count ; ++i){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(xStart, yOffset, width, 0.5)];
        line.backgroundColor = GRAY_LINE;
        yOffset += CELL_PER_HEIGHT;
        [self.contentView addSubview:line];
    }
    
    /// subtitles
    width = self.width/4;
    xOffset = width;
    yOffset = CELL_HEIGHT_SPAN;

    for (int i = 0 ; i < self.catagory.productList.count ; ++ i){
        
        SecondCatagoryModel* model = self.catagory.productList[i];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        btn.frame = CGRectMake(xOffset, yOffset, width, CELL_PER_HEIGHT);
        
        btn.titleLabel.font = FONT(16);
        
        if ((i+1)%3 ==0 ){
            yOffset += CELL_PER_HEIGHT;
            xOffset = width;
        }
        else{
            xOffset += width;
        }
        
        btn.tag = CELL_TAG_START+i;
        [btn addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
    }
    
    /// 上下边框
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    line.backgroundColor = GRAY_LINE;
    [self.contentView addSubview:line];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-CELL_BOTTOM_SPAN, self.width, 0.5)];
    line2.backgroundColor = GRAY_LINE;
    [self.contentView addSubview:line2];
    
}


+(CGFloat)getCellHeightWithCatagoryCount:(NSInteger)catagoryCount{
    
    return CELL_BOTTOM_SPAN + CELL_HEIGHT_SPAN*2 + catagoryCount/3*CELL_PER_HEIGHT + ((catagoryCount%3 == 0)?0:CELL_PER_HEIGHT);
}

-(UIImageView *)catagoryImage{
    if (!_catagoryImage){
        _catagoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    
    return _catagoryImage;
}


-(UILabel *)catagoryLabel{
    if (!_catagoryLabel){
        _catagoryLabel = [UILabel labelWithText:@"" font:FONT(14) color:RGB(100, 100, 100) textAlignment:NSTextAlignmentCenter];
    }
    return _catagoryLabel;
}

#pragma -mark action
-(void)performAction:(id)sender{
    if (![sender isKindOfClass:[UIView class]]){
        return;
    }
    
    if (![self.cellDelegate respondsToSelector:@selector(catagorySelectedAtIndex:)]){
        return;
    }
    
    int tag = ((UIView*)sender).tag;
    
    if (MASK_TAG == tag){
        [self.cellDelegate catagorySelectedAtIndex:[NSIndexPath indexPathForRow:-1 inSection:self.cellIndex]];
    }
    
    tag -= CELL_TAG_START;
    if (tag < 0 || tag >= self.catagory.productList.count){
        return;
    }
    
    [self.cellDelegate catagorySelectedAtIndex:[NSIndexPath indexPathForRow:tag inSection:self.cellIndex]];
}
@end
