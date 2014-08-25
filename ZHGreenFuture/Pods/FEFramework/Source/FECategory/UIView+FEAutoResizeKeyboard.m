//
//  UIView+FEAutoResizeKeyboard.m
//  FETestCategory
//
//  Created by xxx on 13-9-22.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIView+FEAutoResizeKeyboard.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char willShowKey;
static char willHideKey;

@implementation UIView (FEAutoResizeKeyboard)
- (void)setAutoResizeKeyboard:(BOOL)isAutoResizeKeyboard willShow:(FEAutoResizeKeyboardBlock)willShowBlock willHide:(FEAutoResizeKeyboardBlock)willHideBlock{
    if (isAutoResizeKeyboard) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(keyboardDidShow:)
                                                     name: UIKeyboardWillShowNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(keyboardWillHide:)
                                                     name: UIKeyboardWillHideNotification
                                                   object: nil];
        if (willShowBlock) {
            objc_setAssociatedObject(self, &willShowKey, willShowBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        if (willHideBlock) {
            objc_setAssociatedObject(self, &willHideKey, willHideBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }
}


- (void)keyboardDidShow:(NSNotification*)notification {
    if (self.superview && self.hidden == NO) {
        //UIKeyboardFrameBeginUserInfoKey origin=(x=0, y=480) size=(width=320, height=216)
        //UIKeyboardFrameEndUserInfoKey origin=(x=0, y=264) size=(width=320, height=216)
        CGRect keyBoardFrame=[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self keyboardWillShowWithFrame:keyBoardFrame];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
     if (self.superview && self.hidden == NO)  {
         CGRect keyBoardFrame=[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
         [self keyboardWillHideWithFrame:keyBoardFrame];
    }
}

- (void)keyboardWillShowWithFrame:(CGRect)keyboardFrame {
    FEAutoResizeKeyboardBlock block = objc_getAssociatedObject(self, &willShowKey);
    if (block) {
        block(keyboardFrame);
    }
}

- (void)keyboardWillHideWithFrame:(CGRect)keyboardFrame {
    FEAutoResizeKeyboardBlock block = objc_getAssociatedObject(self, &willHideKey);
    if (block) {
        block(keyboardFrame);
    }
}
@end
