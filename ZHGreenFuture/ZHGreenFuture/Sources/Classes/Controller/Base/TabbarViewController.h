//
//  TabbarViewController.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "ZHViewController.h"
#import "TabbarView.h"

@protocol TabbarControllerDelegate;

@interface TabbarViewController : ZHViewController<TabbarDataSource,TabbarDelegate>

@property (nonatomic, assign) id<TabbarControllerDelegate>  dataSource;
@property (nonatomic, assign) id<TabbarDelegate>    delegate;

/**
 * 手动设置当前tabbar
 */
-(void)selectAtIndex:(NSUInteger)aIndex animation:(BOOL)animation;

/**
 * bar高度
 */
-(CGFloat)tabbarHeight;

/**
 * 重新加载数据
 */
-(void)reloadData;

/**
 * 获取当前选中ViewController
 */
-(ZHViewController*)currentViewController;

/**
 * 当前选中索引
 */
-(NSInteger)currentSelectedIndex;
@end


@protocol TabbarControllerDelegate <TabbarDataSource,TabbarDelegate>

-(ZHViewController*)tabbarCtl:(TabbarViewController*)tabbarCtl viewControllerAtIndex:(NSUInteger)aIndex;
@end