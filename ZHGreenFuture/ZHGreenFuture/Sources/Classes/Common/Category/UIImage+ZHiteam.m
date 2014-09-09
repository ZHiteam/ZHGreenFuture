//
//  UIImage+HKWF.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "UIImage+ZHiteam.h"
@implementation UIImage (ZHiteam)

/**
 * 优先在主题文件夹中查找
 */
+(UIImage *)themeImageNamed:(NSString *)name{
    do {
        /// 主题根目录
        NSString* basePath = [MemoryStorage valueForKey:k_BASE_THEME_PATH];
        
        if (!isEmptyString(basePath)) {
            break;
        }
        basePath = [basePath stringByAppendingString:name];
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:basePath]) {
            return [UIImage imageWithContentsOfFile:basePath];
        }
        
    } while (FALSE);
    
    return [UIImage imageNamed:name];
}

+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
