//
//  FESidePanelController.h
//  FETestSidePanel
//
//  Created by xxx on 13-11-21.
//  Copyright (c) 2013年 xxx All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEViewTranslate.h"

typedef NS_ENUM(NSInteger,FESidePanelType){
    FESidePanelLeft,
    FESidePanelCenter,
    FESidePanelRight,
};

//you can user delegate OR notification to observe viewcontroller appear or disappear status
@class FESidePanelController;
@protocol FESidePanelControllerDelegate <NSObject>
@optional
- (void)sidePanelController:(FESidePanelController*)sidePanelController willShowController:(UIViewController*)controller;
- (void)sidePanelController:(FESidePanelController*)sidePanelController didShowController:(UIViewController*)controller;
- (void)sidePanelController:(FESidePanelController*)sidePanelController willDismissController:(UIViewController*)controller;
- (void)sidePanelController:(FESidePanelController*)sidePanelController didDismissController:(UIViewController*)controller;
@end

extern NSString * const FESidePanelControllerLeftWillAppear;
extern NSString * const FESidePanelControllerLeftDidAppear;
extern NSString * const FESidePanelControllerLeftWillDisappear;
extern NSString * const FESidePanelControllerLeftDidDisappear;
extern NSString * const FESidePanelControllerRightWillAppear;
extern NSString * const FESidePanelControllerRightDidAppear;
extern NSString * const FESidePanelControllerRightWillDisappear;
extern NSString * const FESidePanelControllerRightDidDisappear;
extern NSString * const FESidePanelControllerCenterWillAppear;
extern NSString * const FESidePanelControllerCenterDidAppear;
extern NSString * const FESidePanelControllerCenterWillDisappear;
extern NSString * const FESidePanelControllerCenterDidDisappear;

@interface FESidePanelController : UIViewController

@property (nonatomic, strong) UIViewController *leftPanel;   // optional
@property (nonatomic, strong) UIViewController *centerPanel; // required
@property (nonatomic, strong) UIViewController *rightPanel;  // optional
@property (nonatomic, assign) BOOL              isEnableShadow;
@property (nonatomic, assign)FETranslateAnimationType translateType;
@property (nonatomic, readonly)UIView           *containerView;
@property (nonatomic, readonly)UIView           *centerView;
@property (nonatomic, readonly)FESidePanelType   visibleSide;
@property (nonatomic, assign) BOOL              isEnableGesture;//是否允许滑动手势切换,默认不允许

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;

// show the panels
- (void)showLeftPanelAnimated:(BOOL)animated;
- (void)showRightPanelAnimated:(BOOL)animated;
- (void)showCenterPanelAnimated:(BOOL)animated;

//  delegate
- (void)setDelegate:(id<FESidePanelControllerDelegate>) delegate;

@end

#pragma mark - UIViewController Category
@interface UIViewController (FESidePanel)
@property (nonatomic, weak, readonly) FESidePanelController *sidePanelController;
@end

