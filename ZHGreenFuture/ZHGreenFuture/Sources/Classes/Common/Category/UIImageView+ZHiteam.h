//
//  UIImageView+ZHiteam.h
//  ZHGreenFuture
//
//  Created by elvis on 9/2/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZHiteam)

-(void)setImageWithUrlString:(NSString*)url;

-(void)setImageWithUrlString:(NSString*)url placeholderImage:(UIImage*)placeholderImage;
@end
