//
//  MadeStepItemView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "MadeStepItemView.h"
#import "VerticallyAlignedLabel.h"

#define IMAGE_WIDTH     184
#define IMAGE_HEIGHT    138

@interface MadeStepItemView()

@property (nonatomic,strong) VerticallyAlignedLabel*   steplabel;
@property (nonatomic,strong) UILabel*   detail;
@property (nonatomic,strong) UIImageView*               imageView;
@end

@implementation MadeStepItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
    }
    return self;
}

-(void)loadContent{
    self.backgroundColor = WHITE_BACKGROUND;
    [self addSubview:self.steplabel];
    [self addSubview:self.detail];
    [self addSubview:self.imageView];
}

-(UILabel *)steplabel{
    
    if (!_steplabel){
        _steplabel = [[VerticallyAlignedLabel alloc]init];
        _steplabel.font = FONT(24);
        _steplabel.textAlignment = NSTextAlignmentCenter;
        _steplabel.textColor = BLACK_TEXT;
        _steplabel.verticalAlignment = VerticalAlignmentTop;

        _steplabel.frame = CGRectMake(0, 5, STEP_LEFT_SPAN, STEP_LEFT_SPAN);
    }
    
    return _steplabel;
}

-(UILabel *)detail{
    
    if (!_detail){
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(STEP_LEFT_SPAN, 5, self.width-STEP_LEFT_SPAN-10, STEP_LEFT_SPAN)];
        _detail.textColor = [UIColor darkGrayColor];
        _detail.textAlignment = NSTextAlignmentLeft;
        _detail.numberOfLines = 0;
        _detail.font = FONT(16);
    }
    
    return _detail;
}

-(UIImageView *)imageView{
    
    if (!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STEP_LEFT_SPAN, self.detail.bottom, IMAGE_WIDTH, IMAGE_HEIGHT)];
        _imageView.hidden = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

-(void)setModel:(MadeStepModel*)model index:(NSInteger)index{
    self.steplabel.text = [NSString stringWithFormat:@"%d",index];
    
    _detail.text = model.title;
    
    CGSize size = [model.title sizeWithFont:FONT(16)
                         constrainedToSize:CGSizeMake(FULL_WIDTH -STEP_LEFT_SPAN-10, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    _detail.height = size.height;
    
    if (!isEmptyString(model.imageUrl)){
        
        _imageView.top = _detail.bottom;
        
        [_imageView setImageWithUrlString:model.imageUrl placeHodlerImage:nil];
        
        _imageView.hidden = NO;
    }
    else{
        _imageView.hidden = YES;
    }
    
    self.height = [MadeStepItemView viewHeightWithContent:model];
}

+(CGFloat)viewHeightWithContent:(MadeStepModel *)made{
    CGFloat height = STEP_LEFT_SPAN+5;
    
    if (!isEmptyString(made.title)){
        CGSize size = [made.title sizeWithFont:FONT(16)
                          constrainedToSize:CGSizeMake(FULL_WIDTH -STEP_LEFT_SPAN-10, MAXFLOAT)
                              lineBreakMode:NSLineBreakByWordWrapping];
        
        if (size.height > STEP_LEFT_SPAN){
            height = size.height+5;
        }
    }
    
    if (!isEmptyString(made.imageUrl)){
        height += IMAGE_HEIGHT;
    }
    
    return height+STEP_BOTTOM_SPAN;
}
@end
