//
//  ZHButton.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHButton.h"
@interface ZHButton()
@property(nonatomic, copy)ZHButtonClickedBlock block;
@end

@implementation ZHButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method
+(instancetype)buttonWithType:(ZHButtonType)type text:(NSString*)text clickedBlock:(ZHButtonClickedBlock)block{
    ZHButton *button = [ZHButton buttonWithType:UIButtonTypeCustom];
    button.block = block;
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2.0;
    button.layer.borderWidth  = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.backgroundColor = [UIColor clearColor];
    switch (type) {
        case ZHButtonTypeDefault:
            [button defaultStyle];
            break;
        case ZHButtonTypeStyle1:
            [button setStyle1];
            break;
        default:
            break;
    }
    return button;
}

#pragma mark - Event Handler
- (void)buttonPressed:(UIButton*)button{
    if (self.block) {
        self.block(self);
    }
}

#pragma mark - Privte Method
- (void)defaultStyle{
    self.layer.borderColor = RGB(85, 85, 85).CGColor;
    [self setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
}

- (void)setStyle1{
    self.layer.borderColor = RGB(102, 170, 0).CGColor;
    [self setTitleColor:RGB(102, 170, 0) forState:UIControlStateNormal];
}

@end
