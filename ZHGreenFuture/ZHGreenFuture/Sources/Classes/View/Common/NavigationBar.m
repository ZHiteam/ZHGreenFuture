//
//  NavigationBar.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "NavigationBar.h"
#import "NavigationViewController.h"
#import "UIControl+ZHitem.h"

#define BAR_ITEM_WIDTH  44.0f
#define BAR_ITEM_SPAN   5.0f

#define RIGHT_BAR_ITEM_SPAN 7.0f

@interface NavigationBar(){
    UIImageView*    _backgroundView;
    UILabel*        _titleLabel;
    
    UIImageView*    _rightButtonFlag;
    
    UIImageView*    _leftSpan;
    UIImageView*    _rightSpan;
}
@end

@implementation NavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(102, 170, 0);
        _backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, self.width, NAVIGATION_ITEM_HEIGHT)];
//        _backgroundView.image = [UIImage themeImageNamed:@"navigation_bar_bg.png"];
        [self addSubview:_backgroundView];
        
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        line.backgroundColor = RGB(176, 176, 176);
        [self addSubview:line];
    }
    return self;
}

-(void)_initTitleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" font:FONT(18.0f) color:RGB(0xFF, 0xFF, 0xFF) textAlignment:NSTextAlignmentCenter];
        _titleLabel.frame = CGRectMake(0, STATUS_BAR_HEIGHT, self.width-2*BAR_ITEM_WIDTH, NAVIGATION_ITEM_HEIGHT);
        _titleLabel.centerX = self.centerX-self.top;
    }
    
    if (_titleLabel.superview != self) {
        [self addSubview:_titleLabel];
    }

}

-(void)setTitle:(NSString *)title{
    [self _initTitleLabel];
    
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    _title = title;
    _titleLabel.text = title;
}

-(void)setTitleView:(UIView *)titleView{
    if (!titleView || titleView == _titleView) {
        return;
    }
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    
    _titleView = titleView;
    _titleView.frame = CGRectMake((self.width-_titleView.width)/2, ((self.height-STATUS_BAR_HEIGHT)-_titleView.height)/2+STATUS_BAR_HEIGHT, _titleView.width, _titleView.height);
    
    [self addSubview:_titleView];
    
    [self _adjustBar];
}

-(void)setLeftBarItem:(UIView *)leftBarItem{
    
    if (!leftBarItem) {
        return;
    }
    
    if (!_leftSpan) {
        _leftSpan = [[UIImageView alloc]initWithImage:[UIImage themeImageNamed:@"navigation_title_span"]];
        _leftSpan.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 2, NAVIGATION_ITEM_HEIGHT);
        [self addSubview:_leftSpan];
    }
    
    _leftBarItem = leftBarItem;
    _leftBarItem.left = BAR_ITEM_SPAN;
    
    _leftSpan.left = _leftBarItem.right;
    
    [self addSubview:_leftBarItem];
    
    [self _adjustBar];
}

-(void)setRightBarItem:(UIView *)rightBarItem{
    
    if (!rightBarItem) {
        return;
    }
    
    if (!_rightSpan) {
        _rightSpan = [[UIImageView alloc]initWithImage:[UIImage themeImageNamed:@"navigation_title_span"]];
        _rightSpan.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 2, NAVIGATION_ITEM_HEIGHT);
        [self addSubview:_rightSpan];
    }
    
    _rightBarItem = rightBarItem;
    _rightBarItem.right = FULL_WIDTH-BAR_ITEM_SPAN;
    _rightBarItem.top = STATUS_BAR_HEIGHT;
    
    _rightSpan.right = _rightBarItem.left;
    
    [self addSubview:_rightBarItem];
    
    [self _adjustBar];
}

-(void)_adjustBar{
    if (_leftBarItem) {
        _titleView.left = _leftBarItem.width+BAR_ITEM_SPAN;
        _titleView.width = FULL_WIDTH-BAR_ITEM_SPAN-_leftBarItem.width;
    }
    
    if (_rightBarItem) {
        _titleView.width -= _rightBarItem.width+BAR_ITEM_SPAN;
    }
}

@end

@implementation UIButton(NavigationBar)

+(UIButton*)backBarItem{
    UIButton* btn = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_back"] action:nil selector:nil];
    btn.frame = CGRectMake(0, STATUS_BAR_HEIGHT, NAVIGATION_ITEM_HEIGHT,NAVIGATION_ITEM_HEIGHT);
    return btn;
}

+(UIButton*)barItemWithTitle:(NSString*)title action:(id)action selector:(SEL)selector{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = FONT(12.0f);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    UIImage* image = [UIImage themeImageNamed:@"btn_bg_baritem"];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:action action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [title sizeWithFont:button.titleLabel.font].width+BAR_ITEM_SPAN;
    
    if (width < image.size.width) {
        width = image.size.width;
    }
    
    button.frame = CGRectMake(0, STATUS_BAR_HEIGHT, width, NAVIGATION_ITEM_HEIGHT);
    
    return button;
}

+(UIButton*)barItemWithTitle:(NSString*)title image:(UIImage*)image action:(id)action selector:(SEL)selector{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = FONT(12.0f);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:action action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [title sizeWithFont:button.titleLabel.font].width+BAR_ITEM_SPAN;
    
    if (width < image.size.width) {
        width = image.size.width;
    }
    
    button.frame = CGRectMake(0, STATUS_BAR_HEIGHT, width, NAVIGATION_ITEM_HEIGHT);
    
    return button;
}

+(UIControl *)rightBarItemWithTitle:(NSString *)title image:(UIImage *)image action:(id)action selector:(SEL)selector{
    
    CGFloat width = [title sizeWithFont:FONT(12.0f)].width+RIGHT_BAR_ITEM_SPAN*2;
    
    if (width < image.size.width) {
        width = image.size.width+RIGHT_BAR_ITEM_SPAN*2;
    }
    
    UIControl* btn = [[UIControl alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, width+RIGHT_BAR_ITEM_SPAN*2, NAVIGATION_ITEM_HEIGHT)];
    
    /// 添加image
    if (image) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(RIGHT_BAR_ITEM_SPAN, 0, width, NAVIGATION_ITEM_HEIGHT)];
        imageView.image = image;
        [btn addSubview:imageView];        
    }
    
    /// 添加label
    if (!isEmptyString(title)) {
        UILabel* label = [UILabel labelWithText:title font:FONT(13.0f) color:WHITE_TEXT textAlignment:NSTextAlignmentCenter];
        label.frame = btn.bounds;
        [btn addSubview:label];
    }
    
    UIImageView* separator = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 7, 2, NAVIGATION_ITEM_HEIGHT-14)];
    separator.image = [UIImage themeImageNamed:@"navigation_bar_separator"];
    
    [btn addSubview:separator];
    
    return btn;
}

+(UIButton*)searchButton{
    UIButton* btn = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_search"] action:nil selector:nil];
    [btn setTouchUpInsideBlock:^(UIControl *ctl) {
//        [SearchViewController showSearchView];
    }];
    return btn;
}
@end
