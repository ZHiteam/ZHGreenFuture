//
//  AppDelegate.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-25.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHRootViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.rootViewController = [[ZHRootViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    
    [ShareSDK registerApp:SHARE_APPKEY];
    [Crashlytics startWithAPIKey:@"10797bd1166be26204f7f84b2e8e72cda4d1af1a"];
    [self sharReg];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)sharReg{
//    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
//                               appSecret:@"0334252914651e8f76bad63337b3b78f"
//                             redirectUri:@"http://appgo.cn"];
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
//
//    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"
//                                   wbApiCls:[WeiboApi class]];
//    
//    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//    //添加QQ应用  注册网址  http://mobile.qq.com/api/
//    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxe24c063ac9a02073"
                           wechatCls:[WXApi class]];

    [ShareSDK connectWeChatSessionWithAppId:@"wxe24c063ac9a02073"
                                  wechatCls:[WXApi class]];

    [ShareSDK connectWeChatTimelineWithAppId:@"wxe24c063ac9a02073"
                                   wechatCls:[WXApi class]];
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    /// 支付宝回掉
    if ([url.scheme.lowercaseString isEqualToString:@"gf4alipay"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALI_PAY_BACK object:url];
    }

    if ([url.scheme.lowercaseString isEqualToString:@"greenFuture"]) {
        [[MessageCenter instance]performActionWithUrl:url.absoluteString];
    }
    return YES;
}
@end
