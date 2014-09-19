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

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
