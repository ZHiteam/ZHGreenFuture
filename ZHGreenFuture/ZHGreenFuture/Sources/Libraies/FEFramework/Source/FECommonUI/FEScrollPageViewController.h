//
//  FEScrollPageViewController.h
//  xxx
//
//  Created by xxx on 14-6-1.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@class FEScrollPageViewController;

#pragma mark dataSource
@protocol FEScrollPageViewControllerDataSource <NSObject>
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfTabsInSection:(NSUInteger)section;
- (UIView *)tabViewAtSection:(NSUInteger)section tabIndex:(NSUInteger)index;
@optional
- (UIViewController *)contentViewControllerForTabAtSection:(NSUInteger)section index:(NSUInteger)index;
@end

#pragma mark delegate
@protocol FEScrollPageViewControllerDelegate <NSObject>
- (void)viewPage:(FEScrollPageViewController *)viewPager didChangeTabToSection:(NSUInteger)section index:(NSUInteger)index contentVC:(UIViewController*)contentVC;
@end

/**
 *  类似ICViewPager的控件是单滚动轴的，这里本想支持多个滚动轴，但是支持多个滚轴以后不知道用哪个VC，只能用单个VC。
 *  当然你也可以把他做但滚轴来使用。
 */
@interface FEScrollPageViewController : UIViewController
@property(nonatomic, weak) id<FEScrollPageViewControllerDataSource> dataSource;
@property(nonatomic, weak) id<FEScrollPageViewControllerDelegate> delegate;
@property(nonatomic, assign)NSInteger  tabHeight;     //default 44
@property(nonatomic, assign)NSInteger  tabItemWidth;  //default 100
@property(nonatomic, readonly)UIViewController *visibleViewController;
- (void)reloadData;
@end
