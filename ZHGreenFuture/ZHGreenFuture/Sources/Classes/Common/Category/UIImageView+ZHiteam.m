//
//  UIImageView+ZHiteam.m
//  ZHGreenFuture
//
//  Created by elvis on 9/2/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "UIImageView+ZHiteam.h"
#import "UIImageView+WebCache.h"
#import "DRImagePlaceholderHelper.h"

@implementation UIImageView (ZHiteam)

-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholderImage{
    NSURL *encodedString = [url greenFutureURL];
    
    [self setImageWithURL:encodedString placeholderImage:placeholderImage completed:nil];
}

-(void)setImageWithUrlString:(NSString*)url{

    UIImage* placeholderImage = [[DRImagePlaceholderHelper sharedInstance]placerholderImageWithSize:self.size text:@"放心粮" fillColor:GRAY_LINE];
    
    [self setImageWithUrlString:url placeholderImage:placeholderImage];
}
@end
