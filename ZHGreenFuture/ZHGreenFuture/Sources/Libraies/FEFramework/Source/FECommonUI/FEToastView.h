//
//  FEToastView.h
//  xxx
//
//  Created by xxx on
//  Copyright (c) 2012 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEToastView : UIView
+ (void)showWithTitle:(NSString*)title animation:(BOOL)animation interval:(CGFloat)interval;
+ (void)showWithTitle:(NSString*)title animation:(BOOL)animation;
+ (void)dismissWithAnimation:(BOOL)animation;
@end
