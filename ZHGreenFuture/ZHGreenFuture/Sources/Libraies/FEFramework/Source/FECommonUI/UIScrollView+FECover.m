//
//  UIScrollView+FECover.m
//
//
//  Created by lv on 14-5-25.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "UIScrollView+FECover.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <objc/runtime.h>

#define FEScreenWidth  [[UIScreen mainScreen] bounds].size.width
static char FEUIScrollViewCoverViewKey;

//////////////////////////////////////////////////////////////////////////////////////////
@interface UIImage (FEBlur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end


@implementation UIImage (FEBlur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    return returnImage;
}

@end


@interface FECoverView : UIImageView
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign)BOOL        isEnableBlur;
- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView*)topView aboveView:(UIView*)aboveView enableBlur:(BOOL)isEnableBlur;
@end


@implementation FECoverView{
    NSMutableArray  *_blurImages;
    UIView          *_topView;
    UIView          *_aboveView;
    CGRect           aboveOriginRect;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andContentTopView:nil aboveView:nil enableBlur:NO];
}

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView*)topView aboveView:(UIView*)aboveView enableBlur:(BOOL)isEnableBlur
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        _blurImages = [[NSMutableArray alloc] initWithCapacity:20];
        _topView    = topView;
        _aboveView  = aboveView;
        aboveOriginRect = aboveView.frame;
        self.isEnableBlur = isEnableBlur;
        
        //[self addSubview:_topView];
        //[self addSubview:_aboveView];
    }
    return self;
}

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = nil;
}
- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [_blurImages removeAllObjects];
    if (self.isEnableBlur) {
        [self prepareForBlurImages];
    }
}

- (void)prepareForBlurImages
{
    CGFloat factor = 0.1;
    [_blurImages addObject:self.image];
    for (NSUInteger i = 0; i < 20; i++) {
        [_blurImages addObject:[self.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview
{
    [_topView   removeFromSuperview];
    [_aboveView removeFromSuperview];
    [super removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.scrollView.contentOffset.y < 0) {
        CGFloat offset = -self.scrollView.contentOffset.y;
        _topView.frame = CGRectMake(0, -offset, FEScreenWidth, _topView.bounds.size.height);
        //_aboveView.frame = CGRectMake(aboveOriginRect.origin.x, aboveOriginRect.origin.y-offset, _aboveView.bounds.size.width, _aboveView.bounds.size.height);
        
        //NSLog(@">>>%@  %@",NSStringFromCGRect(_topView.frame),NSStringFromCGRect(_aboveView.frame));
        self.frame = CGRectMake(-offset,-offset + _topView.bounds.size.height, FEScreenWidth+ offset * 2, FECoverViewHeight + offset);
        NSInteger index = offset / 10;
        if (index < 0) {
            index = 0;
        }
        else if(index >= _blurImages.count) {
            index = _blurImages.count - 1;
        }
        if (_blurImages.count >index) {
            UIImage *image = _blurImages[index];
            if (self.image != image) {
                [super setImage:image];
            }
        }
    }
    else {
        _topView.frame = CGRectMake(0, 0, FEScreenWidth, _topView.bounds.size.height);
        _aboveView.frame = aboveOriginRect;
        self.frame = CGRectMake(0,_topView.bounds.size.height, FEScreenWidth, FECoverViewHeight);
        if (_blurImages.count >0) {
            UIImage *image = _blurImages[0];
            if (self.image != image) {
                [super setImage:image];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

@end
//////////////////////////////////////////////////////////////////////////////////////////


@interface UIScrollView (FECoverPrivate)
@property(nonatomic,weak)FECoverView *coverView;
@end

@implementation UIScrollView (FECover)
- (void)setCoverView:(FECoverView *)coverView {
    [self willChangeValueForKey:@"FECoverView"];
    objc_setAssociatedObject(self, &FEUIScrollViewCoverViewKey,coverView,OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"FECoverView"];
}

- (FECoverView *)coverView {
    return objc_getAssociatedObject(self, &FEUIScrollViewCoverViewKey);
}

- (void)addCoverWithImage:(UIImage*)image{
    [self addCoverWithImage:image withTopView:nil aboveView:nil enableBlur:NO];
}

- (void)addCoverWithImage:(UIImage*)image withTopView:(UIView*)topView{
    [self addCoverWithImage:image withTopView:topView aboveView:nil enableBlur:NO];
}

- (void)addCoverWithImage:(UIImage*)image withTopView:(UIView*)topView aboveView:(UIView*)aboveView enableBlur:(BOOL)isEnableBlur
{
    FECoverView *view = [[FECoverView alloc] initWithFrame:CGRectMake(0,0, FEScreenWidth, FECoverViewHeight) andContentTopView:topView aboveView:aboveView enableBlur:isEnableBlur];
    
    view.backgroundColor = [UIColor clearColor];
    view.image = image;
    view.scrollView = self;
    
    [self addSubview:view];
    if (topView) {
        [self addSubview:topView];
    }
    if (aboveView) {
        [self addSubview:aboveView];
    }
    self.coverView = view;
}

- (void)removeCoverView
{
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}

@end
