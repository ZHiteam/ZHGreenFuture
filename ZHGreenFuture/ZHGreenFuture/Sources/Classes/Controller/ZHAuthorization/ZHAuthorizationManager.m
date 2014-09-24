//
//  ZHAuthorizationManager.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationManager.h"

#define kAccountInfo					@"kAccountInfo"
#define kPassWordInfo					@"kPassWordInfo"
#define koldAccountInfo					@"koldAccountInfo"
#define kisHaveRegisterAccount			@"kIsHaveRegisterAccount"


@interface ZHAuthorizationManager ()

@end

@implementation ZHAuthorizationManager

+ (instancetype)shareInstance{
    static ZHAuthorizationManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZHAuthorizationManager alloc] init];
    });
    return shareInstance;
}

- (id)init
{
	self = [super init];
	if (self) {
		NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
		self.account  = [userDefault objectForKey:kAccountInfo];
		self.passWord = [userDefault objectForKey:kPassWordInfo];
	}
	return self;
}

- (void)dealloc
{
	self.account  = nil;
	self.passWord = nil;
}

#pragma mark - Public Methods
- (BOOL)isLogin {
    return [self.passWord length] >0;
}

- (void)getValidateCodeWithAccount:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block{
    if ([account length] >0 ) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        [manager POST:BASE_URL parameters:@{@"scene": @"24",@"phone":account} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BOOL result = NO;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"] boolValue]) {
                    result = YES;
                }
            }
            if (block) {
                block(result,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }

}

- (void)postValidateCode:(NSString*)validateCode account:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block{
    if ([account length] >0 && [validateCode length] >0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        [manager POST:BASE_URL parameters:@{@"scene": @"25",@"phone":account,@"validateCode":validateCode} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            BOOL result = NO;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"] boolValue]) {
                    result = YES;
                }
            }
            if (block) {
                block(result,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }

}


- (void)registerWithAccount:(NSString*)account password:(NSString*)password  completionBlock:(ZHAuthCompletionBlock)block{
    
    if ([account length] >0 && [password length] >0) {
        __weak __typeof(self) weakSelf = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        [manager POST:BASE_URL parameters:@{@"scene": @"26",@"phone":account,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            BOOL result = NO;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"] boolValue]) {
                    weakSelf.account  = account;
                    weakSelf.passWord = password;
                    [weakSelf setAccountInfo];
                    result = YES;
                }
            }
            if (block) {
                block(result,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }
}

- (void)logInWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block
{
    if ([account length] >0 && [password length] >0) {
        __weak __typeof(self) weakSelf = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        [manager POST:BASE_URL parameters:@{@"scene": @"23",@"phone":account,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                weakSelf.userId         = [responseObject objectForKey:@"userId"];
                weakSelf.userNick       = [responseObject objectForKey:@"userNick"];
                weakSelf.userAvatarURL  = [responseObject objectForKey:@"userAvatarURL"];
            }
            weakSelf.account  = account;
            weakSelf.passWord = password;
            [weakSelf setAccountInfo];
            if (block) {
                
                /// modify by kongkong
                if (isEmptyString(weakSelf.userId)){
                    block(NO,nil);
                }
                else{
                    block(YES,nil);
                }

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }
}

#pragma mark - Private
- (void)setAccountInfo
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:YES			 forKey:kisHaveRegisterAccount];
	[userDefault setObject:self.account  forKey:kAccountInfo];
	[userDefault setObject:self.passWord forKey:kPassWordInfo];
	[userDefault synchronize];
}

- (void)resetAccountInfo
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:NO			 forKey:kisHaveRegisterAccount];
	[userDefault removeObjectForKey:kAccountInfo];
	[userDefault removeObjectForKey:kPassWordInfo];
	[userDefault synchronize];
}


@end
