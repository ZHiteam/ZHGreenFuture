//
//  ZHAuthorizationManager.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZHAuthCompletionBlock)(BOOL isSuccess, id info);

@interface ZHAuthorizationManager : NSObject
@property(nonatomic,assign) BOOL        isLogin;
@property(nonatomic,retain) NSString*	account;
@property(nonatomic,retain) NSString*	passWord;

+ (instancetype)shareInstance;
- (void)registerWithAccount:(NSString*)account password:(NSString*)password referral:(NSString*)referral completionBlock:(ZHAuthCompletionBlock)block;
- (void)logInWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block;
@end
