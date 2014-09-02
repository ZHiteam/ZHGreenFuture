//
//  MessageCenter.m
//  ZHGreenFuture
//
//  Created by elvis on 8/30/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "MessageCenter.h"

@implementation MessageCenter

+(id)instance{
    return [MessageCenter instanceWithCLass:[MessageCenter class]];
}


/**
 * @brief : 跳转URL
 */
-(void)performActionWithUrl:(NSString*)url{
    
}

/**
 * @brief : 根据dic展示view
 */
-(void)performActionWithUserInfo:(NSDictionary*)userInfo{
    NSString* ctl =  userInfo[@"controller"];
    
    if (isEmptyString(ctl)){
        ZHLOG(@"跳转页面异常001：\n%@",userInfo);
        return;
    }
    
    Class class = NSClassFromString(ctl);
    if (!class){
        ZHLOG(@"跳转页面异常002：类不识别 %@",userInfo);
        return;
    }
    
    id vc = [[class alloc]init];
    if (![vc isKindOfClass:[ZHViewController class]]){
        ZHLOG(@"跳转页面异常003：类型非ZHViewController");
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

@end
