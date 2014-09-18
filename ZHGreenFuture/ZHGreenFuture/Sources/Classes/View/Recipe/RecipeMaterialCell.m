//
//  MaterialView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeMaterialCell.h"
#import "MaterialItemView.h"

#define ITEM_HEIGHT     40

@interface RecipeMaterialCell()
@property (nonatomic,strong) UILabel*       titleLabel;
@property (nonatomic,strong) UIView*        materialContent;

@property (nonatomic,strong) NSMutableArray*    materialItems;

@end

@implementation RecipeMaterialCell

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
    
    [self addSubview:self.materialContent];
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"用料" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 0, self.width-5, 25);
        
        _titleLabel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _titleLabel;
}

-(UIView *)materialContent{
    
    if (!_materialContent){
        _materialContent = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, self.width, self.height-self.titleLabel.bottom)];
    }
    
    return _materialContent;
}

#pragma -mark set model
-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model){
        return;
    }
    
    [self.materialContent removeAllSubviews];
    
    if (!self.materialItems){
        self.materialItems = [[NSMutableArray alloc]initWithCapacity:model.material.count];
    }
    
    CGFloat yOffset = 0;
    for (int i = 0;i < model.material.count ; ++i){
        MaterialModel* val = model.material[i];
        if (![val isKindOfClass:[MaterialModel class]]){
            continue;
        }
        
        MaterialItemView* item = nil;
        
        if (self.materialItems.count > i){
            item = self.materialItems[i];
        }
        else{
            item = [[MaterialItemView alloc]initWithFrame:CGRectMake(0, yOffset, self.width, ITEM_HEIGHT)];
            
            [self.materialItems addObject:item];
        }
        
        item.model = val;
        
        yOffset += ITEM_HEIGHT;
        
        [self.materialContent addSubview:item];
    }
    
    self.materialContent.height = yOffset;
    
}

#pragma -mark end

+(CGFloat)viewHeightWithContent:(id)content{
    CGFloat height = 25.0+10.0;
    height += ((NSArray*)content).count*ITEM_HEIGHT;
    return height;
}

@end
