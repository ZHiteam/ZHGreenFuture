//
//  ZHEditCountView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHEditCountView.h"

@interface ZHEditCountView()

@property (nonatomic,strong) UIButton*  subtract;
@property (nonatomic,strong) UIButton*  add;
@property (nonatomic,strong) UILabel*   countLabel;

@end

@implementation ZHEditCountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCount = 999;
        self.minCount = 1;
        [self loadContent];
    }
    return self;
}

-(void)loadContent{
    self.layer.borderColor = GRAY_LINE.CGColor;
    self.layer.borderWidth = 1;
    
    [self addSubview:self.subtract];
    
    [self addSubview:self.add];
    
    [self addSubview:self.countLabel];
}

-(UIButton *)subtract{
    
    if (!_subtract){
        
        CGFloat width = (self.width>70)?35:self.width/3;
        
        _subtract = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, self.height)];
        [_subtract setTitle:@"-" forState:UIControlStateNormal];
        [_subtract setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_subtract addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _subtract;
}

-(UIButton *)add{
    if (!_add){
        
        CGFloat width = (self.width>70)?35:self.width/3;
        
        _add = [[UIButton alloc]initWithFrame:CGRectMake(self.width-width, 0, width, self.height)];
        [_add setTitle:@"+" forState:UIControlStateNormal];
        [_add setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_add addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _add;
}

-(UILabel *)countLabel{
    
    if (!_countLabel){
        _countLabel = [UILabel labelWithText:@"1" font:FONT(16) color:BLACK_TEXT textAlignment:NSTextAlignmentCenter];
        
        _countLabel.frame = CGRectMake(self.subtract.right, 0, self.width-self.subtract.width-self.add.width, self.height);
        _countLabel.layer.borderWidth = 1;
        _countLabel.layer.borderColor = GRAY_LINE.CGColor;
    }
    
    return _countLabel;
}

-(void)action:(id)sender{
    int count = 0;
    if (sender == self.add){
        count = [self.countLabel.text intValue]+1;
    }
    else if (sender == self.subtract){
        count = [self.countLabel.text intValue]-1;
    }
    
    if (count < self.minCount){
        count = self.minCount;
    }
    if (count > self.maxCount){
        count = self.maxCount;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    
    if ([self.delegate respondsToSelector:@selector(countChange:)]){
        [self.delegate countChange:self.countLabel.text];
    }
}

#pragma -mark count getter & setter
-(NSString *)count{
    return self.countLabel.text;
}

-(void)setCount:(NSString *)count{
    self.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue]];
}

-(void)setMaxCount:(NSInteger)maxCount{
    if (maxCount <= self.minCount){
        return;
    }
    _maxCount = maxCount;
}

-(void)setMinCount:(NSInteger)minCount{
    if (minCount < 0 || minCount >= self.maxCount){
        return;
    }
    
    _minCount = minCount;
}
@end
