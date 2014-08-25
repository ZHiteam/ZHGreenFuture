//
//  FESidePanelController.m
//  FETestSidePanel
//
//  Created by xxx on 13-11-21.
//  Copyright (c) 2013年 xxxx All rights reserved.
//

#import "FESidePanelController.h"
#import <QuartzCore/QuartzCore.h>
#import "FEViewTranslate.h"


#pragma mark - UIViewController Category

@implementation UIViewController (FESidePanel)
- (FESidePanelController *)sidePanelController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[FESidePanelController class]]) {
            return (FESidePanelController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end

#pragma mark - FESidePanelController Imlementation

static const CGFloat kMinDistanceY      = 60.0f;
static const CGFloat kAnimationDuation  = 0.2f;
static const CGFloat kShadowRadius      = 5.0f; 
static const CGFloat kShadowOpacity     = 0.8f;
static const CGFloat kOutsideDivide     = 9.0f;
static const CGFloat kDefaultSidePanelVCWidth = 220;

typedef NS_ENUM(NSInteger,FESidePanelEvent){
    FESidePanelLeftWillAppear,
    FESidePanelLeftDidAppear,
    FESidePanelLeftWillDisappear,
    FESidePanelLeftDidDisappear,
    FESidePanelRightWillAppear,
    FESidePanelRightDidAppear,
    FESidePanelRightWillDisappear,
    FESidePanelRightDidDisappear,
    FESidePanelCenterWillAppear,
    FESidePanelCenterDidAppear,
    FESidePanelCenterWillDisappear,
    FESidePanelCenterDidDisappear,
};

NSString * const FESidePanelControllerLeftWillAppear        = @"FESidePanelControllerLeftWillAppear";
NSString * const FESidePanelControllerLeftDidAppear         = @"FESidePanelControllerLeftDidAppear";
NSString * const FESidePanelControllerLeftWillDisappear     = @"FESidePanelControllerLeftWillDisappear";
NSString * const FESidePanelControllerLeftDidDisappear      = @"FESidePanelControllerLeftDidDisappear";
NSString * const FESidePanelControllerRightWillAppear       = @"FESidePanelControllerRightWillAppear";
NSString * const FESidePanelControllerRightDidAppear        = @"FESidePanelControllerRightDidAppear";
NSString * const FESidePanelControllerRightWillDisappear    = @"FESidePanelControllerRightWillDisappear";
NSString * const FESidePanelControllerRightDidDisappear     = @"FESidePanelControllerRightDidDisappear";
NSString * const FESidePanelControllerCenterWillAppear      = @"FESidePanelControllerCenterWillAppear";
NSString * const FESidePanelControllerCenterDidAppear       = @"FESidePanelControllerCenterDidAppear";
NSString * const FESidePanelControllerCenterWillDisappear   = @"FESidePanelControllerCenterWillDisappear";
NSString * const FESidePanelControllerCenterDidDisappear    = @"FESidePanelControllerCenterDidDisappear";

@interface FESidePanelController ()<UIGestureRecognizerDelegate>{
    struct {
        unsigned int sidePanelControllerWillShowController:1;
        unsigned int sidePanelControllerDidShowController:1;
        unsigned int sidePanelControllerWillDismissController:1;
        unsigned int sidePanelControllerDidDismissController:1;
        unsigned int __reserved__:28;
    }_flag;
    
    UIView                  *_containerView;
    UIView                  *_centerContainer;
    UIView                  *_leftContainer;
    UIView                  *_rightContainer;
    
    FETranslateAnimationType _translateType;
    translateBlock           _translateBlock;
    
    CGFloat                 _leftVisibleWidth;
    CGFloat                 _rightVisibleWidth;
    FESidePanelType         _visibleSide;
    
    UIViewController       *_leftPanel;
    UIViewController       *_centerPanel;
    UIViewController       *_rightPanel;
    BOOL                    _isShowLeft;
    BOOL                    _isShowRight;
    BOOL                    _isEnableShadow;

    UIButton               *_tapMaskButton;
    UIPanGestureRecognizer *_panGesture;
    
    id<FESidePanelControllerDelegate> _delegate;
}
@property (nonatomic, assign) BOOL              isShowLeft;
@property (nonatomic, assign) BOOL              isShowRight;
@end

@implementation FESidePanelController
@synthesize leftPanel   = _leftPanel;
@synthesize centerPanel = _centerPanel;
@synthesize rightPanel  = _rightPanel;
@synthesize isShowLeft  = _isShowLeft;
@synthesize isShowRight = _isShowRight;
@synthesize isEnableShadow = _isEnableShadow;
@synthesize translateType  = _translateType;
@synthesize visibleSide = _visibleSide;

#pragma mark - Life circle

- (id)init{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self baseInit];
    }
    return self;
}

- (void)viewDidLoad{
    //[super viewDidLoad];调用了这个，导致ios7 上_containerView的height为500，奇怪了，FEViewController里也没做啥啊。
	// Do any additional setup after loading the view.

    CGRect rect = self.view.bounds;
    _containerView.frame  = rect;
    _centerContainer.frame= rect;
    _leftContainer.frame  = rect;
    _rightContainer.frame = rect;
    
    [self showCenterPanel:YES];
    
    [_containerView addSubview:_rightContainer];
    [_containerView addSubview:_leftContainer];
    [_containerView addSubview:_centerContainer];
    [self.view addSubview:_containerView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self FEChildViewControllerViewWillAppear:self.centerPanel animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self FEChildViewControllerViewDidAppear:self.centerPanel animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self FEChildViewControllerViewWillDisappear:self.centerPanel animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self FEChildViewControllerViewDidDisappear:self.centerPanel animated:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@">>>sidePanel didReceiveMemoryWarning");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@">>>viewDidUnload");

}

- (void)dealloc{
    [self.tapMaskButton removeFromSuperview];
    self.panGesture.delegate = nil;
    [_containerView removeGestureRecognizer:self.panGesture];
}

#pragma mark - Public Method

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController{
    self = [super init];
    if (self) {
        [self baseInit];
        self.centerPanel = centerViewController;
        self.leftPanel   = leftViewController;
        self.rightPanel  = rightViewController;
        self.isShowLeft  = (leftViewController!=nil);
        self.isShowRight = (rightViewController!=nil);
        _visibleSide = FESidePanelCenter;
        
        [self addChildViewController:centerViewController];
    }
    return self;
}

// show the panels
- (void)showLeftPanelAnimated:(BOOL)animated{
    if (self.isShowLeft){
        [self loadSidePanelWithType:FESidePanelLeft];
        [self translateCenterWithType:FESidePanelLeft
                             animated:^{
                                 if (_translateBlock) {
                                     _translateBlock(self.leftPanel.view ,FETranslateDirectionLeft,_leftVisibleWidth,1.0);
                                 }}
                           completion:^{
                               _visibleSide = FESidePanelLeft;
                           }];
    }
}
- (void)showRightPanelAnimated:(BOOL)animated{
    if (self.isShowRight){
        [self loadSidePanelWithType:FESidePanelRight];
        [self translateCenterWithType:FESidePanelRight
                             animated:^{
                                 if (_translateBlock) {
                                     _translateBlock(self.rightPanel.view ,FETranslateDirectionRight,_rightVisibleWidth,1.0);}}
                           completion:^{
                               _visibleSide = FESidePanelRight;
                           }];
    }
}

- (void)showCenterPanelAnimated:(BOOL)animated{
    [self sendDelegateAndNotification:FESidePanelCenterWillAppear];
    [self translateCenterWithType:FESidePanelCenter animated:^{} completion:^{
        if ([self.centerPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
            [self.centerPanel beginAppearanceTransition:YES animated:NO];
        }
        [self loadSidePanelWithType:FESidePanelCenter];
        _visibleSide = FESidePanelCenter;
        if ([self.centerPanel respondsToSelector:@selector(endAppearanceTransition)]) {
            [self.centerPanel endAppearanceTransition];
        }
        [self sendDelegateAndNotification:FESidePanelCenterDidAppear];
    }];
}

- (void)setDelegate:(id<FESidePanelControllerDelegate>) delegate{
    if (_delegate != delegate){
        _delegate                                       = delegate;
        _flag.sidePanelControllerWillShowController     = [_delegate respondsToSelector:@selector(sidePanelController:willShowController:)];
        _flag.sidePanelControllerDidShowController      = [_delegate respondsToSelector:@selector(sidePanelController:didShowController:)];
        _flag.sidePanelControllerWillDismissController  = [_delegate respondsToSelector:@selector(sidePanelController:willDismissController:)];
        _flag.sidePanelControllerDidDismissController   = [_delegate respondsToSelector:@selector(sidePanelController:didDismissController:)];
    }
}


- (void)setCenterPanel:(UIViewController *)centerPanel{
    if (_centerPanel != centerPanel) {
        _centerPanel = centerPanel;
        [self addChildViewController:_centerPanel];
    }
}

- (void)setLeftPanel:(UIViewController *)leftPanel{
    if (_leftPanel != leftPanel) {
        _leftPanel  = leftPanel;
        self.isShowLeft = (leftPanel != nil);
        //[self businessViewController:self.centerPanel].FEEnableLeftSidePanel = self.isShowLeft;
    }
}

- (void)setRightPanel:(UIViewController *)rightPanel{
    if (_rightPanel != rightPanel) {
        _rightPanel = rightPanel;
        self.isShowRight = (rightPanel != nil);
       // [self businessViewController:self.centerPanel].FEEnableRightSidePanel = self.isShowRight;
    }
}

- (UIView*)containerView{
    return _containerView;
}
- (UIView*)centerView{
    return _centerContainer;
}



#pragma mark - Setter & Getter

- (void)setTranslateType:(FETranslateAnimationType)translateType{
    if (_translateType != translateType){
        _translateType  = translateType;
        _translateBlock = [[FEViewTranslate sharedIntance] translateBlockWithType:_translateType];
    }
}

-(UIButton *)tapMaskButton{
    if (!_tapMaskButton) {
        _tapMaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height)];
        _tapMaskButton.backgroundColor = [UIColor clearColor];
        [_tapMaskButton addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapMaskButton;
}

-(UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_panGesture setDelegate:self];
    }
    return _panGesture;
}

#pragma mark - Pan Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return (self.isShowLeft || self.isShowRight);
    }else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        BOOL isEnable = NO;
        CGPoint point = [gestureRecognizer locationInView:_containerView];
        if (_visibleSide == FESidePanelRight && point.x < ([UIScreen mainScreen].bounds.size.width - kDefaultSidePanelVCWidth)){
            isEnable = YES;
        }else if (_visibleSide == FESidePanelLeft && point.x > kDefaultSidePanelVCWidth){
            isEnable = YES;
        }
        return isEnable;
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture{
    
    static BOOL             isValidate    = NO;
    static CGFloat          centerOriginX = 0.0f;
    static CGFloat          visiblePercent= 0.0f;
    static FESidePanelType  visibleSide   = FESidePanelCenter;
    __unsafe_unretained static UIView    *visibleView  = nil;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            isValidate    = NO;
            centerOriginX = _centerContainer.frame.origin.x;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint translate = [gesture translationInView:_containerView];
            //竖直方向变化很多则不作为处理
            if (ABS(translate.y) < kMinDistanceY){
                isValidate = YES;
                
                CGFloat offsetX = centerOriginX + translate.x ;
                FESidePanelType side = offsetX > 0 ? FESidePanelLeft : FESidePanelRight;
               //NSLog(@">>>_visibleSide = %d sid=%d offset=%f , translate=%f",_visibleSide,side, offsetX , translate.x);
                [self loadSidePanelWithType:side];
                //非center时还能拖动小段距离，除以kOutsideDivide 系数，bounce效果
                CGFloat adjustX = 0.0f , adjustLeftX = 0.0f , adjustRightX = 0.0f;
                adjustLeftX  = (offsetX < -_rightVisibleWidth) ? -_rightVisibleWidth + (offsetX + _rightVisibleWidth)/kOutsideDivide : offsetX;
                adjustRightX = (offsetX > _leftVisibleWidth)   ? _leftVisibleWidth + (offsetX - _rightVisibleWidth)/kOutsideDivide : offsetX;
                adjustX = translate.x < 0 ? adjustLeftX : adjustRightX;
                //是否禁止left 或者right
                adjustX = adjustX > 0 && ! self.isShowLeft  ? 0.0f : adjustX;
                adjustX = adjustX < 0 && ! self.isShowRight ? 0.0f : adjustX;
                [self setView:_centerContainer originX:adjustX];
                [self updateCenterContainerShadow:YES];
                
                if (_translateBlock) {
                    visiblePercent = FESidePanelLeft == side ? adjustX/_leftVisibleWidth : adjustX/-_rightVisibleWidth;
                    visibleView    = FESidePanelLeft == side ? self.leftPanel.view : self.rightPanel.view;
                    visibleSide    = side;
                    CGFloat maxWidth = FESidePanelLeft == side ? _leftVisibleWidth : _rightVisibleWidth;
                    _translateBlock(visibleView ,FESidePanelRight == visibleSide,maxWidth,visiblePercent);
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (isValidate)
            {
                CGFloat originX = _centerContainer.frame.origin.x;
                FESidePanelType side = FESidePanelCenter;
                side = (originX > roundf(_leftVisibleWidth/2.0)) ? FESidePanelLeft : side;  //显示left panel
                side = (originX < roundf(_leftVisibleWidth/-2.0)) ? FESidePanelRight : side;//显示right panel
                
                //以下三种情况有 viewcontroller切换，需要触发对应的appear 和 disappear
                //1.处理当前visible模式为center，往左划或者往右划未达到最短距离，恢复center模式，触发对应的panel调用dispear
                //2.处理当前visible模式为left,转换为center
                //3.处理当前visible模式为right,转换为center
                BOOL isChanged = NO;
                isChanged = (_visibleSide == FESidePanelCenter && side == _visibleSide) ?    YES : isChanged;//1.center -> (left or right) -> center
                isChanged = (_visibleSide == FESidePanelLeft && side == FESidePanelCenter)?  YES : isChanged;//2.left -> center
                isChanged = (_visibleSide == FESidePanelRight && side == FESidePanelCenter)? YES : isChanged;//3.right -> center
                               
                [self translateCenterWithType:side
                                     animated:^{
                                         CGFloat percent  = side == FESidePanelCenter ? 0.0 : 1.0;
                                         CGFloat maxWidth = FESidePanelLeft == visibleSide ? _leftVisibleWidth : _rightVisibleWidth;
                                         if (_translateBlock) {
                                             _translateBlock(visibleView,FESidePanelRight == visibleSide,maxWidth,percent);
                                         }
                                     }
                                   completion:^{
                                        if (isChanged){
                                            [self showLeftPanel:NO];
                                            [self showRightPanel:NO];
                                        }
                                        _visibleSide = side;

                }];                
            }
        }
            
            break;
        default:
            break;
    }
    
}

- (void)handleTap:(UIButton*)button{
    if (_visibleSide != FESidePanelCenter) {
        [self showCenterPanelAnimated:YES];
        [button removeFromSuperview];
    }
}

#pragma mark - Private Method
- (void)setView:(UIView*)view originX:(CGFloat)originX
{
    CGRect rect = view.frame;
    rect.origin.x = originX;
    view.frame = rect;
}

- (void)baseInit{
    _leftVisibleWidth  = kDefaultSidePanelVCWidth;
    _rightVisibleWidth = kDefaultSidePanelVCWidth;
    _visibleSide = FESidePanelCenter;
    
    _isEnableShadow = YES;
    _isShowLeft     = NO;
    _isShowRight    = YES;
    
    _translateType  = FETranslateAnimationTypeParallax;
    _translateBlock = [[FEViewTranslate sharedIntance] translateBlockWithType:_translateType];
    
    CGRect rect = CGRectZero;//[[UIScreen mainScreen] bounds];
    _centerContainer = [[UIView alloc] initWithFrame:rect];
    _rightContainer  = [[UIView alloc] initWithFrame:rect];
    _leftContainer   = [[UIView alloc] initWithFrame:rect];
    _containerView   = [[UIView alloc] initWithFrame:rect];
    
    
    
    _containerView.autoresizingMask   = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _centerContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _leftContainer.autoresizingMask   = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _rightContainer.autoresizingMask  = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _centerContainer.backgroundColor = [UIColor clearColor];
    _leftContainer.backgroundColor   = [UIColor clearColor];
    _rightContainer.backgroundColor  = [UIColor clearColor];
    
//    [_containerView addSubview:_rightContainer];
//    [_containerView addSubview:_leftContainer];
//    [_containerView addSubview:_centerContainer];
    if (self.isEnableGesture) {
        [_containerView addGestureRecognizer:self.panGesture];
    }
    [self updateCenterContainerShadow:YES];
}


- (void) showCenterPanel:(BOOL)isShow{
    if (isShow){
        if (self.centerPanel && self.centerPanel.view.superview == nil){
            [self resetViewDefaultTransform:self.centerPanel.view];
            [self sendDelegateAndNotification:FESidePanelCenterWillAppear];
            [self addChildViewController:self.centerPanel];
            if ([self.centerPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.centerPanel beginAppearanceTransition:YES animated:NO];
            }
            [_centerContainer addSubview:self.centerPanel.view];
            [self.centerPanel.view setFrame:_centerContainer.bounds];
            if ([self.centerPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.centerPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelCenterDidAppear];
        }
    }
    else{
        if (self.centerPanel && self.centerPanel.view.superview ){
            [self resetViewDefaultTransform:self.centerPanel.view];
            [self sendDelegateAndNotification:FESidePanelCenterWillDisappear];
            if ([self.centerPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.centerPanel beginAppearanceTransition:YES animated:NO];
            }
            [self.centerPanel.view removeFromSuperview];
            if ([self.centerPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.centerPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelCenterDidDisappear];
        }
    }
}

- (void) showLeftPanel:(BOOL)isShow{
    CGFloat originX = isShow ? 0 : -_leftVisibleWidth;
    [self setView:_leftContainer originX:originX];
    if (isShow){
        if (self.isShowLeft && self.leftPanel && self.leftPanel.view.superview == nil){
            [self resetViewDefaultTransform:self.leftPanel.view];
            [self sendDelegateAndNotification:FESidePanelLeftWillAppear];
            [self.rightPanel removeFromParentViewController];
            [self addChildViewController:self.leftPanel];
            if ([self.leftPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.leftPanel beginAppearanceTransition:YES animated:NO];
            }
            [self.leftPanel.view setFrame:CGRectMake(0, 0, _leftVisibleWidth, _leftContainer.frame.size.height)];
            //[self FEChildViewControllerViewWillAppear:self.leftPanel animated:NO];
            [_leftContainer addSubview:self.leftPanel.view];
            //[self FEChildViewControllerViewDidAppear:self.leftPanel animated:NO];
            if ([self.leftPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.leftPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelLeftDidAppear];
            [_containerView bringSubviewToFront:_leftContainer];
            [_containerView bringSubviewToFront:_centerContainer];
        }
    }
    else{
        if (self.leftPanel && self.leftPanel.view.superview ){
            [self resetViewDefaultTransform:self.leftPanel.view];
            [self sendDelegateAndNotification:FESidePanelLeftWillDisappear];
            [self.leftPanel removeFromParentViewController];
            if ([self.leftPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.leftPanel beginAppearanceTransition:YES animated:NO];
            }
            //[self FEChildViewControllerViewWillDisappear:self.leftPanel animated:NO];
            [self.leftPanel.view removeFromSuperview];
            //[self FEChildViewControllerViewDidDisappear:self.leftPanel animated:NO];
            if ([self.leftPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.leftPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelLeftDidDisappear];
        }
    }
}

- (void) showRightPanel:(BOOL)isShow{
    CGFloat originX = isShow ? 0 : -_rightVisibleWidth;
    [self setView:_rightContainer originX:originX];
    if (isShow){
        if (self.isShowRight && self.rightPanel && self.rightPanel.view.superview == nil){
            [self resetViewDefaultTransform:self.rightPanel.view];
            [self sendDelegateAndNotification:FESidePanelRightWillAppear];
            [self addChildViewController:self.rightPanel];
            //[self.rightPanel setFESuperViewController:self];
            if ([self.rightPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.rightPanel beginAppearanceTransition:YES animated:NO];
            }
            CGRect rect =CGRectMake(_rightContainer.frame.size.width - _rightVisibleWidth, 0, _rightVisibleWidth, _rightContainer.frame.size.height);
            [self.rightPanel.view setFrame:rect];
            //[self FEChildViewControllerViewWillAppear:self.rightPanel animated:NO];
            [_rightContainer addSubview:self.rightPanel.view];
            //[self FEChildViewControllerViewDidAppear:self.rightPanel animated:NO];
            if ([self.rightPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.rightPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelRightDidAppear];
            [_containerView bringSubviewToFront:_rightContainer];
            [_containerView bringSubviewToFront:_centerContainer];
        }
    }
    else{
        if (self.rightPanel && self.rightPanel.view.superview ){
            [self resetViewDefaultTransform:self.rightPanel.view];
            [self sendDelegateAndNotification:FESidePanelRightWillDisappear];
            [self.rightPanel removeFromParentViewController];
            if ([self.rightPanel respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
                [self.rightPanel beginAppearanceTransition:YES animated:NO];
            }
            //[self FEChildViewControllerViewWillDisappear:self.rightPanel animated:NO];
            [self.rightPanel.view removeFromSuperview];
            //[self FEChildViewControllerViewDidDisappear:self.rightPanel animated:NO];
            if ([self.rightPanel respondsToSelector:@selector(endAppearanceTransition)]) {
                [self.rightPanel endAppearanceTransition];
            }
            [self sendDelegateAndNotification:FESidePanelRightDidDisappear];
        }
    }
}


- (void) loadSidePanelWithType:(FESidePanelType)type{
    if (_visibleSide != type){
        [self showLeftPanel: FESidePanelLeft == type];
        [self showRightPanel:FESidePanelRight == type];
        if (type == FESidePanelCenter) {
            [self.tapMaskButton removeFromSuperview];
        }else {
            //UIView *superView = (FESidePanelLeft == type) ? _leftContainer : _rightContainer;
            //[superView addSubview:self.tapMaskButton];
            //[superView bringSubviewToFront:self.tapMaskButton];
            CGRect rect = (FESidePanelLeft == type) ? CGRectMake(kDefaultSidePanelVCWidth, 64, [UIScreen mainScreen].bounds.size.width - kDefaultSidePanelVCWidth , [UIScreen mainScreen].bounds.size.height) :  CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width - kDefaultSidePanelVCWidth , [UIScreen mainScreen].bounds.size.height);
            [self.tapMaskButton setFrame:rect];
            [[UIApplication sharedApplication].keyWindow addSubview:self.tapMaskButton];
        }
    }
}

- (void)translateCenterWithType:(FESidePanelType)type animated:(void (^)())animated completion:(void (^)())completion{
    CGFloat originX, distance, duration, nextX;
    originX  = _centerContainer.frame.origin.x;
    distance = _centerContainer.frame.size.width;
    nextX    = 0.0f;
    if (type != FESidePanelCenter){
        nextX    = type == FESidePanelLeft ? _leftVisibleWidth : -_rightVisibleWidth;
        distance = type == FESidePanelLeft ? _leftVisibleWidth : _rightVisibleWidth;
    }else{
        [self.tapMaskButton removeFromSuperview];
    }

    duration = ((nextX - originX)/distance*1.0) * kAnimationDuation;
    //duration = kAnimationDuation;

    if (animated){
        [UIView animateWithDuration:duration
                         animations:^{
                             [self setView:_centerContainer originX:nextX];
                             animated();
                         } completion:^(BOOL finished) {
                             if (finished && completion){
                                 completion();
                             }
                         }];   
    }
    else{
        [self setView:_centerContainer originX:originX];
        if (completion) {
            completion();
        }

    }
}

- (void)updateCenterContainerShadow:(BOOL)isShadow{
    if (self.isEnableShadow){
        if(isShadow){
            _centerContainer.layer.masksToBounds = NO;
            _centerContainer.layer.shadowRadius  = kShadowRadius;
            _centerContainer.layer.shadowOpacity = kShadowOpacity;
            _centerContainer.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_centerContainer.bounds] CGPath];
        }
    }
    else{
        _centerContainer.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectNull].CGPath;
    }
}

- (void)sendDelegateAndNotification:(FESidePanelEvent)event{
    switch (event)
    {
        case FESidePanelLeftWillAppear:
        {
            if (_flag.sidePanelControllerWillShowController){
                [_delegate sidePanelController:self willShowController:self.leftPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerLeftWillAppear object:self];
        }
            break;
        case FESidePanelLeftDidAppear:
        {
            if (_flag.sidePanelControllerDidShowController){
                [_delegate sidePanelController:self didShowController:self.leftPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerLeftDidAppear object:self];
        }
            break;
        case FESidePanelLeftWillDisappear:
        {
            if (_flag.sidePanelControllerWillDismissController){
                [_delegate sidePanelController:self willDismissController:self.leftPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerLeftWillDisappear object:self];
        }
            break;
        case FESidePanelLeftDidDisappear:
        {
            if (_flag.sidePanelControllerDidDismissController){
                [_delegate sidePanelController:self didDismissController:self.leftPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerLeftDidDisappear object:self];
        }
            break;
        case FESidePanelRightWillAppear:
        {
            if (_flag.sidePanelControllerWillShowController){
                [_delegate sidePanelController:self willShowController:self.rightPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerRightWillAppear object:self];
        }
            break;
        case FESidePanelRightDidAppear:
        {
            if (_flag.sidePanelControllerDidShowController){
                [_delegate sidePanelController:self didShowController:self.rightPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerRightDidAppear object:self];
        }
            break;
        case FESidePanelRightWillDisappear:
        {
            if (_flag.sidePanelControllerWillDismissController){
                [_delegate sidePanelController:self willDismissController:self.rightPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerRightWillDisappear object:self];
        }
            break;
        case FESidePanelRightDidDisappear:
        {
            if (_flag.sidePanelControllerDidDismissController){
                [_delegate sidePanelController:self didDismissController:self.rightPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerRightDidDisappear object:self];
        }
            break;
        case FESidePanelCenterWillAppear:
        {
            if (_flag.sidePanelControllerWillShowController){
                [_delegate sidePanelController:self willShowController:self.centerPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerCenterWillAppear object:self];
        }
            break;
        case FESidePanelCenterDidAppear:
        {
            if (_flag.sidePanelControllerDidShowController){
                [_delegate sidePanelController:self didShowController:self.centerPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerCenterDidAppear object:self];
        }
            break;
        case FESidePanelCenterWillDisappear:
        {
            if (_flag.sidePanelControllerWillDismissController){
                [_delegate sidePanelController:self willDismissController:self.centerPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerCenterWillDisappear object:self];
        }
            break;
        case FESidePanelCenterDidDisappear:
        {
            if (_flag.sidePanelControllerDidDismissController){
                [_delegate sidePanelController:self didDismissController:self.centerPanel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FESidePanelControllerCenterDidDisappear object:self];
        }
            break;
            
        default:
            break;
    }

}

- (void)resetViewDefaultTransform:(UIView*)view{
    [view.layer setTransform:CATransform3DIdentity];
    [view.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [view.layer setShouldRasterize:NO];
    [view setAlpha:1.0];
}


#pragma mark - Override present & dismsiss
#pragma GCC push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

-(void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated{
    if ([super respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [super presentViewController:modalViewController animated:animated completion:NULL];
    }else{
        [super presentModalViewController:modalViewController animated:animated];
    }
}

-(void)dismissModalViewControllerAnimated:(BOOL)animated{
    if ([super respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [super dismissViewControllerAnimated:animated completion:NULL];
    }else{
        [super dismissModalViewControllerAnimated:animated];
    }
}
#pragma GCC pop

@end
