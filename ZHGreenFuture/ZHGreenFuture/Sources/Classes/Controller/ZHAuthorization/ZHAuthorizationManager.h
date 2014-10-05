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
@property(nonatomic,strong) NSString*	account;
@property(nonatomic,strong) NSString*	passWord;
@property(nonatomic,strong) NSString*	userId;
@property(nonatomic,strong) NSString*	userNick;
@property(nonatomic,strong) NSString*	userAvatarURL;


+ (instancetype)shareInstance;
- (void)getValidateCodeWithAccount:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block;
- (void)postValidateCode:(NSString*)validateCode account:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block;
- (void)registerWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block;
- (void)logInWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block;
- (void)logout;
@end
