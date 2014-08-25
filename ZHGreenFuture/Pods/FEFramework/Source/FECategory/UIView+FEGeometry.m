//
//  UIView+FEGeometry.m
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIView+FEGeometry.h"

@implementation UIView (FEGeometry)

-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

- (CGPoint)origin {
	return self.frame.origin;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setOriginX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (void)setOriginY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (void)setOriginX:(CGFloat)x andY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.x = x;
	frame.origin.y = y;
	self.frame = frame;
}

- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.width  = width;
	frame.size.height = height;
	self.frame = frame;
}

@end
