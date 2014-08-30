//
//  TabbarView.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-4.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarItem.h"

@protocol TabbarDataSource;
@protocol TabbarDelegate;

@interface TabbarView : UIView
@property (nonatomic, assign) id<TabbarDataSource>  dataSource;
@property (nonatomic, assign) id<TabbarDelegate>    delegate;


-(NSUInteger)selectedIndex;

-(void)reloadData;

-(void)selectAtIndex:(NSUInteger)aIndex animation:(BOOL)animation;
@end


@protocol TabbarDataSource <NSObject>

@required
-(NSUInteger)numberOfItems;

-(TabbarItem*)tabbar:(TabbarView *)tabbar itemAtIndex:(NSUInteger)index;

@optional
-(UIImage*)selectedImage;

-(UIImage*)backgroundImage;
@end

@protocol TabbarDelegate <NSObject>

@optional
-(BOOL)tabbar:(TabbarView*)tabbar shouldSelectedAtIndex:(NSUInteger)aIndex;

-(void)tabbar:(TabbarView*)tabbar willSelectedAtIndex:(NSUInteger)aIndex;

-(void)tabbar:(TabbarView *)tabbar didSelectedAtIndex:(NSUInteger)aIndex;

@end