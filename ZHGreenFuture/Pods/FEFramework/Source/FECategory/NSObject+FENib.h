//
//  NSObject+FENib.h
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FENib)
+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner;
+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner index:(NSUInteger)index;
+ (id)instanceWithNibName1:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner;
@end
