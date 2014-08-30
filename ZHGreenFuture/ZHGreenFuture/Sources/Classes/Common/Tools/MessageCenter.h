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
 */
-(void)performActionWithUserInfo:(NSDictionary*)userInfo;

@end
