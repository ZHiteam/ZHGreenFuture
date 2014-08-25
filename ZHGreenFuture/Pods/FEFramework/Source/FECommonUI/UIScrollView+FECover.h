//
//  UIScrollView+FECover.h
//
//
//  Created by xxx on 14-5-25.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

#define FECoverViewHeight 160

@interface UIScrollView (FECover)
- (void)addCoverWithImage:(UIImage*)image;
- (void)addCoverWithImage:(UIImage*)image withTopView:(UIView*)topView;
- (void)addCoverWithImage:(UIImage*)image withTopView:(UIView*)topView aboveView:(UIView*)aboveView enableBlur:(BOOL)isEnableBlur;
- (void)removeCoverView;
@end




