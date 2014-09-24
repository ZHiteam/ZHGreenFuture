//
//  RecipeCommentCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeCommentCell.h"
#import "RecipeCommentItemView.h"

#define ITEM_HEIGHT     [RecipeCommentItemView itemHeight]

@interface RecipeCommentCell()

@property (nonatomic,strong) UILabel*       titleLabel;
@property (nonatomic,strong) NSMutableArray*    commentList;
@property (nonatomic,strong) UIView*        commentView;

@end

@implementation RecipeCommentCell

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
    
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.top, self.width, self.titleLabel.height+10)];
    bg.backgroundColor = WHITE_BACKGROUND;
    bg.left= 0;
    [self addSubview:bg];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.commentView];
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"大家都在说" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(10, 0.0f, self.width-5, 25);
        _titleLabel.backgroundColor = WHITE_BACKGROUND;
    }
    
    return _titleLabel;
}

-(UIView *)commentView{
    
    if (!_commentView){
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom, self.width, self.height-_titleLabel.bottom-10)];
    }
    
    return _commentView;
}

-(void)setModel:(RecipeItemDetailModel *)model{
    if (!model){
        return;
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"大家都在说 (%d)",[model.commentCount intValue]];
    
    if (!self.commentList){
        self.commentList = [[NSMutableArray alloc]initWithCapacity:model.commentList.count];
    }
    
    [self.commentView removeAllSubviews];
    
    int index =0;
    
    CGFloat yOffset = 10.0f;
    for (CommentModel* commentData in model.commentList){
        if (![commentData isKindOfClass:[CommentModel class]]){
            continue;
        }
        RecipeCommentItemView* item =nil;
        if (self.commentList.count > index){
            item = self.commentList[index];
        }
        else{
            item = [[RecipeCommentItemView alloc]initWithFrame:CGRectMake(0, 0, self.width, ITEM_HEIGHT)];
            [self.commentList addObject:item];
        }
        
        item.top = yOffset;
        item.model = commentData;
        
        yOffset += item.height;
        
        [self.commentView addSubview:item];
        
        index++;
    }
    
    CGFloat height = [RecipeCommentCell viewHeightWithContent:model.commentList];
    
    self.commentView.height = height-_titleLabel.bottom-10;
    
    self.height = height;
}

+(CGFloat)viewHeightWithContent:(id)content{
    CGFloat height = 10.0f+25.0f;
    
    height += ITEM_HEIGHT* ((NSArray*)content).count+(((NSArray*)content).count==0?0:5);
    
    return height+10;
}
@end
