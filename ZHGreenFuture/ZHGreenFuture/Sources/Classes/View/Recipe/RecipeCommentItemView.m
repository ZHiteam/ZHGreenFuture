//
//  RecipeCommentItemView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecipeCommentItemView.h"
#define ITEM_HEIGHT 55

@interface RecipeCommentItemView()

@property (nonatomic,strong)    UIImageView*    avstar;
@property (nonatomic,strong)    UILabel*        name;
@property (nonatomic,strong)    UILabel*        date;
@property (nonatomic,strong)    UILabel*        content;
@end

@implementation RecipeCommentItemView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.frame = CGRectMake(0, 0, FULL_WIDTH, ITEM_HEIGHT);
        [self loadContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)loadContent{
    
    self.backgroundColor = WHITE_BACKGROUND;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.width-20, 1)];
    line.backgroundColor = GRAY_LINE;
    line.tag = -110;
    
    [self addSubview:line];
    [self addSubview:self.avstar];
    [self addSubview:self.name];
    [self addSubview:self.content];
    [self addSubview:self.date];
}

-(UIImageView *)avstar{
    
    if (!_avstar){
        _avstar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _avstar.layer.masksToBounds = YES;
        _avstar.layer.cornerRadius = 15.0;
        _avstar.layer.borderColor = GRAY_LINE.CGColor;
        _avstar.layer.borderWidth = 0.5;
        
        _avstar.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _avstar;
}

-(UILabel *)name{
    if (!_name){
        _name = [UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        _name.frame = CGRectMake(self.avstar.right+3, self.avstar.top, 100, 20);
    }
    return _name;
}

-(UILabel *)content{
    
    if (!_content){
        _content = [[UILabel alloc]initWithFrame:CGRectMake(self.avstar.right+3, self.name.bottom+3, self.width-self.avstar.right-10, 20)];
        _content.font = FONT(14);
        _content.textColor = [UIColor grayColor];
    }
    return _content;
}

-(UILabel *)date{
    
    if (!_date){
        _date = [UILabel labelWithText:@"" font:FONT(12) color:[UIColor grayColor] textAlignment:NSTextAlignmentRight];
        _date.frame = CGRectMake(0, self.name.top, self.width-10, 20);
    }
    
    return _date;
}

-(void)setModel:(CommentModel *)model{
    if (!model){
        return;
    }
    
    [self.avstar setImageWithUrlString:model.userAvatarURL];
    self.name.text = model.userName;
    self.content.text = model.contenet;
    self.date.text = model.comment_date;
}
+(CGFloat)itemHeight{
    return ITEM_HEIGHT;
}

-(void)setLineTop:(BOOL)lineTop{
    if (!lineTop){
        UIView* line = [self viewWithTag:-110];
        line.bottom = self.height;
    }
}
@end
