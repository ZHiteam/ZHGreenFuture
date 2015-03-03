//
//  PayHelper.m
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "PayHelper.h"
#import "ZHAliPayHelper.h"

@interface PayHelper()
@property (nonatomic,strong) ZHAliPayHelper*    alipay;

@end

@implementation PayHelper

-(instancetype)init{
    self = [super init];
    if (self){
        self.alipay = [[ZHAliPayHelper alloc]init];
    }
    return self;
}

+(id)instance{
    return [PayHelper instanceWithCLass:[PayHelper class]];
}

+(void)aliPayWithTitle:(NSString *)productTitle productInfo:(NSString *)info totalPrice:(NSString *)totalPrice orderId:(NSString *)orderId{
    PayHelper* helper = [PayHelper instance];
    
    [helper.alipay payWithTitle:productTitle productInfo:info totalPrice:totalPrice orderId:orderId];
}

+(void)handleOpenUrl:(NSURL *)url{
    PayHelper* helper = [PayHelper instance];
    [helper.alipay handleOpenUrl:url];
}
@end
