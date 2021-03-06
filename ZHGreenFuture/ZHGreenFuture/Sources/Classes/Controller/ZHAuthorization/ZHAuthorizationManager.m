//
//  ZHAuthorizationManager.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationManager.h"
#import "ZHProfileModel.h"


#define kAccountInfo					@"kAccountInfo"
#define kPassWordInfo					@"kPassWordInfo"
#define kNickNameInfo					@"kNickNameInfo"
#define kUserIdInfo                     @"kUserIdInfo"
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
        self.userId   = [userDefault objectForKey:kUserIdInfo];
        self.userNick = [userDefault objectForKey:kNickNameInfo];
	}
	return self;
}

- (void)dealloc
{
	self.account  = nil;
	self.passWord = nil;
    self.userId   = nil;
    self.userNick = nil;
}

#pragma mark - Getter & Setter 
- (void)setUserNick:(NSString *)userNick{
    /// add by kongkong for Null Exception
    if (isEmptyString(userNick)){
        userNick = @"";
    }
    
    if (_userNick != userNick) {
        _userNick = userNick;
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_userNick forKey:kNickNameInfo];
        [userDefault synchronize];
    }
}

#pragma mark - Public Methods
- (BOOL)isLogin {
    /// modify by kongkong
    return !isEmptyString(self.userId);
//    return [self.passWord length] >0;
}

- (void)getValidateCodeWithAccount:(NSString*)account completionBlock:(ZHAuthCompletionBlock)block{
    if ([account length] >0 ) {

        [HttpClient postDataWithParamers:@{@"scene": @"24",@"phone":account} success:^(id responseObject) {
            BOOL result = [((BaseModel*)[BaseModel praserModelWithInfo:responseObject]).state boolValue];
            if (block) {
                block(result,[responseObject objectForKey:@"errorMsg"]);
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
                weakSelf.userId   = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"userId"]];
                weakSelf.userNick = [account length] <= 4 ? account : [account substringFromIndex:[account length]-4];
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
                /// modify by kongkong for Null Exception
                if (isEmptyString(weakSelf.userNick)) {
                   weakSelf.userNick = [account length] <= 4 ? account : [account substringFromIndex:[account length]-4];
                }
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

- (void)logout{
    [ZHProfileModel resetUserInfo];
    [self resetAccountInfo];
    self.isLogin = NO;
    self.account = nil;
    self.passWord = nil;
    self.userId  = nil;
    self.userNick = nil;
    self.userAvatarURL = nil;
}


#pragma mark - Private
- (void)setAccountInfo
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:YES			 forKey:kisHaveRegisterAccount];
	[userDefault setObject:self.account  forKey:kAccountInfo];
	[userDefault setObject:self.passWord forKey:kPassWordInfo];
    [userDefault setObject:self.userNick forKey:kNickNameInfo];
    [userDefault setObject:self.userId   forKey:kUserIdInfo];
	[userDefault synchronize];
}

- (void)resetAccountInfo
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:NO			 forKey:kisHaveRegisterAccount];
	[userDefault removeObjectForKey:kAccountInfo];
	[userDefault removeObjectForKey:kPassWordInfo];
    [userDefault removeObjectForKey:kNickNameInfo];
    [userDefault removeObjectForKey:kUserIdInfo];
	[userDefault synchronize];
}


@end
