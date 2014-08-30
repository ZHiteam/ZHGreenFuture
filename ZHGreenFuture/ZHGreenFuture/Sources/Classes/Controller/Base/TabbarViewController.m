//
//  TabbarViewController.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "TabbarViewController.h"

@interface TabbarViewController (){
    TabbarView*     _tabbar;
    
    NSMutableDictionary* _viewControllers;
    
    UIView*         _contentView;
}
-(void)initTabbar;
-(void)loadTabbar;

-(void)initContentView;
-(void)loadContantView;
@end

@implementation TabbarViewController

-(id)init{
    if ((self = [super init])) {
        [self initTabbar];
        [self initContentView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTabbar];
    [self loadContantView];
    
    [self.view bringSubviewToFront:_tabbar];
}

-(void)viewWillAppear:(BOOL)animated{
    [[self currentViewController] viewWillAppear:animated];
}

-(void)initTabbar{
    if (!_tabbar) {
        _tabbar = [[TabbarView alloc]init];
        _viewControllers = [[NSMutableDictionary alloc]initWithCapacity:1];
    }
}

-(void)loadTabbar{
    if (_tabbar.superview != self.view) {
        _tabbar.frame = CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, FULL_WIDTH, TAB_BAR_HEIGHT);
        _tabbar.dataSource = self;
        _tabbar.delegate = self;
        [self.view addSubview:_tabbar];
    }
}

-(void)initContentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
}

-(void)loadContantView{
    if (_contentView.superview != self.view) {
        _contentView.frame = CGRectMake(0, 0, self.view.width, self.view.height-_tabbar.height);
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView];
    }
}

-(void)selectAtIndex:(NSUInteger)aIndex animation:(BOOL)animation{
    [_tabbar selectAtIndex:aIndex animation:animation];
}

-(void)reloadData{
    [_tabbar reloadData];
    
    [self selectAtIndex:_tabbar.selectedIndex animation:NO];
}

#pragma -mark
#pragma -mark TabbarControllerDelegate
-(TabbarItem *)tabbar:(TabbarView *)tabbar itemAtIndex:(NSUInteger)index{
    if ([_dataSource respondsToSelector:@selector(tabbar:itemAtIndex:)]) {
        return [_dataSource tabbar:tabbar itemAtIndex:index];
    }
    
    return nil;
}

-(NSUInteger)numberOfItems{
    if ([_dataSource respondsToSelector:@selector(numberOfItems)]) {
        return [_dataSource numberOfItems];
    }
    
    return 0;
}

-(UIImage*)selectedImage{
    if ([_dataSource respondsToSelector:@selector(selectedImage)]) {
        return [_dataSource selectedImage];
    }
    return nil;
}

-(UIImage*)backgroundImage{
    if ([_dataSource respondsToSelector:@selector(backgroundImage)]) {
        return [_dataSource backgroundImage];
    }
    return nil;
}

-(UIView*)backgroundView{
    if ([_dataSource respondsToSelector:@selector(backgroundView)]) {
        return [_dataSource backgroundView];
    }
    return nil;
}

#pragma -mark TabbarDelegate
-(BOOL)tabbar:(TabbarView *)tabbar shouldSelectedAtIndex:(NSUInteger)aIndex{
    
    BOOL shouldLoad = YES;
    
    if ([_delegate respondsToSelector:@selector(tabbar:shouldSelectedAtIndex:)]) {
        shouldLoad = [_delegate tabbar:tabbar shouldSelectedAtIndex:aIndex];
    }
    
    if (shouldLoad) {
        ZHViewController* vc = [self _getViewControllerAtIndex:aIndex];
        if (!vc) {
            shouldLoad = NO;
        }
    }
    
    return shouldLoad;
}

-(void)tabbar:(TabbarView *)tabbar willSelectedAtIndex:(NSUInteger)aIndex{
    
    if ([_delegate respondsToSelector:@selector(tabbar:willSelectedAtIndex:)]) {
        [_delegate tabbar:tabbar willSelectedAtIndex:aIndex];
    }
}

-(void)tabbar:(TabbarView *)tabbar didSelectedAtIndex:(NSUInteger)aIndex{
    if ([_delegate respondsToSelector:@selector(tabbar:didSelectedAtIndex:)]) {
        [_delegate tabbar:tabbar didSelectedAtIndex:aIndex];
    }
    
    [_contentView removeAllSubviews];
    ZHViewController* vc = [self _getViewControllerAtIndex:aIndex];
    if (vc) {
        if (vc.view.superview) {
            [vc.view removeFromSuperview];
        }
        [_contentView addSubview:vc.view];
    }
}

-(ZHViewController*)_getViewControllerAtIndex:(NSUInteger)aIndex{
    ZHViewController* vc = [_viewControllers objectForKey:[NSNumber numberWithInt:aIndex]];

    if (!vc && [_dataSource respondsToSelector:@selector(tabbarCtl:viewControllerAtIndex:)]) {

        vc = [_dataSource tabbarCtl:self viewControllerAtIndex:aIndex];
        vc.viewFrame = _contentView.bounds;
        if (vc) {
            [_viewControllers setObject:vc forKey:[NSNumber numberWithInt:aIndex]];
        }
    }
    
    return vc;
}

-(CGFloat)tabbarHeight{
    return _tabbar.height;
}

-(ZHViewController *)currentViewController{
    return [self _getViewControllerAtIndex:_tabbar.selectedIndex];
}

-(NSInteger)currentSelectedIndex{
    return _tabbar.selectedIndex;
}
@end
