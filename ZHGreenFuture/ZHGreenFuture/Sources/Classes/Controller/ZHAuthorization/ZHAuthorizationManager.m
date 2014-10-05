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

        [HttpClient postDataWithParamers:@{@"scene": @"24",@"phone":account} success:^(id responseObject) {
            BOOL result = [((BaseModel*)[BaseModel praserModelWithInfo:responseObject]).state boolValue];
            if (block) {
                block(result,nil);
            }

        } failure:^(NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }

}

- (void)postValidateCode:(NSString*)validateCode account:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block{
    if ([account length] >0 && [validateCode length] >0) {
        [HttpClient postDataWithParamers:@{@"scene": @"25",@"phone":account,@"validateCode":validateCode} success:^(id responseObject) {
            BOOL result = [((BaseModel*)[BaseModel praserModelWithInfo:responseObject]).state boolValue];
            if (block) {
                block(result,nil);
            }
        } failure:^(NSError *error) {
            if (block) {
                block(NO,nil);
            }
        }];
    }

}


- (void)registerWithAccount:(NSString*)account password:(NSString*)password  completionBlock:(ZHAuthCompletionBlock)block{
    
    if ([account length] >0 && [password length] >0) {
        __weak __typeof(self) weakSelf = self;

        [HttpClient postDataWithParamers:@{@"scene": @"26",@"phone":account,@"password":password} success:^(id responseObject) {
            BOOL result = [((BaseModel*)[BaseModel praserModelWithInfo:responseObject]).state boolValue];
            if (result) {
                weakSelf.account  = account;
                weakSelf.passWord = password;
                [weakSelf setAccountInfo];
            }
            if (block) {
                block(result,nil);
            }

        } failure:^(NSError *error) {
            if (block){
                block(NO,nil);
            }
            
        }];
    }
}

- (void)logInWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block
{
    if ([account length] >0 && [password length] >0) {
        __weak __typeof(self) weakSelf = self;
        
        [HttpClient postDataWithParamers:@{@"scene": @"23",@"phone":account,@"password":password} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                weakSelf.userId         = [NSString stringWithFormat:@"%d",[[responseObject objectForKey:@"userId"]intValue]];
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
        } failure:^(NSError *error) {
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
