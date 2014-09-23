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
            if ([[dict objectForKey:@"buyCount"] isKindOfClass:[NSNumber class]]) {
                self.buyCount = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"buyCount"] integerValue]];
            } else {
                self.buyCount = [dict objectForKey:@"buyCount"];
            }
            
            if ([[dict objectForKey:@"productId"] isKindOfClass:[NSNumber class]]) {
                self.productId = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"productId"] integerValue]];
            } else {
                self.productId = [dict objectForKey:@"productId"];
            }
        }
    }
    return self;
}

+(id)praserModelWithInfo:(id)info{
    return [[ZHProductItem alloc]initWithDictionary:info];
}
@end
