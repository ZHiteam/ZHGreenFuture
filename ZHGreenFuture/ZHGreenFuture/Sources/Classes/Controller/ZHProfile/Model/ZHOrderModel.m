//
//  ZHOrderModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderModel.h"
#import "ZHAuthorizationManager.h"

@implementation ZHOrderProduct
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            self.imageURL   = [dict objectForKey:@"imageURL"];
            self.title      = [dict objectForKey:@"title"];
            self.skuInfo    = [dict objectForKey:@"subTitle"];
            self.promotionPrice = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] floatValue]];
            self.buyCount   = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"buyCount"] integerValue]];
            self.productId  = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"productId"] integerValue]];
        }
    }
    return self;
}
@end

@implementation ZHOrderInfo
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.orderTime    = [dict objectForKey:@"orderTime"];
            self.orderStatus  = [dict objectForKey:@"orderStatus"];
            self.productCount     = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"productCount"] integerValue]];
            self.totalPrice  = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"totalPrice"] floatValue]];
            self.orderId     = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"orderId"] integerValue]];

            NSArray *srcArray = nil;
            NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
            //orderLists
            srcArray = [dict objectForKey:@"productList"];
            for (NSDictionary *orderItem in srcArray) {
                ZHOrderProduct * obj = [[ZHOrderProduct alloc] initWithDictionary:orderItem];
                [dstArray addObject:obj];
            }
            self.productLists = [dstArray copy];
        }
    }
    return self;
}
@end


@interface ZHOrderModel ()
@property(nonatomic, assign)BOOL isRuning;
@end

@implementation ZHOrderModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMockData];
    }
    return self;
}

#pragma mark - Public Method

- (void)loadDataWithType:(ZHOrderType)type completionBlock:(ZHCompletionBlock)block{
    if (!self.isRuning) {
        self.isRuning = YES;
        self.orderType = type;
        __weak __typeof(self) weakSelf = self;
        NSString *userId = [[ZHAuthorizationManager shareInstance] userId];
        userId = [userId length] > 0 ? userId : @"" ;
        [HttpClient requestDataWithParamers:@{@"scene": @"21",@"userId": userId, @"orderType":[NSString stringWithFormat:@"%d",type]} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [weakSelf parserJsonDict:responseObject];
            }
            if (block) {
                block(YES);
            }
            weakSelf.isRuning = NO;
        } failure:^(NSError *error) {
            if (block){
                block(NO);
            }
            weakSelf.isRuning = NO;
        }];
    }
}

- (void)modifyOrderStatusWithOrderId:(NSString*)orderId operation:(NSString*)operation completionBlock:(ZHCompletionBlock)block{
    if ([orderId length] >0 && [operation length] >0) {
        NSString *userId = [[ZHAuthorizationManager shareInstance] userId];
        userId = [userId length] == 0 ? @"" : userId;
        
        [HttpClient requestDataWithParamers:@{@"scene": @"22",@"userId": userId, @"orderId":orderId, @"operation" : operation} success:^(id responseObject) {
            BOOL result = NO;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                result =[[responseObject objectForKey:@"result"] isEqualToString:@"true"];
            }
            if (block) {
                block(result);
            }
        } failure:^(NSError *error) {
            if (block){
                block(NO);
            }
        }];
    }
}

#pragma mark - Privte Method
- (void)initMockData{
    
    ZHOrderProduct *product = [[ZHOrderProduct alloc] init];
    product.imageURL = @"";
    product.title    = @"【三千禾】东北农家黑荞麦 粗粮 五谷杂粮";
    product.skuInfo  = @"重量：500g；礼盒装";
    product.promotionPrice = @"9.89";
    product.buyCount = @"1";

    ZHOrderInfo *orderInfo = [[ZHOrderInfo alloc] init];
    orderInfo.orderTime   = @"2014-08-06 09:23";
    orderInfo.orderStatus = @"交易成功";
    orderInfo.productCount= @"2";
    orderInfo.totalPrice  = @"19.78";
    orderInfo.productLists= @[product,product];
    self.orderLists = @[orderInfo,orderInfo];
}


- (void)parserJsonDict:(NSDictionary*)jsonDict{
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSInteger orderType = [[jsonDict objectForKey:@"orderType"] integerValue];
            NSAssert(orderType == self.orderType, @"orderType un consistency");
            
            NSArray *srcArray = nil;
            NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
            //orderLists
            srcArray = [jsonDict objectForKey:@"orderList"];
            for (NSDictionary *orderItem in srcArray) {
                ZHOrderInfo * obj = [[ZHOrderInfo alloc] initWithDictionary:orderItem];
                [dstArray addObject:obj];
            }
            self.orderLists = [dstArray copy];
        }
}

@end
