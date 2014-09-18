//
//  RecpieExampleModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "RecpieExampleModel.h"

@implementation RecpieExampleModel

@end


@implementation RecipeExampleImageContent

- (NSString*)title{
    return self.content;
}
- (NSString*)imageURL{
    return self.url;
}
- (NSInteger)tag{
    return 0;
}
@end