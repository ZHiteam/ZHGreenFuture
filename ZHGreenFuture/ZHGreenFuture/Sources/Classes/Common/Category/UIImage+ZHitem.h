//
//  UIImage+HKWF.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZHitem)

+(UIImage *)themeImageNamed:(NSString *)name;

+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
