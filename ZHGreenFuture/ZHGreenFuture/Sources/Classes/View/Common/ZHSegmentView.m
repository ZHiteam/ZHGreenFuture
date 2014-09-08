//
//  ZHSegmentView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHSegmentView.h"


@implementation ZHSegmentView

- (id)initWithFrame:(CGRect)frame segments:(NSArray *)segments
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentWithItems:segments];
        
        self.layer.borderColor = GREEN_COLOR.CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)setSegmentItems:(NSArray*)segments{
    self.layer.borderColor = GREEN_COLOR.CGColor;
    self.layer.borderWidth = 1;
    [self loadContentWithItems:segments];
    
}

-(void)loadContentWithItems:(NSArray*)items{
    if (items.count <= 0){
        return;
    }
    
    CGFloat width = self.width/items.count;
    CGFloat xOffset = 0;
    for (int i = 0 ; i < items.count ;++i){
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = SEGMENT_TAG_START+i;
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(xOffset, 0, width, self.height);
        btn.titleLabel.font = FONT(14);
        
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        xOffset += width;

        if (0 != i){
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.height)];
            line.backgroundColor = GREEN_COLOR;
            [btn addSubview:line];
        }
        
        [self addSubview:btn];
    }
    
    [self selectAtIndex:0];
}

-(void)selectAtIndex:(NSInteger)index{
    UIButton* pre = (UIButton*)[self viewWithTag:self.selectedIndex+SEGMENT_TAG_START];
    [pre setTitleColor:WHITE_BACKGROUND forState:UIControlStateNormal];
    [pre setBackgroundColor:GREEN_COLOR];

}

-(void)itemSelected:(id)sender{
    if (![sender isKindOfClass:[UIButton class]]){
        return;
    }
    
    UIButton* cur = (UIButton*)sender;
    
    if ((cur.tag-SEGMENT_TAG_START) == self.selectedIndex){
        return;
    }
    
    UIButton* pre = (UIButton*)[self viewWithTag:self.selectedIndex+SEGMENT_TAG_START];
    
    [self performAnimationWithCur:pre nextItem:cur];
    
    self.selectedIndex = cur.tag-SEGMENT_TAG_START;
    
    if ([self.segmentDelegate respondsToSelector:@selector(segment:selectAtIndex:)]){
        [self.segmentDelegate segment:self selectAtIndex:self.selectedIndex];
    }
}

-(void)performAnimationWithCur:(UIButton*)curSelectItem nextItem:(UIButton*)next{
    [curSelectItem setBackgroundColor:WHITE_BACKGROUND];
    [curSelectItem setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    
    [next setBackgroundColor:GREEN_COLOR];
    [next setTitleColor:WHITE_BACKGROUND forState:UIControlStateNormal];
}
@end
