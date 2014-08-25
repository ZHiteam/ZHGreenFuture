//
//  FEViewTranslate.m
//  FETestAnimation
//
//  Created by administrator on 13-7-31.
//  Copyright (c) 2013年 xxx. All rights reserved.
//

#import "FEViewTranslate.h"
#import <QuartzCore/QuartzCore.h>

@implementation FEViewTranslate

+ (FEViewTranslate*)sharedIntance
{
    static FEViewTranslate* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FEViewTranslate alloc] init];
    });
    return instance;
}

- (translateBlock)translateBlockWithType:(FETranslateAnimationType)type
{
    translateBlock block = nil;
    switch (type)
    {
        case FETranslateAnimationTypeNone:
            break;
        case FETranslateAnimationTypeSlide:
            block = [self slideTranslate];
            break;
        case FETranslateAnimationTypeSlideScale:
            block = [self slideScaleTranslate];
            break;
        case FETranslateAnimationTypeSwingingDoor:
            block = [self swingingDoorTranslate];
            break;
        case FETranslateAnimationTypeParallax:
            block = [self parallaxTranslate:2.0];
            break;
        case FETranslateAnimationTypeDragIn:
            block = [self parallaxTranslate:1.0];
            break;
        case FETranslateAnimationTypeFade:
            block = [self fadeTranslate];
            break;
        case FETranslateAnimationTypePage:
            block = [self pageTranslate];
            break;
        default:
            break;
    }
    return block;
}

#pragma mark - Private Method

- (translateBlock)bouncesScaleTranslate
{
    translateBlock bouncesScaleBlock =
    ^(UIView* view,FETranslateDirection direction ,CGFloat maxWidth, CGFloat percent)
    {
        CATransform3D transform = CATransform3DIdentity;
        if (percent>1.0)
        {
            CGFloat distance = view.frame.size.width;
            transform = CATransform3DMakeScale(percent, 1.0, 1.0);
            if(direction == FETranslateDirectionLeft)
            {
                transform = CATransform3DTranslate(transform, distance*(percent-1.0), 0.0f, 0.0f);
            }
            else if(direction == FETranslateDirectionRight)
            {
                transform = CATransform3DTranslate(transform, -distance*(percent-1.0), 0.0f, 0.0f);
            }
            
            [view.layer setTransform:transform];
        }
    };

    return bouncesScaleBlock;
}

- (translateBlock)slideTranslate
{
    translateBlock slideScaleBlock =
    ^(UIView* view,FETranslateDirection direction , CGFloat maxWidth, CGFloat percent)
    {
        if (percent <=1.0)
        {        
            CGFloat maxDistance = 40;
            CGFloat curDistance = maxDistance * percent;
            CATransform3D translateTransform;
            if(direction == FETranslateDirectionLeft)
            {
                translateTransform = CATransform3DMakeTranslation((maxDistance-curDistance), 0.0, 0.0);
            }
            else if(direction == FETranslateDirectionRight)
            {
                translateTransform = CATransform3DMakeTranslation(-(maxDistance-curDistance), 0.0, 0.0);
            }
            [view.layer setTransform:translateTransform];
            [view setAlpha:percent];
        }
        else
        {
            [self bouncesScaleTranslate](view,direction,maxWidth,percent);
        }
    };
    return slideScaleBlock;
}


- (translateBlock)slideScaleTranslate
{
    translateBlock slideScaleBlock =
    ^(UIView* view,FETranslateDirection direction , CGFloat maxWidth, CGFloat percent)
    {
        if (percent<=1.0)
        {
            //scale
            CGFloat minScale = .90;
            CGFloat curScale = minScale + (percent*(1.0-minScale));
            CATransform3D scaleTransform =  CATransform3DMakeScale(curScale, curScale, curScale);
            
            //slide
            CGFloat maxDistance = 40;
            CGFloat curDistance = maxDistance * percent;
            //NSLog(@">>>%f  %f %f",percent , curScale , curDistance);
            CATransform3D translateTransform;
            CGFloat translateX = (maxDistance-curDistance);
            if(direction == FETranslateDirectionLeft)
            {
                translateTransform = CATransform3DMakeTranslation(translateX, 0.0, 0.0);
            }
            else if(direction == FETranslateDirectionRight)
            {
                translateTransform = CATransform3DMakeTranslation(-translateX, 0.0, 0.0);
            }
            [view.layer setTransform:CATransform3DConcat(scaleTransform, translateTransform)];
            [view setAlpha:percent];
        }
        else
        {
            [self bouncesScaleTranslate](view,direction,maxWidth,percent);
        }
    };
    return slideScaleBlock;
}

- (translateBlock)parallaxTranslate:(CGFloat)parallaxFactor
{
    translateBlock parallaxTranslate =
    ^(UIView* view,FETranslateDirection direction,CGFloat maxWidth,CGFloat percent)
    {
        if (percent<=1.0)
        {
            CATransform3D transform = CATransform3DIdentity;
            CGFloat distance = view.frame.size.width;
            if(direction == FETranslateDirectionLeft)
             {
                 transform = CATransform3DMakeTranslation((-distance)/parallaxFactor+(distance*percent/parallaxFactor), 0.0, 0.0);
             }
             else if(direction == FETranslateDirectionRight)
             {
                 transform = CATransform3DMakeTranslation((distance)/parallaxFactor-(distance*percent)/parallaxFactor, 0.0, 0.0);
             }
            [view.layer setTransform:transform];
        }
        else
        {
            [self bouncesScaleTranslate](view,direction,maxWidth,percent);
        }
    };
    return parallaxTranslate;
}


- (translateBlock)swingingDoorTranslate
{
    translateBlock swingingDoorTranslate =
    ^(UIView* view,FETranslateDirection direction ,CGFloat maxWidth, CGFloat percent)
    {
        //CATransition animation.type = @"cube";//[view.layer addAnimation:animation forKey:@"animation"];
        CGPoint anchorPoint = CGPointMake(0.5, 0.5);
        CGFloat maxDrawerWidth = maxWidth;
        CGFloat offsetX = 0.0;
        CGFloat angle   = 0.0;
        
        if(direction == FETranslateDirectionLeft)
        {
            anchorPoint =  CGPointMake(1.0, .5);
            offsetX = -(maxDrawerWidth/2.0) + (maxDrawerWidth)*percent;
            angle = -M_PI_2+(percent*M_PI_2);
        }
        else if(direction == FETranslateDirectionRight)
        {
            anchorPoint = CGPointMake(0.0, .5);
            offsetX = (maxDrawerWidth/2.0) - (maxDrawerWidth)*percent;
            angle   = M_PI_2-(percent*M_PI_2);
        }
        
        [view.layer setAnchorPoint:anchorPoint];
        [view.layer setShouldRasterize:YES];
        [view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        
        //NSLog(@">>>%f %f %f  %f",maxWidth , angle , percent,offsetX);
        CATransform3D cubeTransform = CATransform3DIdentity;
        if (percent <= 1.f)
        {
            
            CATransform3D identity = CATransform3DIdentity;
            identity.m34 = -1.0/1000.0;
            //沿y轴旋转，负角度为向里旋转
            CATransform3D rotateTransform    = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0);
            //沿x偏移，这个主要是为了跟随住显示出的边缘
            CATransform3D translateTransform = CATransform3DMakeTranslation(offsetX, 0.0, 0.0);
            CATransform3D concatTransform    = CATransform3DConcat(rotateTransform, translateTransform);
            cubeTransform = concatTransform;
        }
        else //bounce 
        {
            CATransform3D overshootTransform = CATransform3DMakeScale(percent, 1.f, 1.f);
            NSInteger scalingModifier = (direction == FETranslateDirectionLeft) ? 1.f : -1.f;
            overshootTransform = CATransform3DTranslate(overshootTransform, scalingModifier*maxDrawerWidth/2, 0.f, 0.f);
            cubeTransform = overshootTransform;
        }
        [view.layer setTransform:cubeTransform];
    };
    return swingingDoorTranslate;
}

- (translateBlock)fadeTranslate
{
    translateBlock fadeTranslate =
    ^(UIView* view,FETranslateDirection direction ,CGFloat maxWidth, CGFloat percent)
    {
        [view setAlpha:percent];
    };
    return fadeTranslate;
}

- (translateBlock)pageTranslate
{
    translateBlock pageTranslate =
    ^(UIView* view,FETranslateDirection direction ,CGFloat maxWidth, CGFloat percent)
    {
        
        //以下算法未完成
        return ;
        static UIImageView* imageView = nil;
        static CGImageRef   imageRef = nil;
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width, view.frame.size.height)];
            imageView.userInteractionEnabled = NO;
            
            UIGraphicsBeginImageContext(view.frame.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor grayColor] colorWithAlphaComponent:0.1].CGColor);
            CGContextTranslateCTM(context, view.frame.size.width, 0);
            CGContextScaleCTM(context, -1, 1);
            [view.layer renderInContext:context];
            CGContextFillRect(context, view.bounds);
            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            imageRef = CGBitmapContextCreateImage(context);
            UIGraphicsEndImageContext();
            /*
            NSLog(@">>>%p %@",self,NSTemporaryDirectory());
            NSData* data = UIImagePNGRepresentation(imageView.image);
            [data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"xxx.png"] atomically:YES];
            */
            CAGradientLayer *shadow = [[CAGradientLayer alloc] init];
            shadow.colors =[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0xee /255.0 green:0xee /255.0 blue:0xee /255.0 alpha:0.2].CGColor,(id)[UIColor colorWithRed:0x00 /255.0 green:0x00 /255.0 blue:0x00 /255.0 alpha:0.3].CGColor
                            ,nil];
            shadow.frame = CGRectMake(-10, 0, 10, view.frame.size.height);
            shadow.startPoint = CGPointMake(0, 0.5);
            shadow.endPoint   = CGPointMake(1.0, 0.5);
            imageView.clipsToBounds = NO;
            [imageView.layer addSublayer:shadow];
            [view.superview addSubview:imageView];
        }
        CGFloat posX = maxWidth * percent;
        CGRect rect = imageView.frame;
        rect.origin.x = posX ;
        rect.size.width = view.superview.frame.size.width-posX;
        imageView.frame = rect;
        rect = view.superview.frame;
        rect.origin.x = -(view.superview.frame.size.width - posX);
        view.superview.frame = rect;
        
    };
    return pageTranslate;
}


@end
