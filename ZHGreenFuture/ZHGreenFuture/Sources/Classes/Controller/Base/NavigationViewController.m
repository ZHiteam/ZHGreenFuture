//
//  NavigationViewController.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-2.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController (){
    NSMutableArray* _viewControllers;
    BOOL            _pushLock;
}

@end

@implementation NavigationViewController

-(id)init{
    if ((self = [super init])) {
        _viewControllers = [[NSMutableArray alloc]initWithCapacity:0];
        self.hasNavitaiongBar = NO;
        _pushLock = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarChangeNotifaction) name:ZHSTATUS_BAR_CHANGE object:nil];
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
    return self;
}


-(id)initWithRootViewController:(ZHViewController*)rootViewController frame:(CGRect)frame{

    if ((self = [self init])) {
        self.viewFrame = frame;
        [self pushViewController:rootViewController animation:ANIMATE_TYPE_NONE];
    }
    
    return self;
}

-(void)dealloc{
    [_viewControllers removeAllObjects];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [_viewControllers.lastObject viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark pushViewController
-(void)pushViewController:(ZHViewController*)aViewController{
    [self pushViewController:aViewController animation:aViewController.animationType];
}

-(void)pushViewController:(ZHViewController *)aViewController animation:(AnimationType)animation{
    
    if (_pushLock) {
        return;
    }
    @try {
        aViewController.animationType = animation;
        
        aViewController.navigationCtl = self;
        
        if (CGRectIsEmpty(aViewController.viewFrame)) {
            aViewController.viewFrame = self.view.bounds;
        }
        
        [self.view addSubview:aViewController.view];
        
        if (animation == ANIMATE_TYPE_HORIZONTAL) {
            aViewController.view.left = self.view.width;
            aViewController.view.top = 0.0f;
        }else{
            aViewController.view.top = self.view.height;
        }
        
        /// 添加返回
        if (!aViewController.navigationBar.leftBarItem && _viewControllers.count >= 1) {
            UIButton* btn = [UIButton backBarItem];
            [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
            aViewController.navigationBar.leftBarItem = btn;
        }
        
        if (ANIMATE_TYPE_NONE == animation) {
            aViewController.view.origin = CGPointMake(0, 0);
            [_viewControllers addObject:aViewController];
            
            
            [self setNeedsStatusBarAppearanceUpdate];
            
        }
        else{
            _pushLock = YES;
            [UIView animateWithDuration:ANIMATE_DURATION animations:^{
                aViewController.view.origin = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                _pushLock = NO;
                [_viewControllers addObject:aViewController];
                
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }

    }
    @catch (NSException *exception) {
        ZHLOG(@"%@",exception);
    }
    @finally {
        
    }
}

-(void)pop{
    [self popWithAnimation:YES];
}

-(void)popWithAnimation:(BOOL)animation{
    
    if ([_viewControllers count] <= 1) {
        return;
    }
    ZHViewController* vc = [_viewControllers lastObject];
    
    void (^popBLock)(BOOL finished) = ^(BOOL finished){
        if (_viewControllers.count > 1) {
            [vc.view removeFromSuperview];
            [_viewControllers removeLastObject];
        }
    };
    
    if (!animation || ANIMATE_TYPE_NONE == vc.animationType)
    {
        popBLock(YES);
        [[_viewControllers lastObject] viewWillAppear:YES];
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            if (vc.animationType == ANIMATE_TYPE_HORIZONTAL) {
                vc.view.left = self.view.width;
            }
            else if (vc.animationType == ANIMATE_TYPE_VERTICAL ) {
                vc.view.top = self.view.height;
            }
        } completion:^(BOOL finished) {
            popBLock(finished);
            [[_viewControllers lastObject] viewWillAppear:YES];

            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }

}

-(void)popToRoot{
    if ( [_viewControllers count] <= 1) {
        return;
    }
    
    while ([_viewControllers count] >= 2) {
        [self popWithAnimation:NO];
    }
    [self pop];
}

-(ZHViewController*)topViewController{
    if (_viewControllers.count > 0) {
        return [_viewControllers lastObject];
    }
    return nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    if (0 == _viewControllers.count) {
        return self.statusStyle;
    }
    
    return ((ZHViewController*)[_viewControllers lastObject]).statusStyle;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)statusBarChangeNotifaction{
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
