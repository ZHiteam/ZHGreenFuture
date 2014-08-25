//
//  UIView+FEHierarchy.h
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//
//https://github.com/inamiy/ViewUtils

#import <UIKit/UIKit.h>

@interface UIView (FEHierarchy)

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate;
- (UIView *)viewWithTag:(NSInteger)tag ofClass:(Class)class;
- (UIView *)viewOfClass:(Class)class;
- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)viewsWithTag:(NSInteger)tag;
- (NSArray *)viewsWithTag:(NSInteger)tag ofClass:(Class)class;
- (NSArray *)viewsOfClass:(Class)class;

- (UIView *)firstSuperviewMatchingPredicate:(NSPredicate *)predicate;
- (UIView *)firstSuperviewOfClass:(Class)class;
- (UIView *)firstSuperviewWithTag:(NSInteger)tag;
- (UIView *)firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)class;

- (BOOL)viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate;
- (BOOL)viewOrAnySuperviewIsKindOfClass:(Class)class;
- (BOOL)isSuperviewOfView:(UIView *)view;
- (BOOL)isSubviewOfView:(UIView *)view;

- (UIViewController *)firstViewController;
- (UIView *)firstResponder;
- (UIView*)ancestorOrSelfWithClass:(Class)cls;
- (UIView*)descendantOrSelfWithClass:(Class)cls;
@end
