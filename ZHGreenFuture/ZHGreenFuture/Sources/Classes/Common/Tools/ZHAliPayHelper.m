//
//  ZHAliPayHelper.m
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAliPayHelper.h"

#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

#import "AlixLibService.h"

@implementation ZHAliPayHelper

-(void)payWithTitle:(NSString *)productTitle productInfo:(NSString *)info totalPrice:(NSString *)totalPrice orderId:(NSString *)orderId{
    /*
     *生成订单信息及签名
     *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
     */
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO               = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName           = productTitle; //商品标题
    order.productDescription    = info; /// 商品描述
    order.amount                = totalPrice;
    order.notifyURL             =  @"http%3A%2F%2Fwwww.greenFuture.com"; //回调URL
    
    NSString* orderInfo = [order description];
    
    NSString *appScheme = @"greenFuture";

    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
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

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                SHOW_MESSAGE(@"Error:1001, 交易失败", 2);
            }
        }
        else
        {
            //交易失败
            SHOW_MESSAGE(@"Error:1002, 交易失败", 2);
        }
    }
    else
    {
        //失败
        SHOW_MESSAGE(@"Error:1003, 交易失败", 2);
    }
    
}

@end
