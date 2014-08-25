//
//  UIView+FEHierarchy.m
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIView+FEHierarchy.h"

@implementation UIView (FEHierarchy)

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }
    for (UIView *view in self.subviews)
    {
        UIView *match = [view viewMatchingPredicate:predicate];
        if (match) return match;
    }
    return nil;
}

- (UIView *)viewWithTag:(NSInteger)tag ofClass:(Class)class
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:class];
                                        }]];
}

- (UIView *)viewOfClass:(Class)class
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [evaluatedObject isKindOfClass:class];
                                        }]];
}

- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate
{
    NSMutableArray *matches = [NSMutableArray array];
    if ([predicate evaluateWithObject:self])
    {
        [matches addObject:self];
    }
    for (UIView *view in self.subviews)
    {
        //check for subviews
        //avoid creating unnecessary array
        if ([view.subviews count])
        {
        	[matches addObjectsFromArray:[view viewsMatchingPredicate:predicate]];
        }
        else if ([predicate evaluateWithObject:view])
        {
            [matches addObject:view];
        }
    }
    return matches;
}

- (NSArray *)viewsWithTag:(NSInteger)tag
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject tag] == tag;
                                         }]];
}

- (NSArray *)viewsWithTag:(NSInteger)tag ofClass:(Class)class
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:class];
                                         }]];
}

- (NSArray *)viewsOfClass:(Class)class
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject isKindOfClass:class];
                                         }]];
}

- (UIView *)firstSuperviewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }
    return [self.superview firstSuperviewMatchingPredicate:predicate];
}

- (UIView *)firstSuperviewOfClass:(Class)class
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, NSDictionary *bindings) {
        return [superview isKindOfClass:class];
    }]];
}

- (UIView *)firstSuperviewWithTag:(NSInteger)tag
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, NSDictionary *bindings) {
        return superview.tag == tag;
    }]];
}

- (UIView *)firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)class
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, NSDictionary *bindings) {
        return superview.tag == tag && [superview isKindOfClass:class];
    }]];
}

- (BOOL)viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return YES;
    }
    return [self.superview viewOrAnySuperviewMatchesPredicate:predicate];
}

- (BOOL)viewOrAnySuperviewIsKindOfClass:(Class)class
{
    return [self viewOrAnySuperviewMatchesPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, NSDictionary *bindings) {
        return [superview isKindOfClass:class];
    }]];
}

- (BOOL)isSuperviewOfView:(UIView *)view
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, NSDictionary *bindings) {
        return superview == view;
    }]] != nil;
}

- (BOOL)isSubviewOfView:(UIView *)view
{
    return [view isSuperviewOfView:self];
}

//responder chain

- (UIViewController *)firstViewController
{
    id responder = self;
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return responder;
        }
    }
    return nil;
}

- (UIView *)firstResponder
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isFirstResponder];
    }]];
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls{
    UIView* superView = self;
    while (superView) {
        if ([superView isKindOfClass:cls]) {
            return superView;
        }
        superView = [superView superview];
    }
    return nil;
}

- (UIView*)descendantOrSelfWithClass:(Class)cls{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:cls];
    }]];
}

@end
