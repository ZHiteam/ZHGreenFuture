//
//  NavigationBar.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UIView
@property (nonatomic, strong) NSString*     title;
@property (nonatomic, strong) UIView*       titleView;

@property (nonatomic, strong) UIView*       leftBarItem;
@property (nonatomic, strong) UIView*       rightBarItem;

-(void)setTitleColor:(UIColor*)color;
@end

@interface UIButton(NavigationBar)

+(UIButton*)backBarItem;

+(UIButton*)barItemWithTitle:(NSString*)title action:(id)action selector:(SEL)selector;

+(UIButton*)barItemWithTitle:(NSString*)title image:(UIImage*)image action:(id)action selector:(SEL)selector;

+(UIControl*)rightBarItemWithTitle:(NSString*)title image:(UIImage*)image action:(id)action selector:(SEL)selector;

+(UIButton*)searchButton;
@end