//
//  NSObject+FENib.m
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "NSObject+FENib.h"

@implementation NSObject (FENib)
+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner{
    return [self instanceWithNibName:nibNameOrNil bundle:bundleOrNil owner:owner index:0];
}


+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner index:(NSUInteger)index{
    //default values
    NSString *nibName = nibNameOrNil ?: NSStringFromClass(self);
    NSBundle *bundle = bundleOrNil ?: [NSBundle mainBundle];
    id resultObj = nil;
    //cache nib to prevent unnecessary filesystem access
    static NSCache *nibCache = nil;
    if (nibCache == nil)
    {
        nibCache = [[NSCache alloc] init];
    }
    NSString *pathKey = [NSString stringWithFormat:@"%@.%@", bundle.bundleIdentifier, nibName];
    UINib *nib = [nibCache objectForKey:pathKey];
    if (nib == nil){
        NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
        if (nibPath) nib = [UINib nibWithNibName:nibName bundle:bundle];
        [nibCache setObject:nib ?: [NSNull null] forKey:pathKey];
    }
    else if ([nib isKindOfClass:[NSNull class]]){
        nib = nil;
    }
    
    if (nib){
        //attempt to load from nib
        NSArray *contents = [nib instantiateWithOwner:owner options:nil];
        resultObj = [contents count] >index? [contents objectAtIndex:index]: nil;
    }else{
        NSArray *objectArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        resultObj = [objectArray count] >index? [objectArray objectAtIndex:index] : nil;
    }
    return resultObj;
}

+ (id)instanceWithNibName1:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner
{
    NSString *nibName = nibNameOrNil ?: NSStringFromClass(self);
    id resultObj = nil;
    static  const UINib *cellNib = nil;//缓存，这样就不需要每次加载
    if (cellNib == nil) {
        cellNib = [UINib nibWithNibName:nibName bundle:bundleOrNil];
    }
    
    if (cellNib) {
        NSArray *objectArray = [cellNib instantiateWithOwner:nil options:nil];
        resultObj = [objectArray count] ? [objectArray objectAtIndex:0] : nil;
    }else{
        NSArray *objectArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        resultObj = [objectArray count] ? [objectArray objectAtIndex:0] : nil;
    }
    return resultObj;
}

@end
