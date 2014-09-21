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
//@property(nonatomic, strong)NSString *account;
//@property(nonatomic, strong)NSString *passWord;
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

- (void)registerWithAccount:(NSString*)account password:(NSString*)password referral:(NSString*)referral completionBlock:(ZHAuthCompletionBlock)block{
   /*
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@RegUser", kBaseURLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    //post json
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:account forKey:@"userID"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:referral forKey:@"referral"];
    
    __weak __typeof(self) weakSelf = self;
    [httpClient postPath:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([responseStr isEqualToString:@"注册成功"]) {
                weakSelf.account  = account;
                weakSelf.passWord = password;
                [weakSelf setAccountInfo];
                if (block) {
                    block(YES, @"注册成功");
                }
                return ;
            }
            NSLog(@"Request Successful, response '%@'", responseStr);
        }
        if (block) {
            block(NO, responseStr);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error);
        if (block) {
            block(NO, [error description]);
        }
        
    }];
    */
}

- (void)logInWithAccount:(NSString*)account password:(NSString*)password completionBlock:(ZHAuthCompletionBlock)block
{
    /*
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@Login", kBaseURLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    //post json
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:account forKey:@"userID"];
    [params setObject:password forKey:@"pwd"];
    
    __weak __typeof(self) weakSelf = self;
    [httpClient postPath:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            weakSelf.account  = account;
            weakSelf.passWord = password;
            [weakSelf setAccountInfo];
            if (block) {
                block(YES, responseDict);
            }
        } else {
            if (block) {
                block(NO, nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error);
        if (block) {
            block(NO, [error description]);
        }
    }];
    */
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
