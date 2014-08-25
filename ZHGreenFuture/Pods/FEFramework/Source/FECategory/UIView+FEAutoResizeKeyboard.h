//
//  UIView+FEAutoResizeKeyboard.h
//  FETestCategory
//
//  Created by xxx on 13-9-22.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FEAutoResizeKeyboardBlock)(CGRect keyboardFrame);
@interface UIView (FEAutoResizeKeyboard)
//在dealloc中，最好调用[[NSNotificationCenter defaultCenter] removeObserver];
/**
	当弹出键盘时，自动调整位置，使焦点在屏幕范围内
	@param isAutoResizeKeyboard 表示允许自动调整位置，必须为YES
	@param willShowBlock 键盘将要弹出的block
	@param willHideBlock 键盘将要消失的block
 */
- (void)setAutoResizeKeyboard:(BOOL)isAutoResizeKeyboard willShow:(FEAutoResizeKeyboardBlock)willShowBlock willHide:(FEAutoResizeKeyboardBlock)willHideBlock;


//例子一：UIView使用
/*
 __weak UIView* weakView = self.view;
 CGRect origin = self.view.frame;
 // Do any additional setup after loading the view, typically from a nib.
 [self.view setAutoResizeKeyboard:YES
 willShow:^(CGRect keyboardFrame) {
 [UIView animateWithDuration:0.3 animations:^{
 CGRect frame   = weakView.frame;
 frame.origin.y -= keyboardFrame.size.height;
 weakView.frame = frame;
 }];}
 willHide:^(CGRect keyboardFrame) {
 [UIView animateWithDuration:0.3 animations:^{
 weakView.frame = origin;}];
 }];
 */

//例子二：UITableView，通过block实现；另外也可以包含 UITableView (FEAutoResizeKeyboard)，然后调用[_tableView setAutoResizeKeyboard:YES willShow:nil willHide:nil];使用
/*
 __weak UIView* weakTableView = _tableView;
 CGRect origin = _tableView.frame;
 [_tableView setAutoResizeKeyboard:YES willShow:^(CGRect keyboardFrame) {
 CGRect frame = weakTableView.frame;
 frame.size.height -=keyboardFrame.size.height;
 weakTableView.frame = frame;
 UIView* firstView = [weakTableView firstResponder];
 UITableViewCell* cell = (UITableViewCell*)[firstView ancestorOrSelfWithClass:[UITableViewCell class]];
 NSIndexPath* indexPath = [(UITableView*)weakTableView indexPathForRowAtPoint:cell.center];
 if (indexPath) {
 [(UITableView*)weakTableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
 }
 } willHide:^(CGRect keyboardFrame) {
 weakTableView.frame = origin;
 }];
 */
@end
