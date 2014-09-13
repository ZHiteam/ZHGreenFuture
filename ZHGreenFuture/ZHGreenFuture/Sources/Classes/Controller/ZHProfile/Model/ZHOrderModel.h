//
//  ZHOrderModel.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHOrderProduct : NSObject
@property(nonatomic, strong)NSString *imageURL;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *skuInfo;
@property(nonatomic, strong)NSString *promotionPrice;
@property(nonatomic, strong)NSString *buyCount;
@property(nonatomic, strong)NSString *productId;

@end

@interface ZHOrderInfo : NSObject
@property(nonatomic, strong)NSString *orderTime;
@property(nonatomic, strong)NSString *orderStatus;
@property(nonatomic, strong)NSString *productCount;
@property(nonatomic, strong)NSString *totalPrice;
@property(nonatomic, strong)NSString *orderId;
@property(nonatomic, strong)NSArray *productLists;//ZHOrderProduct

@end

typedef NS_ENUM(NSInteger, ZHOrderType) {
    ZHOrderTypeAll,
    ZHOrderTypeWaitPay,
    ZHOrderTypeWaitDeliver,
    ZHOrderTypeWaitReceive,
    ZHOrderTypeWaitComment,
};

@interface ZHOrderModel : NSObject
@property(nonatomic, assign)NSInteger orderType;
@property(nonatomic, strong)NSArray *orderLists;//ZHOrderInfo

@end
