//
//  ZHOrderModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderModel.h"

@implementation ZHOrderProduct
@end

@implementation ZHOrderInfo
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


- (void)loadDataWithType:(ZHOrderType)type completionBlock:(ZHCompletionBlock)block{
    self.orderType = type;
}
@end
