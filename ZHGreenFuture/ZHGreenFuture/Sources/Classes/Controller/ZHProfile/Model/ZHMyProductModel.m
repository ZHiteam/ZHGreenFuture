//
//  ZHMyProductModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHMyProductModel.h"

@implementation ZHMyProductItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.workId         = [NSString stringWithFormat:@"%@",[dict objectForKey:@"workId"]];
            self.publishDate    = [dict objectForKey:@"publishDate"];
            self.workImageURL   = [dict objectForKey:@"workImageURL"];
            self.followName     = [dict objectForKey:@"followName"];
            self.content        = [dict objectForKey:@"content"];
            self.workImageURL = [self.workImageURL greenFutureURLStr];
        }
    }
    return self;
}
@end

@implementation ZHMyProductModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMockData];
    }
    return self;
}

- (void)loadDataWithUserAccount:(NSString*)userAccount completionBlock:(ZHCompletionBlock)block{
    
    if ([userAccount length] >0) {
        __weak __typeof(self) weakSelf = self;
        NSString *userId = userAccount;
        userId = [userId length] == 0 ? @"" : userId;

        [HttpClient requestDataWithParamers:@{@"scene": @"30",@"userId": userId} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                [weakSelf parserJsonArray:responseObject];
            }
            if (block) {
                block(YES);
            }

        } failure:^(NSError *error) {
            if (block){
                block(NO);
            }
        }];
    }
}


- (void)loadDetailWithId:(NSString*)workId completionBlock:(ZHCompletionBlock)block{
    if ([workId length] >0) {
        __weak __typeof(self) weakSelf = self;
        
        [HttpClient requestDataWithParamers:@{@"scene": @"31",@"workId": workId} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                weakSelf.productDetail = [[ZHMyProductItem alloc] initWithDictionary:responseObject];
            }
            if (block) {
                block(YES);
            }
            
        } failure:^(NSError *error) {
            if (block){
                block(NO);
            }
        }];
    }

}


#pragma mark - Private Method
- (void)initMockData{
    ZHMyProductItem *product = [[ZHMyProductItem alloc] init];
    product.workId = @"";
    product.publishDate    = @"8月6日 15:30";
    product.workImageURL   = @"";
    product.followName     = @"可乐鸡";
    product.content        = @"首秀，非常成功！色香味俱全！首秀，非常成功！色香味俱全！首秀，非常成功！色香味俱全！";
    self.myProductList     = @[product,product];
}


- (void)parserJsonArray:(NSArray*)jsonArray{
    if ([jsonArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *orderItem in jsonArray) {
            ZHMyProductItem * obj = [[ZHMyProductItem alloc] initWithDictionary:orderItem];
            [dstArray addObject:obj];
        }
        self.myProductList = [dstArray copy];
    }
}
@end
