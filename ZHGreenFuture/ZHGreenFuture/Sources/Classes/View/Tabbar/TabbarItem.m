//
//  TabbarItem.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "TabbarItem.h"

@interface TabbarItem(){
    UILabel*        _titleLabel;
    UILabel*        _subTitleLabel;
}

-(void)loadItem;
@end

@implementation TabbarItem

-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)subTitle{
    if ((self = [self initWithFrame:frame])) {
        self.title = title;
        self.subTitle = subTitle;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadItem];
    }
    return self;
}

-(void)loadItem{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" font:FONT(16.0f) color:RGB(255, 255, 255) textAlignment:NSTextAlignmentCenter];
        _titleLabel.frame = CGRectMake(0, 7, self.width, 20.0f);
        
        [self addSubview:_titleLabel];
    }
    
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelWithText:@"" font:FONT(10.0f) color:RGB(166, 166, 166) textAlignment:NSTextAlignmentCenter];
        _subTitleLabel.frame = CGRectMake(0, _titleLabel.bottom-2, self.width, 12.0f);
        
        [self addSubview:_subTitleLabel];
    }
}

#pragma -setter
-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

-(void)setSubTitle:(NSString *)subTitle{
    _subTitleLabel.text = subTitle;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _titleLabel.frame = CGRectMake(0, 7, self.width, 20.0f);
    _subTitleLabel.frame = CGRectMake(0, _titleLabel.bottom-2, self.width, 12.0f);
    
}

@end
