//
//  HKWFViewController.m
//  Stock4HKWF
//
//  Created by elvis on 13-8-26.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "ZHViewController.h"
#import "NavigationViewController.h"
#import "ZHView.h"

@interface ZHViewController ()<ZHViewMoniter>

-(void)_initNavigationBar;
-(void)addNavigationBar;
@end

@implementation ZHViewController

-(id)init{
    if ((self = [super init])) {
        _animationType = ANIMATE_TYPE_DEFAULT;
        _hasNavitaiongBar = YES;
        
        [self _initNavigationBar];
        
        
        self.statusStyle = UIStatusBarStyleLightContent;
    }
    
    return self;
}

-(void)loadView{
    
    /// 增加subView监听，保持NavigationBar在最前
    self.view = [[ZHView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ((ZHView*)(self.view)).moniter = self;
    
    if (!CGRectEqualToRect(self.viewFrame, CGRectZero)) {
        self.view.frame = self.viewFrame;
    }
}

-(void)_back{
    [self.navigationCtl popWithAnimation:self.animationType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_BACKGROUND;///[[UIColor orangeColor] colorWithAlphaComponent:0.5];
    self.swipeBack = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(_back)];
    self.swipeBack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeBack];
    
    if (_hasNavitaiongBar) {
        [self addNavigationBar];
        self.contentBounds = CGRectMake(0, _navigationBar.height, self.view.width, self.view.height-_navigationBar.height);
    }
}

-(void)_initNavigationBar{
    if (!_navigationBar) {
        _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, FULL_WIDTH, NAVIGATION_BAR_HEIGHT)];
    }
}

-(void)addNavigationBar{
    
    [self _initNavigationBar];
    
    if (_navigationBar.superview != self.view) {
        [self.view addSubview:_navigationBar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)interfaceOrientations{
    return INTERFACE_ORIENTATIONS;
}

//#if IOS_VERSION_5
-(NSUInteger)supportedInterfaceOrientations{
    return [self interfaceOrientations];
}
//#else
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    NSUInteger interface = [self interfaceOrientations];
    
    return interface&toInterfaceOrientation;
}
//#endif

#pragma -mark ZHViewMoniter
-(void)subViewAdded:(UIView *)addedView{
    if (self.hasNavitaiongBar){
        if (addedView != self.navigationBar){
            [self.view bringSubviewToFront:self.navigationBar];
        }
    }
}

-(void)whithNavigationBarStyle{
    [self.navigationBar setTitleColor:RGB(68, 68, 68)];
    self.navigationBar.backgroundColor = WHITE_BACKGROUND;
    self.navigationBar.leftBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_back"] action:self.navigationCtl selector:@selector(pop)];
    
    self.statusStyle = UIStatusBarStyleDefault;
}
@end
