//
//  ZHAliPayHelper.h
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
//#import "DataSigner.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
//#import "AlixPayOrder.h"
//#import "AlixLibService.h"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611330484194"
//收款支付宝账号
#define SellerID  @"fangxinliang888@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"17vnqvalytgg41982zzwh5ewixctk66b"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANcWAFphTWz6jOokWTIANM5qrzcXE2MV3Hd1hK6Y00pBEEszJz+SQN7vYH5BZmjhRy3W5yhKYUfq0J0+LsiO+6pd7YOxiTBAIqrqko/mhQ1BmdPcOw3ngBgvTLU9LycqoUSDG6RcbWxpvVxGnDeDgH1tGugEUo1YDt0yY+knX3MRAgMBAAECgYAHsIKsuIPTHJYDHO+PaRB6PLgs6QdJaJOsNahbsZ0EL5VMivShQjJNhhNWEDKAF2W7Ds7O0vHtZ0i0BnAXvXzjxpHQwNeshmOFGUkytCQflT3TKuTXQbM23bq3siEEbgB9+9cIi5cCESj+YQogneHVnvx8iJVO1ynANbER3AfnfQJBAPYJFPCLFRQ2WTqQeNKszjSM2GKcTvFnyNpzTA7+WXgWgFTWRfEkRcn0zB5DqirmGFucrCMypR545nPoJXdA778CQQDfzAgx0C0VaQroPtc7TptWUhmpecyPVmr7FOl4aR8YYedvm4i+l4dpXVGMC+NVfpZdaw5rP6fteZ/VLejvaFEvAkEAyBamsuFJaUCx3FD2Ec97e3031SptgSH4VMADkQYFWQZjo5sHEo9/Ojkdb1d0IqMyF/8Ydx+O7XNBZ+3Z2lwzHQJASg6je5BvCtG62UXKRYbqonMCqPF0Ps6TEklGRSFMN+5V/rnSU3ejSLunu5dHgEgmi/1cRSNId64ytQG/PlIf4wJBAMauwfGM5o77CskcsPm9s496J96FtxKHUESyaRmlt1Jc5RbQJGLKlW8Ip9ICA9IuyHF0RDUW6O6rk16+uCUOz5I="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


#import "ShoppingChartModel.h"

@interface ZHAliPayHelper : NSObject

-(void)payWithTitle:(NSString*)productTitle
        productInfo:(NSString*)info
         totalPrice:(NSString*)totalPrice
            orderId:(NSString*)orderId;

-(void)handleOpenUrl:(NSURL*)url;
@end
