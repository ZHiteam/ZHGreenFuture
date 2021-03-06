//
//  UILabel+HKWF.m
//  Stock4HKWF
//
//  Created by elvis on 13-8-27.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "UILabel+ZHiteam.h"

@implementation UILabel (ZHiteam)

+(UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment{
    return [UILabel labelWithText:text font:font color:color textAlignment:textAlignment backgroundColor:[UIColor clearColor]];
}

+(UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor{
    UILabel* label = [[UILabel alloc]init];
    label.text = text;
    label.font = font;
	label.textColor = color;
	label.textAlignment = textAlignment;
    
    label.adjustsFontSizeToFitWidth = YES;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_0
    label.minimumScaleFactor = 0.4;
#else
    label.minimumFontSize = font.pointSize/2;
#endif
    
	label.backgroundColor = backgroundColor;
    
    return label;
}

-(void)fitWithSize:(CGSize)size{
    CGSize fitSize = [self.text sizeWithFont:self.font constrainedToSize:size];
    self.size = CGSizeMake(fitSize.width+20.0f, fitSize.height+6.0f);
}
@end
