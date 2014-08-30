//
//  NavigationViewController.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-2.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "ZHViewController.h"
#import "NavigationBar.h"

@interface NavigationViewController : ZHViewController

-(id)initWithRootViewController:(ZHViewController*)rootViewController frame:(CGRect)frame;

-(void)pushViewController:(ZHViewController*)aViewController;

-(void)pushViewController:(ZHViewController *)aViewController animation:(AnimationType)animation;

-(void)pop;

-(void)popWithAnimation:(BOOL)animation;

-(void)popToRoot;

-(ZHViewController*)topViewController;
@end
