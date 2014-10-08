//
//  ZHProductItem.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHProductItem.h"

@implementation ZHProductItem
- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL  = [dict objectForKey:@"imageURL"];
            self.title     = [dict objectForKey:@"title"];
            self.subTitle  = [dict objectForKey:@"subTitle"];
            self.price     = [dict objectForKey:@"price"];
            self.buyCount = VALIDATE_VALUE([dict objectForKey:@"buyCount"]);
            self.productId = VALIDATE_VALUE([dict objectForKey:@"productId"]);
        }
    }
    return self;
}

+(id)praserModelWithInfo:(id)info{
    return [[ZHProductItem alloc]initWithDictionary:info];
}
@end
