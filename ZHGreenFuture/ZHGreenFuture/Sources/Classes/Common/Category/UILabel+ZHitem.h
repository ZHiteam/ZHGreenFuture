//
//  UILabel+HKWF.h
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZHitem)

+(UILabel*)labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment;

+(UILabel*)labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor*)backgroundColor;

-(void)fitWithSize:(CGSize)size;

@end
