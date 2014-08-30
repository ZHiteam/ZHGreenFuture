//
//  TabbarItem.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarItem : UIControl

@property (nonatomic ,assign) NSString*     title;
@property (nonatomic ,assign) NSString*     subTitle;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)subTitle;
@end
