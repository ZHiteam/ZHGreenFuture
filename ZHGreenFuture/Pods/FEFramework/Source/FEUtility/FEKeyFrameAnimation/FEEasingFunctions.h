//
//  FEEasingFunctions.h
//  FEEasingFunctions
//
//  Created by xxx on 13-9-29.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

typedef double (*FEEasingFunction)(double);

// Linear interpolation (no easing)
double LinearInterpolation(double p);

// Quadratic easing; p^2
double QuadraticEaseIn(double p);
double QuadraticEaseOut(double p);
double QuadraticEaseInOut(double p);

// Cubic easing; p^3
double CubicEaseIn(double p);
double CubicEaseOut(double p);
double CubicEaseInOut(double p);

// Quartic easing; p^4
double QuarticEaseIn(double p);
double QuarticEaseOut(double p);
double QuarticEaseInOut(double p);

// Quintic easing; p^5
double QuinticEaseIn(double p);
double QuinticEaseOut(double p);
double QuinticEaseInOut(double p);

// Sine wave easing; sin(p * PI/2)
double SineEaseIn(double p);
double SineEaseOut(double p);
double SineEaseInOut(double p);

// Circular easing; sqrt(1 - p^2)
double CircularEaseIn(double p);
double CircularEaseOut(double p);
double CircularEaseInOut(double p);

// Exponential easing, base 2
double ExponentialEaseIn(double p);
double ExponentialEaseOut(double p);
double ExponentialEaseInOut(double p);

// Exponentially-damped sine wave easing
double ElasticEaseIn(double p);
double ElasticEaseOut(double p);
double ElasticEaseInOut(double p);

// Overshooting cubic easing; 
double BackEaseIn(double p);
double BackEaseOut(double p);
double BackEaseInOut(double p);

// Exponentially-decaying bounce easing
double BounceEaseIn(double p);
double BounceEaseOut(double p);
double BounceEaseInOut(double p);

