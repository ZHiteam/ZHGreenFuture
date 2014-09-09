//
//  ZHTagsView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/3/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHTagsView.h"

#define SIDE_SPAN   12
#define ITEM_SPAN   6
#define ITEM_HEIGHT 28

@interface ZHTagsView()

@property (nonatomic,strong) NSMutableArray*    tagArrays;
@property (nonatomic,strong) UILabel*           titleLabel;
@end;

@implementation ZHTagsView

- (id)initWithFrame:(CGRect)frame tags:(NSArray *)tags
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentWithTags:tags];
    }
    return self;
}

-(void)loadContentWithTags:(NSArray*)tags{
    if ( 0 == tags.count){
        return;
    }
    
    [self addSubview:self.titleLabel];
    
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:tags.count];
    
    CGFloat xOffset = SIDE_SPAN;
    CGFloat yOffset = self.titleLabel.height;
    for(TagModel* val in tags){
        if (![val isKindOfClass:[TagModel class]]){
            continue;
        }
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:val.title forState:UIControlStateNormal];
        [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [btn setBackgroundColor:WHITE_BACKGROUND];
        
        btn.titleLabel.font = FONT(12);
        btn.layer.borderColor = GREEN_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        
        CGSize size = [val.title sizeWithFont:btn.titleLabel.font];
        
        btn.frame = CGRectMake(xOffset, yOffset, size.width+ITEM_SPAN, ITEM_HEIGHT);
        
        [array addObject:btn];
    }
    
    self.height = yOffset + ITEM_HEIGHT;
}

-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"大家都在关注：" font:FONT(12) color:RGB(0x77, 0x77, 0x77) textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(SIDE_SPAN, 0, self.width-SIDE_SPAN, 30);
    }
    return _titleLabel;
}

@end
