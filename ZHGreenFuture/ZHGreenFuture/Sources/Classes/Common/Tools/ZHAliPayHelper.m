//
//  ZHAliPayHelper.m
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAliPayHelper.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayResult.h"
#import "JSONKit.h"

@implementation ZHAliPayHelper

-(instancetype)init{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyAction:) name:NOTIFY_ALI_PAY_BACK object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)payWithTitle:(NSString *)productTitle productInfo:(NSString *)info totalPrice:(NSString *)totalPrice orderId:(NSString *)orderId{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = productTitle; //商品标题
    order.productDescription = info; //商品描述
//#ifdef DEBUG
//    order.amount                = @"0.01";
//#else
    order.amount                = totalPrice;
//#endif

    order.notifyURL =  [NSString stringWithFormat:@"%@/%@/alipayNotify.action",BASE_SITE,SCHEME]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"gf4alipay";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
            [self payResult:resultDic];
        }];
        
    }

}

- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

#pragma -mark deal result
-(void)notifyAction:(NSNotification*)notify{
    id val = notify.object;
    if ([val isKindOfClass:[NSURL class]]){
        [self handleOpenUrl:val];
    }
}

-(void)payResult:(NSDictionary*)resultDic{
//    NSLog(@"%@",result);
    
    AlixPayResult* result = [[AlixPayResult alloc]initWithString:[resultDic JSONString]];
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            //交易成功
            NSString* key = AlipayPubKey;///@"签约帐户后获取到的支付宝公钥";
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                FELOG(@"交易成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_TRADE_STATE object:@{@"result":@"1"}];
            }
            
        }
        else
        {
            //交易失败
            NSString* status = [NSString stringWithFormat:@"Error:1002, %@",result.statusMessage];
            NSDictionary* info = @{@"result":@"0"};
            if (!isEmptyString(status)){
                info = @{@"result":@"0",@"msg":status};
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_TRADE_STATE object:info];
        }
    }
    else
    {
        //失败
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_TRADE_STATE object:@{@"result":@"0",@"msg":@"Error:1003, 交易失败"}];
    }
}

-(void)handleOpenUrl:(NSURL *)url{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self payResult:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self payResult:resultDic];
        }];
    }
}

@end
