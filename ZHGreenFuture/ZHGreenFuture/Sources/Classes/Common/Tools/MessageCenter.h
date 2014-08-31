//
//  MessageCenter.h
//  ZHGreenFuture
//
//  Created by elvis on 8/30/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCenter : NSObject

/**
 * @brief : 获取实例
 */
+(id)instance;


/**
 * @brief : 跳转URL
 */
-(void)performActionWithUrl:(NSString*)url;

/**
 * @brief : 根据dic展示view
 * @param : - controller         (NSString) 跳转Controller类
 *          - fullscreen(可选)    (NSStrinh) 0:全屏（默认）      1:Tabbar不隐藏
 *          - animation(可选)     (NSString) 0:左侧滑入（默认）   1:下面滑入   -1:没动画
 *          - title(可选)         (NSString) 标题
 */
-(void)performActionWithUserInfo:(NSDictionary*)userInfo;

@end
