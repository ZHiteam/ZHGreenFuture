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

+(id)praserModelWithInfo:(id)info{
    RecipeExampleImageContent* model = [[RecipeExampleImageContent alloc]init];
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.content = dic[@"content"];
    model.url = dic[@"url"];
    
    return model;
}

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