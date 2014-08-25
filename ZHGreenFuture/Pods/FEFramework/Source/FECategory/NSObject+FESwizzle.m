//
//  NSObject+FESwizzle.m
//  FEStubApp
//
//  Created by xxx on 14-3-7.
//  Copyright (c) 2014年 FE. All rights reserved.
//

#import "NSObject+FESwizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>

//Swizzle the instance method implementations
static void swizzleIntanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

//Swizzle the class method implementations
static void swizzleClassMethod(Class c, SEL orig, SEL new)
{
    //http://www.cocoawithlove.com/2010/01/what-is-meta-class-in-objective-c.html
    //http://stackoverflow.com/questions/3267506/how-to-swizzle-a-class-method-on-ios
    c = object_getClass((id)c);
    
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


@implementation NSObject (FESwizzle)
+ (void)swizzleClassMethod:(BOOL)isClass origSel:(SEL)origSel newImp:(IMP)newImp{
    [self swizzleClassMethod:isClass origSel:origSel newImp:newImp origImp:nil];
}

+ (void)swizzleClassMethod:(BOOL)isClass origSel:(SEL)origSel newImp:(IMP)newImp origImp:(IMP*)origImp{
    if (origSel && newImp) {
        Class cls = [self class];
        Method origMethod =  isClass ? class_getClassMethod(cls, origSel) : class_getInstanceMethod(cls, origSel);
        Class  className  = isClass ? object_getClass(cls) : cls;
        const char *encoding = method_getTypeEncoding(origMethod);
        
        //genenrate new selector with kFESwizzlePrefix
        NSString *selStr = NSStringFromSelector(origSel);
        NSString *newSelStr = [NSString stringWithFormat:@"%@%@",kFESwizzlePrefix, selStr];
        SEL newSel = NSSelectorFromString(newSelStr);
        class_addMethod(className, newSel, newImp, encoding);
        
        //get orignal implement
        if (origImp) {
             *origImp = method_getImplementation(origMethod);
        }
        //swizzle
        if (isClass) {
            swizzleClassMethod(cls, origSel, newSel);
        }else{
            swizzleIntanceMethod(cls, origSel, newSel);
        }
    }
}

+ (char*)returnTypeWithSelector:(SEL)sel  isClassMethod:(BOOL)isClass{
    //const char *returnType = [signature methodReturnType];
    // NSInteger returnLength = [signature methodReturnLength];
    char *returnType = nil;
    Class cls = [self class];
    Method method =  isClass ? class_getClassMethod(cls, sel) : class_getInstanceMethod(cls, sel);
    if (method) {
        returnType = method_copyReturnType(method);
    }
    return returnType;
}
@end
