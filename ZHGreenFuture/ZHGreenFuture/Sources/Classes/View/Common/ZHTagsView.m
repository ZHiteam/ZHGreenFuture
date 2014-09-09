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

@property (nonatomic,strong) NSArray*    tagArrays;
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
    
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:tags.count];
    
    CGFloat xOffset = SIDE_SPAN;
    CGFloat yOffset = ITEM_SPAN;
    for(int i = 0; i < tags.count ;++i){
        TagModel* val = tags[i];
        if (![val isKindOfClass:[TagModel class]]){
            continue;
        }
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:val.tags forState:UIControlStateNormal];
        [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:WHITE_BACKGROUND] forState:UIControlStateNormal];
        
        [btn setTitleColor:WHITE_BACKGROUND forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage createImageWithColor:GREEN_COLOR] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = FONT(12);
        btn.layer.borderColor = GREEN_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        
        btn.tag = i + TAG_START;
        
        CGSize size = [val.tags sizeWithFont:btn.titleLabel.font];
        size.width += ITEM_SPAN*2;
        
        if (xOffset + size.width > self.width-SIDE_SPAN){
            xOffset = SIDE_SPAN;
            yOffset += ITEM_HEIGHT;
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
    
    ZHLOG(@"tag :\n%@",self.tagArrays[tag]);
    NSString* str = [NSString stringWithFormat:@"tag taped %@",((TagModel*)self.tagArrays[tag]).url];
    ALERT_MESSAGE(str);
}

//
//-(UILabel *)titleLabel{
//    if (!_titleLabel){
//        _titleLabel = [UILabel labelWithText:@"大家都在关注：" font:FONT(12) color:RGB(0x77, 0x77, 0x77) textAlignment:NSTextAlignmentLeft];
//        _titleLabel.frame = CGRectMake(SIDE_SPAN, 0, self.width-SIDE_SPAN, 30);
//    }
//    return _titleLabel;
//}

@end
