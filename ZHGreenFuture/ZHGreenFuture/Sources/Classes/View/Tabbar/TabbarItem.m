//
//  TabbarItem.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "TabbarItem.h"

@interface TabbarItem(){
//    UILabel*        _titleLabel;
    UIImageView*        _showImageView;
}

-(void)loadItem;
@end

@implementation TabbarItem
-(id)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    self = [self initWithFrame:frame];
    
    if (self) {
        
        self.selectedImage = selectedImage;
        self.defaultImage = image;

        _showImageView.image = self.defaultImage;
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
    
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        [self addSubview:_showImageView];
    }
}

#pragma -setter

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _showImageView.frame = self.bounds;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        _showImageView.image = self.selectedImage;
    }
    else{
        _showImageView.image = self.defaultImage;
    }
}

@end
