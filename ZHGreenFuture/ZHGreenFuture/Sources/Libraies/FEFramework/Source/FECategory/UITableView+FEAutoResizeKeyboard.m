//
//  UITableView+FEAutoResizeKeyboard.m
//  FETestCategory
//
//  Created by xxx on 13-9-23.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UITableView+FEAutoResizeKeyboard.h"
#import "UIView+FEHierarchy.h"

static CGRect originRect ;
@implementation UITableView (FEAutoResizeKeyboard)

- (void)keyboardWillShowWithFrame:(CGRect)keyboardFrame {
    UITableView* weakTableView = self;
    originRect = weakTableView.frame;
    CGRect frame = originRect;
    frame.size.height -=keyboardFrame.size.height;
    weakTableView.frame = frame;
    
    UIView* firstView = [weakTableView firstResponder];
    UITableViewCell* cell = (UITableViewCell*)[firstView ancestorOrSelfWithClass:[UITableViewCell class]];
    NSIndexPath* indexPath = [(UITableView*)weakTableView indexPathForRowAtPoint:cell.center];
    if (indexPath) {
        [(UITableView*)weakTableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)keyboardWillHideWithFrame:(CGRect)keyboardFrame {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = originRect;}];
}

@end
