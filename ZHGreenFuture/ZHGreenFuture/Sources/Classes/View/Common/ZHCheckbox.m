//
//  ZHCheckbox.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCheckbox.h"

@interface ZHCheckbox()


@end

@implementation ZHCheckbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_unselected"] forState:UIControlStateNormal];
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_selected"] forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setChecked:(BOOL)checked{

//    self.selected = !checked;
    
    [self checkAction:checked];
}

-(BOOL)checked{
    return self.selected;
}

-(void)setCheckState:(BOOL)checkState{
    self.selected = checkState;
    
    if (self.selected){
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_unselected"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_selected"] forState:UIControlStateNormal];
    }
    else{
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_unselected"] forState:UIControlStateNormal];
        [self setImage:[UIImage themeImageNamed:@"btn_checkbox_selected"] forState:UIControlStateHighlighted];
    }
    
}

-(void)checkAction:(BOOL)check{
    
    [self setCheckState:check];
    
    if (self.checkBlock){
        self.checkBlock(check);
    }
}

-(void)checkAction{
    self.selected = !self.selected;
    [self checkAction:self.selected];
}
@end
