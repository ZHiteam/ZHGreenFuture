//
//  UITableView+FEAutoResizeKeyboard.h
//  FETestCategory
//
//  Created by xxx on 13-9-23.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FEAutoResizeKeyboard)
//例子
/*
  [_tableView setAutoResizeKeyboard:YES willShow:nil willHide:nil];
 */

//该类别中实现UIView (FEAutoResizeKeyboard) 类别中会调用的keyboardWillShowWithFrame和keyboardWillHideWithFrame方法，这样就不需要通过block实现
//setAutoResizeKeyboard:willShow:willHide: 为基类UIView的类别UIView (FEAutoResizeKeyboard)中的方法
@end
