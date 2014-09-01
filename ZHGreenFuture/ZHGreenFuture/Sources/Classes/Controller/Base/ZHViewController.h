//
//  HKWFViewController.h
//  Stock4HKWF
//
//  Created by elvis on 13-8-26.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"

///页面动画类型////////////////////////////////////////////////////////////////////////////////////////
typedef enum  {
    ANIMATE_TYPE_HORIZONTAL = 1,    /// 横向
    ANIMATE_TYPE_VERTICAL,          /// 竖向
    ANIMATE_TYPE_NONE,              /// 没动画
    ANIMATE_TYPE_DEFAULT    = ANIMATE_TYPE_HORIZONTAL,
}AnimationType;


@class NavigationViewController;
@interface ZHViewController : UIViewController

@property (nonatomic, assign) BOOL              hasNavitaiongBar;
@property (nonatomic, strong) NavigationBar*    navigationBar;  /// 导航栏
@property (nonatomic, assign) AnimationType     animationType;  /// 页面切换动画

@property (nonatomic, assign) CGRect            viewFrame;
@property (nonatomic, assign) CGRect            contentBounds;

@property (nonatomic, assign) NavigationViewController* navigationCtl; /// 导航器

@property (nonatomic,strong)UISwipeGestureRecognizer *swipeBack;        /// 手势返回
-(NSUInteger)interfaceOrientations;

-(void)whithNavigationBarStyle;

@end
