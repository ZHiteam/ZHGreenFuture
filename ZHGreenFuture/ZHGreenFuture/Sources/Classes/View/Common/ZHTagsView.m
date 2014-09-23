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
#define TAG_START   -1024

@interface ZHTagsView()
@property (nonatomic,assign) NSInteger      selectedIndex;
@property (nonatomic,strong) NSArray*       tagArrays;
@end;

@implementation ZHTagsView

- (id)initWithFrame:(CGRect)frame tags:(NSArray *)tags
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndex = TAG_START-1;
        [self loadContentWithTags:tags];

    }
    return self;
}

-(void)loadContentWithTags:(NSArray*)tags{
    if ( 0 == tags.count){
        return;
    }
    
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:tags.count];
    
    CGFloat xOffset = SIDE_SPAN;
    CGFloat yOffset = ITEM_SPAN;
    for(int i = 0; i < tags.count ;++i){
        TagModel* val = tags[i];
        if (![val isKindOfClass:[TagModel class]]){
            continue;
        }
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + TAG_START;
        [btn setTitle:val.tagName forState:UIControlStateNormal];
        if (btn.tag == self.selectedIndex){
            [btn setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage createImageWithColor:WHITE_BACKGROUND] forState:UIControlStateHighlighted];
            
            [btn setTitleColor:WHITE_BACKGROUND forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage createImageWithColor:GREEN_COLOR] forState:UIControlStateNormal];
        }
        else{
            [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage createImageWithColor:WHITE_BACKGROUND] forState:UIControlStateNormal];
            
            [btn setTitleColor:WHITE_BACKGROUND forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage createImageWithColor:GREEN_COLOR] forState:UIControlStateHighlighted];
        }
        
        
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = FONT(12);
        btn.layer.borderColor = GREEN_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        

        
        CGSize size = [val.tagName sizeWithFont:btn.titleLabel.font];
        size.width += ITEM_SPAN*2;
        
        if (xOffset + size.width > self.width-SIDE_SPAN){
            xOffset = SIDE_SPAN;
            yOffset += ITEM_HEIGHT+SIDE_SPAN;
        }
        
        btn.frame = CGRectMake(xOffset, yOffset, size.width, ITEM_HEIGHT);
        xOffset += btn.width+ITEM_SPAN;
        
        [array addObject:btn];
        [self addSubview:btn];
    }
    
    self.tagArrays = [NSArray arrayWithArray:tags];
    
    self.height = yOffset + ITEM_HEIGHT;
}

-(void)itemSelected:(UIButton*)sender{
    
    int tag = sender.tag-TAG_START;
    
    if (tag >= self.tagArrays.count){
        return;
    }
    
    if (self.selectedIndex != TAG_START-1) {
        int index = self.selectedIndex - TAG_START;
        if (index >= 0 && index < self.tagArrays.count){
            UIButton* btn = (UIButton*)[self viewWithTag:self.selectedIndex];
            [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage createImageWithColor:WHITE_BACKGROUND] forState:UIControlStateNormal];
            
            [btn setTitleColor:WHITE_BACKGROUND forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage createImageWithColor:GREEN_COLOR] forState:UIControlStateHighlighted];
            
        }
    }
    if (self.selectedIndex != sender.tag){
        [sender setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage createImageWithColor:WHITE_BACKGROUND] forState:UIControlStateHighlighted];
        
        [sender setTitleColor:WHITE_BACKGROUND forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage createImageWithColor:GREEN_COLOR] forState:UIControlStateNormal];
    }
    else{
        
        if ([self.delegate respondsToSelector:@selector(tagSelectWithId:)]){
            [self.delegate tagSelectWithId:@"-1"];
        }
        self.selectedIndex = TAG_START-1;
        return;
    }

    
    self.selectedIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(tagSelectWithId:)]){
        [self.delegate tagSelectWithId:((TagModel*)self.tagArrays[tag]).tagId];
    }
}

@end
