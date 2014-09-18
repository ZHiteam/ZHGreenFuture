//
//  MadeStepView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeMadeStepCell.h"
#import "MadeStepItemView.h"

#define SPAN    10
@interface RecipeMadeStepCell()
@property (nonatomic,strong) UILabel*       titleLabel;
@property (nonatomic,strong) UIView*        madeStepContent;

@property (nonatomic,strong) NSMutableArray*    madeStepItems;

@end


@implementation RecipeMadeStepCell

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
    
    UIView* bg = [[UIView alloc]initWithFrame:self.titleLabel.frame];
    bg.backgroundColor = WHITE_BACKGROUND;
    bg.left= 0;
    [self addSubview:bg];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.madeStepContent];
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"做法" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 0, self.width-5, 25);
        _titleLabel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _titleLabel;
}

-(UIView *)madeStepContent{
    
    if (!_madeStepContent){
        _madeStepContent = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, self.width, self.height-self.titleLabel.bottom)];
    }
    
    return _madeStepContent;
}

#pragma -mark set model
-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model){
        return;
    }
    
    [self.madeStepContent removeAllSubviews];
    
    if (!self.madeStepItems){
        self.madeStepItems = [[NSMutableArray alloc]initWithCapacity:model.material.count];
    }
    
    CGFloat yOffset = 0;
    for (int i = 0;i < model.practice.count ; ++i){
        MadeStepModel* val = model.practice[i];
        if (![val isKindOfClass:[MadeStepModel class]]){
            continue;
        }
        
        MadeStepItemView* item = nil;
        
        if (self.madeStepItems.count > i){
            item = self.madeStepItems[i];
        }
        else{
            item = [[MadeStepItemView alloc]initWithFrame:CGRectMake(0, yOffset, self.width, 40)];
            
            [self.madeStepItems addObject:item];
        }
        
        [item setModel:val index:i+1];
        
        yOffset += item.height;
        
        [self.madeStepContent addSubview:item];
    }
    
    self.madeStepContent.height = yOffset;
    
}

#pragma -mark end

+(CGFloat)viewHeightWithContent:(id)content{
    CGFloat height = 25.0f;
    
    for(MadeStepModel* model in (NSArray*)content){
        if ([model isKindOfClass:[MadeStepModel class]]){
            height += [MadeStepItemView viewHeightWithContent:model];
        }
    }
    
    return height+10.0f;
}


@end
