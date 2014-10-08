//
//  TagModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/3/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

+(id)praserModelWithInfo:(id)info{
    TagModel* model = [[TagModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    NSDictionary* dic = (NSDictionary*)info;
    
    model.tagName   = VALIDATE_VALUE(dic[@"name"]);
    model.tagId     = VALIDATE_VALUE(dic[@"tagId"]);
    
    return model;
}
@end
