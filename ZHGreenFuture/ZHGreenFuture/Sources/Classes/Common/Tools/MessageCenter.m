//
//  MessageCenter.m
//  ZHGreenFuture
//
//  Created by elvis on 8/30/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "MessageCenter.h"
#import "ZHRootViewController.h"
#import "TabbarViewController.h"

@implementation MessageCenter

+(id)instance{
    return [MessageCenter instanceWithCLass:[MessageCenter class]];
}

-(instancetype)init{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyAction:) name:NOTIFY_TRADE_STATE object:nil];
    }
    
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 * @brief : 跳转URL
 */
-(void)performActionWithUrl:(NSString*)urlStr{
    //greenfuture://productDetail/topath?productId=4
    //[scheme]://[host]/[path]?[query]
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([url.scheme isEqualToString:@"greenfuture"]) {
        NSDictionary *queryDict = [NSDictionary dictionaryWithURLQuery:url.query];
        NSString *host = url.host;
        if ([host length] >0) {
            //这里规则就暂时写死吧。
            if ([host isEqualToString:@"productDetail"]) {
                NSString*productId = [queryDict objectForKey:@"productId"];
                ZHGotoDetailVC(productId);
            } else if ([host isEqualToString:@"catagoryDetail"]) {
                NSString*categoryId = [queryDict objectForKey:@"categoryId"];
                NSString*type = [queryDict objectForKey:@"type"];
                ZHGotoCategoryDetailVC(categoryId,type);
            } else if ([host isEqualToString:@"tabbar"]) {
                NSString*tabbarId = [queryDict objectForKey:@"tabbarId"];
                ZHGotoTabbarVC(tabbarId);
            }
        }
    } else if ([url.scheme isEqualToString:@"http"]){
        ZHGotoWebVC(urlStr);
    }
}

/**
 * @brief : 根据dic展示view
 */
-(void)performActionWithUserInfo:(NSDictionary*)userInfo{
    NSString* ctl =  userInfo[@"controller"];
    
    if (isEmptyString(ctl)){
        FELOG(@"跳转页面异常001：\n%@",userInfo);
        return;
    }
    
    Class class = NSClassFromString(ctl);
    if (!class){
        FELOG(@"跳转页面异常002：类不识别 %@",userInfo);
        return;
    }
    
    id vc = [[class alloc]init];
    if (![vc isKindOfClass:[ZHViewController class]]){
        FELOG(@"跳转页面异常003：类型非ZHViewController");
    }
    
    ZHViewController* viewCtl = (ZHViewController*)vc;
    
    NSString* title = userInfo[@"title"];
    if (!isEmptyString(title)){
        [viewCtl.navigationBar setTitle:title];
    }
    
    id info = userInfo[@"userinfo"];
    if (info){
        viewCtl.userInfo = info;
    }
    
    NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    
    NSString* animation = userInfo[@"fullscreen"];
    if (0 == [animation intValue]){
        [navi pushViewController:viewCtl];
    }
    else if (1 == [animation intValue]){
        [navi pushViewController:viewCtl animation:ANIMATE_TYPE_HORIZONTAL];
    }
    else{
        [navi pushViewController:viewCtl animation:ANIMATE_TYPE_NONE];
    }

}

-(void)notifyAction:(NSNotification*)notify{
    NSDictionary* info = notify.object;
    if (![info isKindOfClass:[NSDictionary class]]){
        return;
    }
    
    BaseModel* model = [BaseModel praserModelWithInfo:info];
    if (![model.state boolValue]){
        NSString* msg = info[@"msg"];
        if (!isEmptyString(msg)){
            msg = @"支付失败";
        }
        SHOW_MESSAGE(msg, 2);
    }
    else{
        SHOW_MESSAGE(@"支付成功", 2);
    }
    [self jumpToOrderList];
}

-(void)jumpToOrderList{
    NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [navi popWithAnimation:NO];
//    [self.navigationCtl popWithAnimation:NO];
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHOrderListVC"}];
}

@end
