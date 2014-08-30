//
//  TabbarItem.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-3.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarItem : UIControl

@property (nonatomic ,strong) UIImage*      defaultImage;
@property (nonatomic ,strong) UIImage*      selectedImage;

-(id)initWithFrame:(CGRect)frame image:(UIImage*)image selectedImage:(UIImage*)selectedImage;
@end
