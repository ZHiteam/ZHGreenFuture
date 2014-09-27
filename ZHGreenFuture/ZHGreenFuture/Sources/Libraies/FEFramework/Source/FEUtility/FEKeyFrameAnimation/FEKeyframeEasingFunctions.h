//
//  FEKeyframeEasingFunctions.h
//  FEKeyframeEasingFunctions
//
//  Created by xxx on 13-9-29.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#pragma mark - 
/*
    xxx
     - (NSArray *)generateValuesFrom:(double)startValue to:(double)endValue
     {
     NSUInteger steps = (NSUInteger)ceil(kFPS * self.duration) + 2;
     NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:steps];
     const double increment = 1.0 / (double)(steps - 1);
     double progress = 0.0,
     value = 0.0;
     
     NSUInteger i;
     for (i = 0; i < steps; i++)
     {
     //v = timeFunction(self.duration * progress * 1000, 0, 1, self.duration * 1000);
     //value = startValue + v * (endValue - startValue);
     value = f(self.duration * progress * 1000, startValue, endValue, self.duration * 1000);

     [valueArray addObject:[NSNumber numberWithDouble:value]];
     
     progress += increment;
     }
     return [NSArray arrayWithArray:valueArray];
     }
 */

typedef double (*FEKeyframeEasingFunction)(double, double, double, double);

double FEKeyframeEasingFunctionEaseInQuad(double t,double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutQuad(double t,double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutQuad(double t,double b, double c, double d);

double FEKeyframeEasingFunctionEaseInCubic(double t,double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutCubic(double t,double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutCubic(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInQuart(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutQuart(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutQuart(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInQuint(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutQuint(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutQuint(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInSine(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutSine(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutSine(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInExpo(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutExpo(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutExpo(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInCirc(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutCirc(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutCirc(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInElastic(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutElastic(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutElastic(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInBack(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutBack(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutBack(double t, double b, double c, double d);

double FEKeyframeEasingFunctionEaseInBounce(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseOutBounce(double t, double b, double c, double d);
double FEKeyframeEasingFunctionEaseInOutBounce(double t, double b, double c, double d);
