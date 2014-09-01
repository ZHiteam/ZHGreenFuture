//
//  ZHSwipSegment.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHSwipSegment.h"

#define SEGMENT_ITEM_WIDTH   70

@interface ZHSwipSegment()

@property (nonatomic,strong)UIView*         selectedSign;
@end

@implementation ZHSwipSegment

-(id)initWithFrame:(CGRect)frame segments:(NSArray *)segments{
    self = [super initWithFrame:frame];
    
    if (self){
        [self loadContentWithItems:segments];
    }
    
    return self;
}

-(void)loadContentWithItems:(NSArray*)items{
    self.backgroundColor = [UIColor clearColor];
    
    if (items.count == 0){
        return;
    }
    
    CGFloat xOffset = 0;
    
    for (int i = 0 ; i < items.count; ++i){
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, 0, SEGMENT_ITEM_WIDTH, self.height)];
        
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT(14);
        btn.tag = SEGMENT_TAG_START+i;
        
        xOffset += SEGMENT_ITEM_WIDTH;
        
        [self addSubview:btn];
    }
    
    self.contentSize = CGSizeMake(SEGMENT_ITEM_WIDTH*items.count, self.height);
    self.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.selectedSign];
}

-(UIView *)selectedSign{
    if (!_selectedSign){
        _selectedSign = [[UIView alloc]initWithFrame:CGRectMake(12, self.height-3, SEGMENT_ITEM_WIDTH-24, 3)];
        
        _selectedSign.backgroundColor = GREEN_COLOR;
    }
    
    return _selectedSign;
}

-(void)performAnimationWithCur:(UIButton *)curSelectItem nextItem:(UIButton *)next{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectedSign.left = next.left+12;
        
        if (next.right > self.width){
            [self setContentOffset: CGPointMake(next.right-self.width,0)];
        }
        else if (next.left < self.contentOffset.x){
            [self setContentOffset: CGPointMake(next.left,0)];
        }
    }];
}

@end
