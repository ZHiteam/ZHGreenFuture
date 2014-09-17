//
//  MaterialItemView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "MaterialItemView.h"
@interface MaterialItemView()

@property (nonatomic,strong) UILabel*        title;
@property (nonatomic,strong) UILabel*   weight;
@end

@implementation MaterialItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WHITE_BACKGROUND;
        [self addSubview:self.title];
        [self addSubview:self.weight];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, self.height-0.5, self.width-20,0.5)];
        line.backgroundColor = GRAY_LINE;
        [self addSubview:line];
    }
    return self;
}

#pragma -mark setter
-(UILabel *)title{
    if (!_title){
        _title  =[UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        _title.frame = CGRectMake(10, 0, self.width/2-10, self.height);
    }
    return _title;
}

-(UILabel *)weight{
    
    if (!_weight){
        _weight = [UILabel labelWithText:@"" font:FONT(14) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
        _weight.frame = CGRectMake(self.width/2, 0, self.width/2-10, self.height);
    }
    
    return _weight;
}
#pragma -mark setter end

-(void)setModel:(MaterialModel *)model{
    if (!model){
        return;
    }
    
    self.title.text = model.title;
    self.weight.text = model.weight;
}

@end
